//
//  PRYVLoginController.m
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYLoginController.h"
#import "PYAppDelegate.h"
#import "PryvApiKit.h"
#import "Constants.h"

@interface PYLoginController () <PYWebLoginDelegate>

@end

@implementation PYLoginController

@synthesize user = _user;
@synthesize webView;

-(PYLoginController*)initForUser:(User*)user {
	self = [super initWithWindowNibName:@"LoginController"];
	if (self) {
		_user = user;
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
    [PYClient setDefaultDomainStaging];
    [PYWebLoginViewController requestConnectionWithAppId:@"integration-osx"
                                      andPermissions:permissions
                                            delegate:self
                                         withWebView:&webView];
}

- (void) pyWebLoginSuccess:(PYConnection*)pyConnection{
    
    NSLog(@"Signin With Success %@ %@",pyConnection.userID,pyConnection.accessToken);
    NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
    _user = [User createNewUserWithUsername:pyConnection.userID
                                   AndToken:pyConnection.accessToken
                                  InContext:context];
    [pyConnection synchronizeTimeWithSuccessHandler:nil errorHandler:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PYLoginSuccessfullNotification
                                                        object:self];
}

- (void) pyWebLoginAborded:(NSString*)reason {
    NSLog(@"Signin Aborded: %@",reason);
}

- (void) pyWebLoginError:(NSError*)error {
    NSLog(@"Signin Error: %@",error);
}

@end
