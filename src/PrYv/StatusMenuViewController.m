//
//  StatusMenuViewController.m
//  Pryv
//
//  Created by Victor Kristof on 12.06.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import "StatusMenuViewController.h"
#import "User.h"
#import "User+Helper.h"
#import "PYLoginController.h"
#import "PYAppDelegate.h"
#import "AXStatusItemPopup.h"
#import "Constants.h"
#import "PYLoginController.h"

@interface StatusMenuViewController ()

@end

@implementation StatusMenuViewController

@synthesize statusItemPopup = _statusItemPopup;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateMenuItemsLogin:)
                                                     name:PYLoginSuccessfullNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateMenuItemsLogout:)
                                                     name:PYLogoutSuccessfullNotification
                                                   object:nil];
    }
    return self;
}


#pragma mark - Actions

- (IBAction)showMoreActions:(id)sender {
    //Source :
    //http://praveenmatanam.wordpress.com/2008/09/05/how-to-popup-context-menu-when-clicked-on-button/
    
    NSRect frame = [(NSButton *)sender frame];
    NSPoint menuOrigin = [[(NSButton *)sender superview]
                          convertPoint:NSMakePoint(frame.origin.x+20, frame.origin.y+10)
                                toView:nil];
    
    NSEvent *event =  [NSEvent mouseEventWithType:NSLeftMouseDown
                                         location:menuOrigin
                                    modifierFlags:NSLeftMouseDownMask // 0x100
                                        timestamp:NSTimeIntervalSince1970
                                     windowNumber:[[(NSButton *)sender window] windowNumber]
                                          context:[[(NSButton *)sender window] graphicsContext]
                                      eventNumber:0
                                       clickCount:1
                                         pressure:1];
    
    [NSMenu popUpContextMenu:_moreActionsMenu withEvent:event forView:(NSButton *)sender];
    
    
}

- (IBAction)logInOrOut:(id)sender {
    
    User * user = [User currentUser];
	//If no user has been found, open login window
	if (!user) {
        [NSApp activateIgnoringOtherApps:YES];
        _loginWindow = [[PYLoginController alloc]
                                           initForUser:user
                                           andStatusItem:_statusItemPopup.statusItem];
		[_loginWindow.window setDelegate:self];
		[_loginWindow showWindow:self];
        [_statusItemPopup hidePopover];
        
        //If the user has been found
	}else {
        [[PYAppDelegate sharedInstance] setConnected:NO];
        [_statusItemPopup hidePopover];
		[user logout];
        
    }
    
}


#pragma mark - WindowDelegate methods

-(void)windowDidBecomeKey:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        [_logInOrOut setEnabled:NO];
    }
}

-(void)windowWillClose:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        [_logInOrOut setEnabled:YES];
    }else if ([identifier isEqualToString:@"NewNote"]){
        [_newNoteController release];
        _newNoteController = nil;
    }
}

#pragma mark - View methods

-(void)updateMenuItemsLogin:(NSNotification*)notification{
    User *user = [User currentUser];
    NSString *title = [NSString stringWithFormat:@"Log out (%@)",[user username]];
    [_logInOrOut setTitle:title];
    //[newNote setEnabled:YES];
    //[pryvFiles setEnabled:YES];
    //[goToMyPryv setEnabled:YES];
    //[preferences setEnabled:YES];
}

-(void)updateMenuItemsLogout:(NSNotification*)notification{
    NSLog(@"Logged out.");
    [_logInOrOut setTitle:@"Log in"];
    //[newNote setEnabled:NO];
    //[pryvFiles setEnabled:NO];
    //[goToMyPryv setEnabled:NO];
    //[preferences setEnabled:NO];
}



@end
