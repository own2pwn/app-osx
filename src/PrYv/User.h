//
//  User.h
//  osx-integration
//
//  Created by Victor Kristof on 10.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject

@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *pryvedEvents;
@property (nonatomic, retain) NSMutableDictionary *streams;
@property (nonatomic, retain) NSMutableArray *allStreams;
@property (nonatomic, retain) PYConnection* connection;
@end

@interface User (Dummy)

- (void)addPryvedEvents:(NSSet *)values;
- (void)removePryvedEvents:(NSSet *)values;
@end
