//
//  PRYVMenuController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DragAndDropStatusMenuView.h"

@class PRYVNewNoteController, PRYVFileController;

@interface PRYVStatusMenuController : NSViewController {
@private
	PRYVNewNoteController *newNoteController;
	PRYVFileController *fileController;
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;

}
-(PRYVStatusMenuController*)init;
-(IBAction)newNote:(id)sender;
-(IBAction)displayCurrentUser:(id)sender;
-(IBAction)goToMyPryv:(id)send;
-(IBAction)openFiles:(id)sender;
-(IBAction)purgeEvents:(id)sender;
-(void)showMenu;
@end

