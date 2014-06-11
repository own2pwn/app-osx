//
//  NSDictionary+SubscriptingCompatibility.h
//  PrYv
//
//  Created by Victor Kristof on 17.07.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Availability.h"
#import <Foundation/Foundation.h>

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070
@interface NSDictionary (SubscriptingCompatibility)

//- (id)objectAtIndexedSubscript:(NSUInteger)idx;
//- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
//- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
#endif