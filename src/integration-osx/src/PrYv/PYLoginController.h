//
//  PRYVLoginController.h
//  PrYv
//
//  Created by Victor Kristof on 30.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "User+Helper.h"
#import "User.h"

@interface PYLoginController : NSWindowController {

}
@property (assign) IBOutlet WebView *webView;
@property (retain) User *user;

-(PYLoginController*)initForUser:(User*)user;

@end
