//
//  Folder.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, User;

@interface Folder : NSManagedObject

@property (nonatomic, retain) NSString * folderId;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSNumber * trashed;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) User *user;

@end
