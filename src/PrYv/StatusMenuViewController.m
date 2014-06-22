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

-(void)awakeFromNib{
    
    [_noteTextField setFocusRingType:NSFocusRingTypeNone];
    
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
    
    User *user = [User currentUser];
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

- (IBAction)goToMyPryv:(id)sender {
    NSString *username = [[[User currentUser] username] copy];
    
    NSString* domain = @"pryv.me";
    if ([[PYClient defaultDomain] isEqualToString:@"pryv.in"]) {
        domain = @"pryv.li";
    };
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@.%@/",username, domain];
	NSURL *url = [NSURL URLWithString:urlString];
	if(![[NSWorkspace sharedWorkspace] openURL:url])
		NSLog(@"Failed to open url: %@",[url description]);
    
    [_statusItemPopup hidePopover];

}

- (IBAction)pryvNote:(id)sender {
    if (![[_noteTextField stringValue] isEqualToString:@""]) {
        NSLog(@"Pryv note : %@", [_noteTextField stringValue]);
        [_noteTextField setStringValue:@""];
    }
    
}

#pragma mark - NSTextDelegate methods

- (void)controlTextDidBeginEditing:(NSNotification *)aNotification{
    [_pryvNoteButton setHidden:NO];
    [_streamsPopUpButton setHidden:NO];
    [_tagsTokenField setHidden:NO];
}

-(void)controlTextDidEndEditing:(NSNotification *)aNotification{
    [_pryvNoteButton setHidden:YES];
    [_streamsPopUpButton setHidden:YES];
    [_tagsTokenField setHidden:YES];
}

- (BOOL)control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL result = NO;
    NSEvent *event = [NSApp currentEvent];
    
    if (commandSelector == @selector(insertNewline:))
    {
        // new line action:
        // always insert a line-break character and don’t cause the receiver to end editing
        [textView insertNewlineIgnoringFieldEditor:self];
        result = YES;
    }
    else if (commandSelector == @selector(insertTab:))
    {
        // tab action:
        // always insert a tab character and don’t cause the receiver to end editing
        [textView insertTabIgnoringFieldEditor:self];
        result = YES;
    }
    else if (([event modifierFlags] & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask && [[event characters] isEqual:@"\r"])
    {
        // pryv note on CMD+Enter
        [self performSelector:@selector(pryvNote:)];
        result = YES;
    }
    return result;
}

#pragma mark - AXStatusItemPopupDelegate methods

-(void)popupDidClose{
    NSLog(@"Popup closed.");
}

-(void)popupWillClose{
    NSLog(@"Pop closing...");
    [_pryvNoteButton setHidden:YES];
}

#pragma mark - WindowDelegate methods

-(void)windowDidBecomeKey:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        
    }
}

-(void)windowWillClose:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        
    }
    //Normally don't need it with new layout (popover)
//    else if ([identifier isEqualToString:@"NewNote"]){
//        [_newNoteController release];
//        _newNoteController = nil;
//    }
}

#pragma mark - MenuDelegate methods

-(void)menuWillOpen:(NSMenu *)menu{
    
    User *user = [User currentUser];
    NSString *logOutTitle;
    if ([[PYAppDelegate sharedInstance] connected])
        logOutTitle = [NSString stringWithFormat:@"Log out (%@)", user.username];
    else
        logOutTitle = @"Log in";
    
    [_logInOrOut setTitle:logOutTitle];
    
    if ([[PYAppDelegate sharedInstance] loginWindowIsVisilbe])
        [_logInOrOut setAction:NULL];
    
}

#pragma mark - View methods

-(void)updateMenuItemsLogin:(NSNotification*)notification{
    //User *user = [User currentUser];
    //NSString *title = [NSString stringWithFormat:@"Log out (%@)",[user username]];
    //[_logInOrOut setTitle:title];
    //[_logInOrOut setAction:@selector(logInOrOut:)];
    [_goToMyPryvButton setEnabled:YES];
    //[newNote setEnabled:YES];
    //[pryvFiles setEnabled:YES];
    //[goToMyPryv setEnabled:YES];
    //[preferences setEnabled:YES];
}

-(void)updateMenuItemsLogout:(NSNotification*)notification{
    NSLog(@"Logged out.");
    //[_logInOrOut setTitle:@"Log in"];
    [_goToMyPryvButton setEnabled:NO];
    //[newNote setEnabled:NO];
    //[pryvFiles setEnabled:NO];
    //[goToMyPryv setEnabled:NO];
    //[preferences setEnabled:NO];
}


@end
