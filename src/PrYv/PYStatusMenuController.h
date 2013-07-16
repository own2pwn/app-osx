//
//  PRYVMenuController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DragAndDropStatusMenuView.h"

@class PYNewNoteController, PYFileController;

@interface PYStatusMenuController : NSViewController {
@private
	PYNewNoteController *_newNoteController;
	PYFileController *_fileController;
	IBOutlet NSMenu *_statusMenu;
	NSStatusItem *_statusItem;

}

-(PYStatusMenuController*)init;
-(IBAction)newNote:(id)sender;
-(IBAction)displayCurrentUser:(id)sender;
-(IBAction)goToMyPryv:(id)sender;
-(IBAction)openFiles:(id)sender;
-(IBAction)purgeEvents:(id)sender;
-(void)showMenu;
@end

