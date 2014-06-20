//
//  StatusMenuViewController.h
//  Pryv
//
//  Created by Victor Kristof on 12.06.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PYNewNoteController, PYLoginController, AXStatusItemPopup;

@interface StatusMenuViewController : NSViewController <NSWindowDelegate, NSMenuDelegate>
{
    
@private
    PYNewNoteController *_newNoteController;
    PYLoginController *_loginWindow;
    
}

@property (retain,nonatomic) AXStatusItemPopup *statusItemPopup;
@property (assign) IBOutlet NSMenuItem *logInOrOut;
@property (assign) IBOutlet NSButton *moreActionsButton;
@property (assign) IBOutlet NSMenu *moreActionsMenu;
@property (assign) IBOutlet NSButton *goToMyPryvButton;

- (IBAction)showMoreActions:(id)sender;
- (IBAction)logInOrOut:(id)sender;
- (IBAction)goToMyPryv:(id)sender;
-(void)updateMenuItemsLogin:(NSNotification*)notification;
-(void)updateMenuItemsLogout:(NSNotification*)notification;

@end
