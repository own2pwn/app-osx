//
//  User.h
//  osx-integration
//
//  Created by Victor Kristof on 10.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *pryvedEvents;
@property (nonatomic, retain) NSMutableDictionary *streams;
@property (nonatomic, retain) NSMutableArray *allStreams;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPryvedEventsObject:(NSManagedObject *)value;
- (void)removePryvedEventsObject:(NSManagedObject *)value;
- (void)addPryvedEvents:(NSSet *)values;
- (void)removePryvedEvents:(NSSet *)values;
@end
