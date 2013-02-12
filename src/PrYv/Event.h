//
//  Event.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Folder, Tag, User;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * channelId;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSString * type_class;
@property (nonatomic, retain) NSString * type_format;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) Folder *folder;
@property (nonatomic, retain) User *user;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;
@end
