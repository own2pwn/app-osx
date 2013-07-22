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
	IBOutlet NSMenu *_statusMenu;
    IBOutlet NSMenuItem *logInOrOut;
	NSStatusItem *_statusItem;
}

@property (assign) IBOutlet NSMenuItem *logInOrOut;

-(PYStatusMenuController*)init;
-(IBAction)newNote:(id)sender;
-(IBAction)displayCurrentUser:(id)sender;
-(IBAction)goToMyPryv:(id)sender;
-(IBAction)openFiles:(id)sender;
-(IBAction)purgeEvents:(id)sender;
- (IBAction)logInOrOut:(id)sender;
-(void)showMenu;
-(void)updateMenuItemsLogin:(NSNotification*)notification;
-(void)updateMenuItemsLogout:(NSNotification*)notification;
@end

