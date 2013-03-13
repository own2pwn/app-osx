//
//  PRYVFileController.h
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class File;

@interface PRYVFileController : NSObject {
@private
	IBOutlet NSTokenField *_tags;
	IBOutlet NSPopUpButton *_folder;
	IBOutlet NSView *_accessoryView;
	NSOpenPanel* _openDialog;
	NSLock *_threadLock;
}

-(PRYVFileController*)initWithOpenPanel:(NSOpenPanel*)openDialog;
-(void)runDialog;
-(void)pryvFiles:(NSArray*)files
        withTags:(NSSet*)tags
   andFolderName:(NSString*)folderName;

@end


@interface PRYVFileController ()

-(void)pryvFilesThread:(NSDictionary*)args;
-(void)constructFilesArray:(NSMutableArray*)array
                  withFile:(NSString*)file
               inSubfolder:(NSString*)subfolder;
-(NSString*) createsUniqueIDForFile:(File*)file;
-(NSString*)findCachesDirectory;
-(void)cacheFile:(NSString*)file atPath:(NSString*)path success:(void (^)(void))block;

@end