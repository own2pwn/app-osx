//
//  PryvedEvent.h
//  osx-integration
//
//  Created by Victor Kristof on 12.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>


@class User;

@interface PryvedEvent : NSObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * eventId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) User *user;

@end
