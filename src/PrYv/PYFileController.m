//
//  PRYVFileController.m
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYFileController.h"
#import "PYAppDelegate.h"
#import "File.h"
#import "User.h"
#import "User+Helper.h"
#import "NSString+Helper.h"
#import "NSMutableArray+Helper.h"
#import "PryvedEvent.h"
#import "Constants.h"
#import "PYUtility.h"

@interface PYFileController ()

-(void)pryvFilesThread:(NSDictionary*)args;
-(void)constructFilesArray:(NSMutableArray*)array
                  withFile:(NSString*)file
               inSubfolder:(NSString*)subfolder;
-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                          inArray:(NSMutableArray *)streamNames
               withLevelDelimiter:(NSString *)delimiter
                          forUser:(User *)user
                          atIndex:(NSUInteger)index;
-(void)pryvGPSEventAtLongitude:(NSString*)longitude
                      latitude:(NSString*)latitude
                    inStreamId:(NSString*)streamId
                      withTags:(NSArray*)tags
                        atTime:(NSTimeInterval)time;
-(void)pryvLocationIfAnyForFile:(NSString*)path
                     inStreamId:(NSString*)streamId
                       withTags:(NSArray*)tags
                         atTime:(NSTimeInterval)time;


@end

@implementation PYFileController

-(id)initWithOpenPanel:(NSOpenPanel *)openDialog {
	self = [super init];
	if (self) {
        _popUpButtonContent = [[NSArrayController alloc] init];
		_openDialog = openDialog;
		[_openDialog setCanChooseFiles:YES];
		[_openDialog setAllowsMultipleSelection:YES];
		[_openDialog setCanChooseDirectories:YES];
		[_openDialog setCanCreateDirectories:NO];
		[_openDialog setResolvesAliases:YES];
		_threadLock = [[NSLock alloc] init];
	}
	return self;
}

#pragma mark - Pryv Files

-(void)runDialog {

    //Add the fields for the tags and the folder
	if ([NSBundle loadNibNamed:@"OpenPanelWithTagsAndFolder" owner:self])
		[_openDialog setAccessoryView:_accessoryView];
	
    //Get the stream names list and fill the popup button
	User* current = [User currentUser];
    current.streams = [[NSMutableDictionary alloc] init];
    PYUtility *utility = [[PYUtility alloc] init];
    [utility setupStreamPopUpButton:_streams withArrayController:_popUpButtonContent forUser:current];
    
	//Handle result 
	[_openDialog beginWithCompletionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			
            //Get the stream
			NSString* streamId;
			if ([[_streams titleOfSelectedItem] isEqualTo:@""]) {
				streamId = @"diary";
			}else {
//				NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
				NSString *streamIndex = [NSString stringWithFormat:@"%lu",[_streams indexOfSelectedItem]];
                streamId = [[current streams] objectForKey:streamIndex];
			}
            
			NSArray *files = [_openDialog URLs];
            
			[self pryvFiles:files inStreamId:streamId withTags:[_tags objectValue]];
            
		}else{
            [current.streams release];
            current.streams = nil;
        }
		[_openDialog release];//Mac OS X 10.6 fix		
	}];
}

-(void)pryvFiles:(NSArray *)files inStreamId:(NSString *)streamId withTags:(NSArray *)tags {
    
	NSArray *objects = [NSArray arrayWithObjects: files, tags, streamId, nil];
	NSArray *keys = [NSArray arrayWithObjects:@"files",@"tags",@"stream", nil];
	NSDictionary *arguments = [NSDictionary dictionaryWithObjects:objects
                                                          forKeys:keys];
    [NSThread detachNewThreadSelector:@selector(pryvFilesThread:)
                             toTarget:self
                           withObject:arguments];
}

#pragma mark -
#pragma mark Private Methods

-(void)pryvFilesThread:(NSDictionary *)args {
	[_threadLock lock];
	@autoreleasepool {
		NSArray *files = [NSArray arrayWithArray:[args objectForKey:@"files"]];
		NSArray *tags = [NSArray arrayWithArray:[args objectForKey:@"tags"]];
		NSString *streamId = [NSString stringWithString:[args objectForKey:@"stream"]];
        NSDate *currentTime = [NSDate date];
		
        //Construct the array of files @filesToSend recursively
		//The hierarchical structure is kept in the filename
		NSMutableArray *filesToSend = [[NSMutableArray alloc] init];
        for (NSURL *fileUrl in files){
			[self constructFilesArray:filesToSend withFile:[fileUrl path] inSubfolder:@""];
        }
        
        NSMutableArray *attachments = [[NSMutableArray alloc] init];
        for(File *f in filesToSend){
            [self pryvLocationIfAnyForFile:[f path]
                                inStreamId:streamId
                                  withTags:tags
                                    atTime:[currentTime timeIntervalSince1970]];
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:[f path]];
            //NSLog(@"Length : %lu", (unsigned long)[fileData length]);
            PYAttachment *attachment = [[PYAttachment alloc] initWithFileData:fileData
                                                                         name:[[f filename] stringByDeletingPathExtension]
                                                                     fileName:[f filename]];
            [attachments addObject:attachment];
        }
        
        PYEvent *event = [[PYEvent alloc] init];
        
        NSString *notificationTitle;
        NSString *notificationText;
        if ([filesToSend areAllImages]){
            event.type = @"picture/attached";
            notificationTitle = @"Pictures pryved succesfully.";
            notificationText = [NSString stringWithFormat:@"Your pictures including \"%@\" have been pryved.",[(PYAttachment*)[attachments objectAtIndex:0] fileName]];
        }
        else if ([attachments count] > 1){
            event.type = @"file/attached-multiple";
            notificationTitle = @"Files pryved succesfully.";
            notificationText = [NSString stringWithFormat:@"Your files including \"%@\" have been pryved.",[(PYAttachment*)[attachments objectAtIndex:0] fileName]];
        }
        else{
            event.type = @"file/attached";
            notificationTitle = @"File pryved succesfully.";
            notificationText = [NSString stringWithFormat:@"Your file \"%@\" have been pryved.",[(PYAttachment*)[attachments objectAtIndex:0] fileName]];
        }
        
        event.streamId = streamId;
        [event setEventDate:[NSDate date]];
        event.tags = [NSArray arrayWithArray:tags];
        event.attachments = [NSMutableArray arrayWithArray:attachments];
        
        User *current = [User currentUser];
        
        //Sync request because otherwise thread dies before request is sent. However this is not a
        //problem since only the current thread is blocked by the sync request and this is the last
        //instruction before releasing everything.
        
        [[current connection] eventCreate:event  successHandler:^(NSString *newEventId, NSString *stoppedId, PYEvent *event) {
            NSLog(@"New event ID : %@",newEventId);
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = [NSString stringWithString:notificationTitle];
            notification.informativeText = [NSString stringWithString:notificationText];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
            
            //Add file event to last pryved event list.
            /*X2
            PryvedEvent *pryvedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"PryvedEvent"
                                                                     inManagedObjectContext:context];
            NSDate *currentDate = [NSDate date];
            NSString *filename;
            if ([filesToSend count] > 1) {
                filename = @"Folder";
            }else{
                filename = [NSString stringWithString:[[filesToSend objectAtIndex:0] filename]];
            }
            pryvedEvent.date = currentDate;
            pryvedEvent.eventId = [NSString stringWithString:newEventId];
            pryvedEvent.type = [NSString stringWithString:kPYLastPryvedEventFile];
            pryvedEvent.content = [NSString stringWithString:filename];
            
            [current addPryvedEventsObject:pryvedEvent];
            [context save:nil];
            */
        } errorHandler:^(NSError *error) {
            NSLog(@"%@",error);
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Problem while pryving files.";
            notification.informativeText = [NSString stringWithFormat:@"%@",[[error userInfo] valueForKey:NSLocalizedDescriptionKey]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }];
        
        [filesToSend release];
        [event release];
        [current.streams release];
	}
	[_threadLock unlock];
}

//Recursively add files with their hierarchical structure to the array
-(void)constructFilesArray:(NSMutableArray*)array withFile:(NSString*)file inSubfolder:(NSString*)subfolder {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:file error:nil];
	
    //If it is a directory
	if ([fileAttributes valueForKey:NSFileType] == NSFileTypeDirectory) {
		NSError *error = nil;
		NSArray *folderContent = [fileManager contentsOfDirectoryAtPath:file
                                                                  error:&error];
		if(folderContent == nil) {
			NSLog(@"Directory %@ couldn't be open : %@",file, error);
		}else {
			NSString *folderName = [[file lastPathComponent] stringByAppendingString:@"/"];
			[folderContent enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				if ([obj characterAtIndex:0] != '.') {
					[self constructFilesArray:array
                                                   withFile:[file stringByAppendingPathComponent:obj]
                                                inSubfolder:folderName];
				}
			}];
		}
	
    //If it is a file
	} else {
		
        //Create a file object to add in the array
        
//		File *newFile = [NSEntityDescription insertNewObjectForEntityForName:@"File"
//                                                      inManagedObjectContext:context];
        
        File *newFile = [[[File alloc] init] autorelease];
		
        //Add the subfolder before the file name to trace the hierarchical structure
		newFile.filename = [subfolder stringByAppendingPathComponent:[file lastPathComponent]];
		newFile.path = [NSString stringWithString:file];
		newFile.size = [NSNumber numberWithLongLong:[fileAttributes fileSize]];
        NSString* mimeType = [NSString mimeTypeFromFileExtension:newFile.filename];
		newFile.mimeType = [NSString stringWithString:mimeType];
        newFile.isPicture = [NSNumber numberWithBool:[mimeType isPicture]];
        [array addObject:newFile];
        
        NSLog(@"File : %@",newFile);
		}
}

-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                          inArray:(NSMutableArray *)streamNames
               withLevelDelimiter:(NSString *)delimiter
                          forUser:(User *)user
                          atIndex:(NSUInteger)index
{
    for (PYStream *stream in streams){
        [user.streams setObject:[stream streamId] forKey:[NSString stringWithFormat:@"%lu",index]];
        index++;
        [streamNames addObject:[NSString stringWithFormat:@"%@%@",delimiter,stream.name]];
        if ([stream.children count] > 0) {
            index = [self createStreamNameForStreams:stream.children inArray:streamNames withLevelDelimiter:@"- " forUser:user atIndex:index];
            
        }
    }
    
    return index;

}

-(void)pryvLocationIfAnyForFile:(NSString*)path
                     inStreamId:(NSString *)streamId
                       withTags:(NSArray *)tags
                         atTime:(NSTimeInterval)time
{
    NSURL *imageFileURL = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)imageFileURL, NULL);
    if (imageSource == NULL) {
        NSLog(@"Error loading image in memory.");
    }
    else{
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                                 nil];
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (CFDictionaryRef)options);
        
        if (imageProperties) {
            CFDictionaryRef gps = CFDictionaryGetValue(imageProperties, kCGImagePropertyGPSDictionary);
            if (gps) {
                NSString *latitudeString = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLatitude);
                NSString *latitudeRef = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLatitudeRef);
                NSString *longitudeString = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLongitude);
                NSString *longitudeRef = (NSString *)CFDictionaryGetValue(gps, kCGImagePropertyGPSLongitudeRef);
                
                //Longitude
                NSString *longitude;
                if ([longitudeRef isEqualToString:@"W"])
                    longitude = [NSString stringWithFormat:@"-%@",longitudeString];
                else
                    longitude = [NSString stringWithFormat:@"%@",longitudeString];
                
                //Latitude
                NSString *latitude;
                if ([latitudeRef isEqualToString:@"S"])
                    latitude = [NSString stringWithFormat:@"-%@",latitudeString];
                else
                    latitude = [NSString stringWithFormat:@"%@",latitudeString];
                
                //NSLog(@"GPS Coordinates: %@ / %@", longitude, latitude);
                [self pryvGPSEventAtLongitude:longitude
                                     latitude:latitude
                                   inStreamId:streamId
                                     withTags:tags
                                       atTime:time];
                
                CFRelease(gps);
            }
            CFRelease(imageProperties);
        }
    }    
}

-(void)pryvGPSEventAtLongitude:(NSString*)longitude
                      latitude:(NSString*)latitude
                    inStreamId:(NSString*)streamId
                      withTags:(NSArray*)tags
                        atTime:(NSTimeInterval)time
{
    PYEvent *event = [[PYEvent alloc] init];
    event.streamId = [NSString stringWithString:streamId];
    [event setEventDate:[NSDate date]];
    event.tags = [NSArray arrayWithArray:tags];
    event.type = @"position/wgs84";
    NSNumber *longitudeNumber = [NSNumber numberWithDouble:[longitude doubleValue]];
    NSNumber *latitudeNumber = [NSNumber numberWithDouble:[latitude doubleValue]];
    event.eventContent = [NSDictionary dictionaryWithObjectsAndKeys:latitudeNumber,@"latitude",longitudeNumber,@"longitude", nil];
    
    User *current = [User currentUser];
   
    [[current connection] eventCreate:event successHandler:^(NSString *newEventId, NSString *stoppedId, PYEvent *event) {
        NSLog(@"New location event : %@", newEventId);
    } errorHandler:^(NSError *error) {
        NSLog(@"Error when pryving GPS event : %@", error);
    }];
}

//Returns path of Caches directory
-(NSString*)findCachesDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

//Copy the file in the Caches directory so that we don't manipulate the original object
-(void)cacheFile:(NSString*)file atPath:(NSString*)path success:(void (^)(void))block{
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileManager copyItemAtPath:file
                              toPath:path
                               error:&error]) {
        NSLog(@"File %@ couldn't be copied : %@",file, error);
    } else {
        NSLog(@"File %@ copied !",file);
        block();
    }

}

-(void)dealloc {
    [_popUpButtonContent release];
	[_threadLock release];
	[super dealloc];
}
@end
