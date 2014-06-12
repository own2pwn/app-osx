//
//  PRYVLoginController.m
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYLoginController.h"
#import "PYAppDelegate.h"
#import "Constants.h"
#import "DragAndDropStatusMenuView.h"
#import "PYStatusMenuController.h"

@interface PYLoginController () <PYWebLoginDelegate>

@end

@implementation PYLoginController

@synthesize user = _user;
@synthesize statusItem = _statusItem;
@synthesize webView;

-(PYLoginController*)initForUser:(User*)user andStatusItem:(NSStatusItem *)statusItem{
	self = [super initWithWindowNibName:@"LoginController"];
	if (self) {
		_user = user;
        _statusItem = statusItem;
	}
	
	return self;
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    NSArray *objects = [NSArray arrayWithObjects:
                        kPYAPIConnectionRequestAllStreams,
                        kPYAPIConnectionRequestManageLevel,
                        nil];
    NSArray *keys = [NSArray arrayWithObjects:
                     kPYAPIConnectionRequestStreamId,
                     kPYAPIConnectionRequestLevel,
                     nil];
    NSArray *permissions = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjects:objects forKeys:keys]];
    
    [PYWebLoginViewController requestConnectionWithAppId:@"pryv-integration-osx"
                                      andPermissions:permissions
                                            delegate:self
                                         withWebView:&webView];
}

- (void) pyWebLoginSuccess:(PYConnection*)pyConnection{
    
    NSLog(@"Signin With Success %@ %@",pyConnection.userID,pyConnection.accessToken);
    
    [User saveConnection:pyConnection];
    
    [[PYAppDelegate sharedInstance] setConnected:YES];
    [_statusItem.view setNeedsDisplay:YES];
    
    [[PYAppDelegate sharedInstance] loadUser];
}

- (void) pyWebLoginAborted:(NSString*)reason {
    NSLog(@"Signin Aborded: %@",reason);
}

- (void) pyWebLoginError:(NSError*)error {
    NSLog(@"Signin Error: %@",error);
}

@end
