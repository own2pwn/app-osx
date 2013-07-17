//
//  PRYVLoginController.m
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYLoginController.h"
#import "PYAppDelegate.h"
#import "PryvApiKit/PryvApiKit.h"
#import "PryvApiKit/PYWebLoginViewController.h"

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
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void) pyWebLoginSuccess:(PYAccess*)pyAccess{
    
}
- (void) pyWebLoginAborded:(NSString*)reason{
    
}
- (void) pyWebLoginError:(NSError*)error{
    
}

@end
