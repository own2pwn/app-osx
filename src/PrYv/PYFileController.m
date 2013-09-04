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
#import "Tag.h"
#import "Tag+Helper.h"
#import "Folder.h"
#import "Folder+Helper.h"
#import "FileEvent.h"
#import "PryvApiKit.h"
#import "NSMutableArray+Helper.h"

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

#pragma mark -
#pragma mark Pryv Files

-(void)runDialog {
	NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
	
    //Add the fields for the tags and the folder
	if ([NSBundle loadNibNamed:@"OpenPanelWithTagsAndFolder" owner:self])
		[_openDialog setAccessoryView:_accessoryView];
	
    //Get the stream names list and fill the popup button
	User* current = [User currentUserInContext:context];
    current.streams = [[NSMutableDictionary alloc] init];
    [[current connection] getAllStreamsWithRequestType:PYRequestTypeAsync gotCachedStreams:^(NSArray *cachedStreamsList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:cachedStreamsList inArray:streamNames withLevelDelimiter:@"" forUser:current atIndex:0];
        
        NSRange range = NSMakeRange(0, [[_popUpButtonContent arrangedObjects] count]);
        [_popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_popUpButtonContent addObjects:streamNames];
        [_streams selectItemAtIndex:0];
        
        [streamNames release];
        
    } gotOnlineStreams:^(NSArray *onlineStreamList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:onlineStreamList inArray:streamNames withLevelDelimiter:@"" forUser:current atIndex:0];
        
        NSRange range = NSMakeRange(0, [[_popUpButtonContent arrangedObjects] count]);
        [_popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_popUpButtonContent addObjects:streamNames];
        [_streams selectItemAtIndex:0];
        
        [streamNames release];

    } errorHandler:^(NSError *error) {
        NSLog(@"%@",error);
    }];    
	
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
        NSLog(@"Stream ID : %@", streamId);
		
        //Construct the array of files @filesToSend recursively
		//The hierarchical structure is kept in the filename
		NSMutableArray *filesToSend = [[NSMutableArray alloc] init];
        for (NSURL *fileUrl in files){
			[self constructFilesArray:filesToSend withFile:[fileUrl path] inSubfolder:@""];
        }
        
        NSMutableArray *attachments = [[NSMutableArray alloc] init];
        for(File *f in filesToSend){
            NSData *fileData = [[NSData alloc] initWithContentsOfFile:[f path]];
            NSLog(@"Length : %lu", (unsigned long)[fileData length]);
            PYAttachment *attachment = [[PYAttachment alloc] initWithFileData:fileData
                                                                         name:[[f filename] stringByDeletingPathExtension]
                                                                     fileName:[f filename]];
            [attachments addObject:attachment];
        }
        
        NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
        User *current = [User currentUserInContext:context];
        
        PYEvent *event = [[PYEvent alloc] init];
        
        if ([filesToSend areAllImages]) event.type = @"picture/attached";
        else if ([attachments count] > 1) event.type = @"file/attached-multiple";
        else event.type = @"file/attached";
        
        event.streamId = streamId;
        event.time = NSTimeIntervalSince1970;
        event.tags = [NSArray arrayWithArray:tags];
        event.attachments = [NSMutableArray arrayWithArray:attachments];
        
        [PYClient setDefaultDomainStaging];
        
        NSLog(@"EVENT TYPE : %@", event.type);
        
        //Sync request because otherwise thread dies before request is sent. However this is not a
        //problem since only the current thread is blocked by the sync request and this is the last
        //instruction before releasing everything.
        [[current connection] createEvent:event requestType:PYRequestTypeSync successHandler:^(NSString *newEventId, NSString *stoppedId) {
            NSLog(@"New event ID : %@",newEventId);
        } errorHandler:^(NSError *error) {
            NSLog(@"%@",error);
            NSLog(@"UserInfo: %@",[error userInfo]);
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
		NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
		
        //Create a file object to add in the array
		File *newFile = [NSEntityDescription insertNewObjectForEntityForName:@"File"
                                                      inManagedObjectContext:context];
		
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

//Create unique id to store the file in the Caches directory
-(NSString*)createsUniqueIDForFile:(File*)file {
    return [[[[file objectID] URIRepresentation] relativeString] lastPathComponent];
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
