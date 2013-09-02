//
//  PRYVFileController.h
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class File;

@interface PYFileController : NSObject {
@private
	IBOutlet NSTokenField *_tags;
	IBOutlet NSPopUpButton *_streams;
	IBOutlet NSView *_accessoryView;
	NSOpenPanel* _openDialog;
	NSLock *_threadLock;
}

-(PYFileController*)initWithOpenPanel:(NSOpenPanel*)openDialog;
-(void)runDialog;
-(void)pryvFiles:(NSArray*)files
        inStreamId:(NSString*)streamId
   withTags:(NSArray*)tags;

@end