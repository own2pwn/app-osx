//
//  PRYVFileController.h
//  PrYv
//
//  Created by Victor Kristof on 01.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
@class File;
@interface PRYVFileController : NSObject{
@private
	NSOpenPanel* openDialog;
	NSLock *threadLock;
}

- (PRYVFileController*)initWithOpenPanel:(NSOpenPanel*)openDialog;
-(void) runDialog;
-(void) pryvFiles:(NSArray*)files;
+(void)constructFilesArray:(NSMutableArray*)array withFile:(NSString*)file inSubfolder:(NSString*)subfolder;
@end
