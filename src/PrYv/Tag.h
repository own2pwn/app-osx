//
//  Tag.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) Event *event;

@end