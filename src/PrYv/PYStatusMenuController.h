//
//  PRYVMenuController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DragAndDropStatusMenuView.h"

@class PYNewNoteController, PYFileController, PYLoginController;

@interface PYStatusMenuController : NSViewController <NSWindowDelegate>{
@private
	PYNewNoteController *_newNoteController;
	PYFileController *_fileController;
    PYLoginController *loginWindow;
	NSStatusItem *_statusItem;
	IBOutlet NSMenu *_statusMenu;
    IBOutlet NSMenuItem *logInOrOut;
    IBOutlet NSMenuItem *newNote;
    IBOutlet NSMenuItem *pryvFiles;
    IBOutlet NSMenuItem *displayCurrentUser;
    IBOutlet NSMenuItem *test;
    IBOutlet NSMenuItem *goToMyPryv;
    IBOutlet NSMenuItem *preferences;
}



-(PYStatusMenuController*)init;
-(IBAction)newNote:(id)sender;
-(IBAction)displayCurrentUser:(id)sender;
-(IBAction)goToMyPryv:(id)sender;
-(IBAction)openFiles:(id)sender;
-(IBAction)test:(id)sender;
- (IBAction)logInOrOut:(id)sender;
-(void)showMenu;
-(void)updateMenuItemsLogin:(NSNotification*)notification;
-(void)updateMenuItemsLogout:(NSNotification*)notification;
@end

