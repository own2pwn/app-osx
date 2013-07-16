//
//  PRYVLoginController.m
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYLoginController.h"
#import "PYAppDelegate.h"


@interface PYLoginController ()

@end

@implementation PYLoginController

-(PYLoginController*)initForUser:(User*)user {
	self = [super initWithWindowNibName:@"LoginController"];
	if (self) {
		_user = user;
	}
	
	return self;
}

-(IBAction)login:(id)sender {
	NSString *channelId = @"TVoyO2x2B5";
	_user = [User createNewUserWithUsername:[_username stringValue]
									 Token:[_oAuthToken stringValue]
								 ChannelId:channelId
								 InContext:[[PYAppDelegate sharedInstance] managedObjectContext]];
	NSLog(@"First connection with : %@. Welcome !", _user.username);
	[self.window close];
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

@end
