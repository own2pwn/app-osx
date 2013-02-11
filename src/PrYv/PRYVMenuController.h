//
//  PRYVMenuController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PRYVNewNoteController, PRYVFileController;


@interface PRYVMenuController : NSObject {
@private
	PRYVNewNoteController *newNoteController;
	PRYVFileController *fileController;
}

-(PRYVMenuController*)init;
-(IBAction)newNote:(id)sender;
-(IBAction)displayCurrentUser:(id)sender;
-(IBAction)goToMyPryv:(id)send;
-(IBAction)openFiles:(id)sender;

@end
