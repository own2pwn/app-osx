//
//  PYPreferencesPaneControllerViewController.h
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PYPreferencesPaneController : NSWindowController <NSToolbarDelegate,NSWindowDelegate>

@property (assign) IBOutlet NSTextField *appVersionLabel;
@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSToolbarItem *generalItem;
@property (assign) IBOutlet NSToolbarItem *userItem;
@property (assign) IBOutlet NSTabView *tabView;
@property (assign) IBOutlet NSSegmentedControl *launchAtLoginSwitch;
@property (assign) IBOutlet NSTextField *usernameLabel;

- (IBAction)changeTabView:(id)sender;
- (IBAction)toggleLaunchAtLogin:(id)sender;

@end
