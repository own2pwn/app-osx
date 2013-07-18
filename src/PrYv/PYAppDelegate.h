//
//  PRYVAppDelegate.h
//  PrYv
//
//  Created by Victor Kristof on 21.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PYAppDelegate : NSObject <NSApplicationDelegate>

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;
+ (PYAppDelegate*)sharedInstance;

@end