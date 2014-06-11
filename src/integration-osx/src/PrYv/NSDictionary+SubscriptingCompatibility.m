//
//  NSDictionary+SubscriptingCompatibility.m
//  PrYv
//
//  Created by Victor Kristof on 17.07.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "NSDictionary+SubscriptingCompatibility.h"

#if __MAC_OS_X_VERSION_MAX_ALLOWED < 1070
@implementation NSDictionary (SubscriptingCompatibility)

-(id)objectForKeyedSubscript:(id)key{
    return [self objectForKey:key];
}

@end
#endif