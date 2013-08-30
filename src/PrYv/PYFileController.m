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

@interface PYFileController ()

-(void)pryvFilesThread:(NSDictionary*)args;
-(void)constructFilesArray:(NSMutableArray*)array
                  withFile:(NSString*)file
               inSubfolder:(NSString*)subfolder;

@end

@implementation PYFileController

-(id)initWithOpenPanel:(NSOpenPanel *)openDialog {
	self = [super init];
	if (self) {
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
	
    //Get the folder names list and fill the popup button
	User* current = [User currentUserInContext:context];
	NSArray *folderNames = [current folderNames];
	[_folder addItemsWithTitles: folderNames];
	
	//Handle result 
	[_openDialog beginWithCompletionHandler:^(NSInteger result){
		if (result == NSFileHandlingPanelOKButton) {
			
            //Get the tags for the event
			NSMutableSet *newTags = [[NSMutableSet alloc] init];
			[[_tags objectValue] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				[newTags addObject:[Tag tagWithValue:obj inContext:context]];
			}];
			
            //Get the folder
			NSString* folderName;
			if ([[_folder titleOfSelectedItem] isEqualTo:@"None"]) {
				folderName = @"";
			}else {
				folderName = [NSString stringWithString:[_folder titleOfSelectedItem]];
			}
			NSArray *files = [_openDialog URLs];
			
			[self pryvFiles:files withTags:[newTags autorelease] andFolderName:folderName];
//            NSString *file = [[files objectAtIndex:0] path];
//            NSLog(@"File : %@",file);
//            NSData *pictureData = [[NSData alloc] initWithContentsOfFile:file];
//            NSLog(@"Length : %lu", (unsigned long)[pictureData length]);
//            PYAttachment *attachment = [[PYAttachment alloc] initWithFileData:pictureData
//                                                                         name:@"My chicken picture"
//                                                                     fileName:@"chicken.jpg"];
//            
//            PYEvent *event = [[PYEvent alloc] init];
//            event.folderId = @"notes";
//            event.eventClass = @"picture";
//            event.eventFormat = @"attached";
//            event.attachments = [NSMutableArray arrayWithObject:attachment];
//            
//            NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
//            User *current = [User currentUserInContext:context];
//            PYAccess *access = [current access];
//            __block PYChannel *diaryChannel;
//            [access getAllChannelsWithRequestType:PYRequestTypeAsync gotCachedChannels:^(NSArray *cachedChannelList) {
//                [cachedChannelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                    if ([[obj channelId] isEqualToString:@"diary"]) {
//                        diaryChannel = [obj retain];
//                    }
//                }];
//            } gotOnlineChannels:^(NSArray *onlineChannelList) {
//                [onlineChannelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { }];
//            } errorHandler:^(NSError *error) {
//                NSLog(@"Error : %@",error);
//            }];
//            NSLog(@"Channel : %@",[diaryChannel channelId]);
//            
//            [diaryChannel createEvent:event requestType:PYRequestTypeAsync successHandler:^(NSString *newEventId, NSString *stoppedId) {
//                NSLog(@"New Event ID : %@", newEventId);
//                NSLog(@"Stopped ID : %@", stoppedId);
//            } errorHandler:^(NSError *error) {
//                NSLog(@"Error : %@", error);
//            }];
		}
		[_openDialog release];//Mac OS X 10.6 fix		
	}];
}

-(void)pryvFiles:(NSArray *)files withTags:(NSSet *)tags andFolderName:(NSString *)folderName {
    
	NSArray *objects = [NSArray arrayWithObjects: files, tags, folderName, nil];
	NSArray *keys = [NSArray arrayWithObjects:@"files",@"tags",@"folder", nil];
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
		NSSet *newTags = [NSSet setWithSet:[args objectForKey:@"tags"]];
		[newTags retain];
		NSString *folderName = [NSString stringWithString:[args objectForKey:@"folder"]];
		[folderName retain];
		
        //Construct the array of files @filesToSend recursively
		//The hierarchical structure is kept in the filename
		NSMutableArray *filesToSend = [[NSMutableArray alloc] init];
		[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[self constructFilesArray:filesToSend withFile:[obj path] inSubfolder:@""];
		}];
		
		NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
		User *current = [User currentUserInContext:context];
		PYConnection *connection = [current connection];
        
        NSMutableArray *attachments = [[NSMutableArray alloc] init];
        [filesToSend enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
            NSData *fileData = [NSData dataWithContentsOfFile:file];
            NSString *filename = [file lastPathComponent];
            NSString *name = [filename stringByDeletingPathExtension];
            PYAttachment *attachment = [[PYAttachment alloc] initWithFileData:fileData
                                                           name:@"My chicken picture"
                                                       fileName:@"chicken.jpg"];
        }];
//        NSData *pictureData = [[NSData alloc] initWithContentsOfFile:file];
//        NSLog(@"Length : %lu", (unsigned long)[pictureData length]);
        
//
//        PYEvent *event = [[PYEvent alloc] init];
//        event.folderId = @"notes";
//        event.eventClass = @"picture";
//        event.eventFormat = @"attached";
//        event.attachments = [NSMutableArray arrayWithObject:attachment];
//        
//        NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
//        User *current = [User currentUserInContext:context];
//        PYAccess *access = [current access];
//        __block PYChannel *diaryChannel;
//        [access getAllChannelsWithRequestType:PYRequestTypeAsync gotCachedChannels:^(NSArray *cachedChannelList) {
//            [cachedChannelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                if ([[obj channelId] isEqualToString:@"diary"]) {
//                    diaryChannel = [obj retain];
//                }
//            }];
//        } gotOnlineChannels:^(NSArray *onlineChannelList) {
//            [onlineChannelList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { }];
//        } errorHandler:^(NSError *error) {
//            NSLog(@"Error : %@",error);
//        }];
//        NSLog(@"Channel : %@",[diaryChannel channelId]);
//        
//        [diaryChannel createEvent:event requestType:PYRequestTypeAsync successHandler:^(NSString *newEventId, NSString *stoppedId) {
//            NSLog(@"New Event ID : %@", newEventId);
//            NSLog(@"Stopped ID : %@", stoppedId);
//        } errorHandler:^(NSError *error) {
//            NSLog(@"Error : %@", error);
//        }];

		
		
		
		[context save:nil];
		[filesToSend release];
		[newTags release];
		[folderName release];
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
        [array addObject:newFile];
        
        NSLog(@"File : %@",newFile);
		}
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
	[_threadLock release];
	[super dealloc];
}
@end
