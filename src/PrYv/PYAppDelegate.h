//
//  PRYVAppDelegate.h
//  PrYv
//
//  Created by Victor Kristof on 21.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PYLoginController, PYStatusMenuController, PYServicesController;

@interface PYAppDelegate : NSObject <NSApplicationDelegate> {
@private
    PYServicesController *servicesController;
}
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain) PYLoginController *loginWindow;
@property (retain) PYStatusMenuController *menuController;

- (IBAction)saveAction:(id)sender;
+ (PYAppDelegate*)sharedInstance;

@end
