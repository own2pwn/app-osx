//
//  PRYVAppDelegate.h
//  PrYv
//
//  Created by Victor Kristof on 21.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PRYVAppDelegate : NSObject <NSApplicationDelegate>

//@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong) IBOutlet NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;

- (void)awakeFromNib;
- (IBAction)saveAction:(id)sender;

@end