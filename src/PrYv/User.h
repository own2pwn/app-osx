//
//  User.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Folder;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * channelId;
@property (nonatomic, retain) NSString * oAuthToken;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *folders;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
- (void)addFoldersObject:(Folder *)value;
- (void)removeFoldersObject:(Folder *)value;
- (void)addFolders:(NSSet *)values;
- (void)removeFolders:(NSSet *)values;
@end
