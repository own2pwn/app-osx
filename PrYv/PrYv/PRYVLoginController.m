//
//  PRYVLoginController.m
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVLoginController.h"
#import "PRYVAppDelegate.h"


@interface PRYVLoginController ()

@end

@implementation PRYVLoginController

-(PRYVLoginController*)initForUser:(User*)u{
	self = [super initWithWindowNibName:@"PRYVLoginController"];
	if (self) {
		user = u;
	}
	
	return self;
}

-(IBAction)login:(id)sender{
	
	NSString *channelId = @"TVoyO2x2B5";
	
	user = [User createNewUserWithUsername:[username stringValue]
									 Token:[oAuthToken stringValue]
								 ChannelId:channelId
								 InContext:[[PRYVAppDelegate sharedInstance] managedObjectContext]];
	[self.window close];
	NSLog(@"First onnection with : %@. Welcome !", user.username);
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
