//
//  PRYVAppDelegate.m
//  PrYv
//
//  Created by Victor Kristof on 21.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYAppDelegate.h"
#import "User.h"
#import "User+Helper.h"
#import "PYLoginController.h"
#import "PYFileController.h"
#import "PYStatusMenuController.h"
#import "PYServicesController.h"
#import "NSDictionary+SubscriptingCompatibility.h"
#import "Constants.h"
#import "PryvApiKit.h"
#import "DragAndDropStatusMenuView.h"
#import "AXStatusItemPopup.h"
#import "StatusMenuViewController.h"

@implementation PYAppDelegate

- (void)dealloc {
    [_statusItemPopup release];
    [_statusMenuViewController release];
    [_loginWindow release];
    [_servicesController release];
    [_user.streams release];
    [super dealloc];
}

@synthesize connected = _connected, loginWindowIsVisilbe = _loginWindowIsVisilbe;
@synthesize loginWindow = _loginWindow, statusMenuViewController = _statusMenuViewController, user = _user;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [[PYAppDelegate sharedInstance] setConnected:NO];
    [[PYAppDelegate sharedInstance] setLoginWindowIsVisilbe:NO];
    
    _statusMenuViewController = [[StatusMenuViewController alloc]
                                                      initWithNibName:@"StatusMenuViewController"
                                                      bundle:nil];
    NSImage *image = [NSImage imageNamed:@"FaviconBlack22.png"];
    NSImage *alternateImage = [NSImage imageNamed:@"FaviconWhite22.png"];
    NSImage *disconnectedImage = [NSImage imageNamed:@"FaviconGrey22.png"];
    
    _statusItemPopup = [[AXStatusItemPopup alloc] initWithViewController:_statusMenuViewController
                                                                   image:image
                                                          alternateImage:alternateImage
                                                       disconnectedImage:disconnectedImage];
    _statusItemPopup.animated = NO;
    _statusMenuViewController.statusItemPopup = _statusItemPopup;
	
    [self loadUser];
}


- (void)loadUser {

    
	//Try to retrieve the user from the user preferences
	self.user = [User currentUser];
	//[PYClient setDefaultDomainStaging];
    
	//If no user has been found, open login window
	if (!self.user) {
        
        [NSApp activateIgnoringOtherApps:YES];
		_loginWindow = [[PYLoginController alloc] initForUser:_user andStatusItem:_statusItemPopup.statusItem];
        [_loginWindow.window setDelegate:_statusMenuViewController];
		[_loginWindow showWindow:self];
        [_loginWindow.window makeKeyAndOrderFront:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:PYLogoutSuccessfullNotification object:self];
	
	//If the user has been found
	}else {
        
        [[PYAppDelegate sharedInstance] setConnected:YES];
        //[_menuController.view setNeedsDisplay:YES];
		NSLog(@"Welcome back, %@ !",_user.username);
        [[_user connection] streamsEnsureFetched:^(NSError *error) {
            if (error) { NSLog(@"Failed fetching streams %@", error); }
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PYLoginSuccessfullNotification object:self];
	}
    
    //Set up the service handler
    _servicesController = [[PYServicesController alloc] init];
    [NSApp setServicesProvider:_servicesController];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}


-(void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
	__block NSMutableArray *urls = [[NSMutableArray alloc] init];
	[filenames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[urls addObject:[NSURL fileURLWithPath:obj]];
	}];
	PYFileController *fileController = [[PYFileController alloc] init];
	[fileController pryvFiles:[urls autorelease]
                     inStreamId:@"diary"
                withTags:[[[NSArray alloc] init] autorelease]];
	[fileController release];
}

// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "pryv.PrYv" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory
                                                inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"pryv.PrYv"];
}

//Enables singleton using Grand Central
+ (PYAppDelegate*)sharedInstance {
	static dispatch_once_t pred;
	static PYAppDelegate *sharedInstance = nil;
	dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}

//Set the app to display notifications on the screen and not only in NotificationCenter
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}





@end
