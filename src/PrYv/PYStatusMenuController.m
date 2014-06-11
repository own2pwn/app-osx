//
//  PRYVMenuController.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYStatusMenuController.h"
#import "PYNewNoteController.h"
#import "PYPreferencesPaneController.h"
#import "PYAppDelegate.h"
#import "User.h"
#import "User+Helper.h"
#import "PYFileController.h"
#import "DragAndDropStatusMenuView.h"
#import "PYLoginController.h"
#import "Constants.h"
#import "PryvedEvent.h"

@implementation PYStatusMenuController

@synthesize statusItem = _statusItem;

#pragma mark - General methods

-(void)dealloc {
	[_newNoteController release];
	[_fileController release];
	[_statusItem release];
	[super dealloc];
}

-(PYStatusMenuController*)init{
	self = [super init];
	if (self) {
	}
	return self;
}

-(void) awakeFromNib {
	NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
	_statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
	[_statusItem retain];
    DragAndDropStatusMenuView *dragAndDropStatusMenuView = [[DragAndDropStatusMenuView alloc]
                                                            initWithFrame:NSMakeRect(0, 0, 22, 22)];
    dragAndDropStatusMenuView.statusMenuController = self;
	dragAndDropStatusMenuView.statusItem = _statusItem;
	[dragAndDropStatusMenuView setMenu:_statusMenu];
	[_statusItem setView:dragAndDropStatusMenuView];
    [dragAndDropStatusMenuView release];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMenuItemsLogin:)
                                                 name:PYLoginSuccessfullNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMenuItemsLogout:)
                                                 name:PYLogoutSuccessfullNotification
                                               object:nil];
    
}

#pragma mark - Actions

-(IBAction)newNote:(id)sender {
	if(!_newNoteController) {
		_newNoteController = [[PYNewNoteController alloc] initWithWindowNibName:@"NewNote"];
		[_newNoteController.window setDelegate:self];
	}
	[_newNoteController showWindow:self];
}

-(IBAction)openFiles:(id)sender {
	NSOpenPanel *openDialog = [NSOpenPanel openPanel];
	[openDialog retain]; //Mac OS X 10.6 fix
	_fileController = [[PYFileController alloc] initWithOpenPanel:openDialog];
	[_fileController runDialog];
}

-(IBAction)goToMyPryv:(id)sender {
    NSString *username = [[[User currentUser] username] copy];
    
    NSString* domain = @"pryv.me";
    if ([[PYClient defaultDomain] isEqualToString:@"pryv.in"]) {
       domain = @"pryv.li";
    };
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@.%@/",username, domain];
	NSURL *url = [NSURL URLWithString:urlString];
	if(![[NSWorkspace sharedWorkspace] openURL:url])
		NSLog(@"Failed to open url: %@",[url description]);
}
- (IBAction)openPreferences:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    if (!_preferencesController) {
        _preferencesController = [[PYPreferencesPaneController alloc] initWithWindowNibName:@"PreferencesPane"];
        [_preferencesController.window setDelegate:_preferencesController];
    }
    [_preferencesController showWindow:self];
}

- (IBAction)logInOrOut:(id)sender {
    User * user = [User currentUser];
	//If no user has been found, open login window
	if (!user) {
        [NSApp activateIgnoringOtherApps:YES];
        _loginWindow = [[PYLoginController alloc] initForUser:user andStatusItem:_statusItem];
		[_loginWindow.window setDelegate:self];
		[_loginWindow showWindow:self];
        
        //If the user has been found
	}else {
        [[PYAppDelegate sharedInstance] setConnected:NO];
		[user logout];
    }
}

#pragma mark - Window delegate

-(void)windowDidBecomeKey:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        [logInOrOut setEnabled:NO];
    }
}

-(void)windowWillClose:(NSNotification *)notification{
    NSString *identifier = [[notification object] valueForKey:@"identifier"];
    if ([identifier isEqualToString: @"LoginWindow"]) {
        [logInOrOut setEnabled:YES];
    }else if ([identifier isEqualToString:@"NewNote"]){
        [_newNoteController release];
        _newNoteController = nil;
    }
}

#pragma mark - View methods

-(void)showMenu {
	[_statusItem popUpStatusItemMenu:_statusMenu];
}

-(void)updateMenuItemsLogin:(NSNotification*)notification{
    User *user = [User currentUser];
    NSString *title = [NSString stringWithFormat:@"Log out (%@)",[user username]];
    [logInOrOut setTitle:title];
    [newNote setEnabled:YES];
    [pryvFiles setEnabled:YES];
    [goToMyPryv setEnabled:YES];
    [preferences setEnabled:YES];
}

-(void)updateMenuItemsLogout:(NSNotification*)notification{
    NSLog(@"Logged out.");
    [logInOrOut setTitle:@"Log in"];
    [newNote setEnabled:NO];
    [pryvFiles setEnabled:NO];
    [goToMyPryv setEnabled:NO];
    [preferences setEnabled:NO];
}

//BACKLOG : will be implemented later, feature removed for MVP
-(void)updateLastPryvedEvents
{
    User *current = [User currentUser];
    
    NSArray *sortedPryvedEvents = [NSArray arrayWithArray:[current sortLastPryvedEvents]];
    NSMenu *pryvedEvents = [[NSMenu alloc] init];
    
    if ([sortedPryvedEvents count] > 0) {
        for (PryvedEvent *event in sortedPryvedEvents) {
            NSMutableString *title = [NSMutableString stringWithFormat:@"%@ : %@", event.type, event.content];
            if ([title length] > 30) {
                NSString *tooLongTitle = [NSString stringWithFormat:@"%@...",[title substringToIndex:31]];
                [pryvedEvents addItemWithTitle:tooLongTitle action:NULL keyEquivalent:@""];
            }else{
                [pryvedEvents addItemWithTitle:title action:NULL keyEquivalent:@""];
            }
        }
    }else{
        [pryvedEvents addItemWithTitle:@"Nothing pryved yet." action:NULL keyEquivalent:@""];
    }
    
    [lastPryvedItems setSubmenu:pryvedEvents];
    [pryvedEvents release];
}

@end
