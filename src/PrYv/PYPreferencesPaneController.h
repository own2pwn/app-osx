//
//  PYPreferencesPaneControllerViewController.h
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PYPreferencesPaneController : NSWindowController <NSToolbarDelegate,NSWindowDelegate>
@property (assign) IBOutlet NSToolbar *toolbar;
@property (assign) IBOutlet NSToolbarItem *generalItem;
@property (assign) IBOutlet NSToolbarItem *userItem;

- (IBAction)changeTabView:(id)sender;
@property (assign) IBOutlet NSTabView *tabView;

@end
