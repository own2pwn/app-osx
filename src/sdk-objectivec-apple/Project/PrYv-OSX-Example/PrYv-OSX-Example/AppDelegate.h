//
//  AppDelegate.h
//  OS X example
//
//  Created by Nenad Jelic on 4/26/13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class WelcomeWindowController, User;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    WelcomeWindowController *welcomeWindowController;
    User *_user;
}

@property (retain) User *user;

+ (AppDelegate*)sharedInstance;

@end

