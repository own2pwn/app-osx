//
//  StatusMenuViewController.h
//  Pryv
//
//  Created by Victor Kristof on 12.06.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AXStatusItemPopup.h"

@class PYNewNoteController, PYLoginController, AXStatusItemPopup;

@interface StatusMenuViewController : NSViewController <NSWindowDelegate, NSMenuDelegate, NSTextDelegate, AXStatusItemPopupDelegate>
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
@property (assign) IBOutlet NSTextField *noteTextField;
@property (assign) IBOutlet NSButton *pryvNoteButton;
@property (assign) IBOutlet NSPopUpButton *streamsPopUpButton;
@property (assign) IBOutlet NSTokenField *tagsTokenField;

- (IBAction)showMoreActions:(id)sender;
- (IBAction)logInOrOut:(id)sender;
- (IBAction)goToMyPryv:(id)sender;
- (IBAction)pryvNote:(id)sender;
-(void)updateMenuItemsLogin:(NSNotification*)notification;
-(void)updateMenuItemsLogout:(NSNotification*)notification;

@end
