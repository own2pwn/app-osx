//
//  PRYVFileController.h
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

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
-(void)pryvFilesThread:(NSDictionary*)args;
+(void)constructFilesArray:(NSMutableArray*)array
                  withFile:(NSString*)file
               inSubfolder:(NSString*)subfolder;
@end
