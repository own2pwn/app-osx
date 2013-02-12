//
//  PRYVLoginController.h
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "User+Helper.h"
#import "User.h"

@interface PRYVLoginController : NSWindowController{
@private
	IBOutlet NSTextField *username;
	IBOutlet NSTextField *oAuthToken;
	User *user;

}
-(PRYVLoginController*)initForUser:(User*)u;
-(IBAction)login:(id)sender;

@end
