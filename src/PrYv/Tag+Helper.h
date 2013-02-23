//
//  Tag+Helper.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Tag.h"

@interface Tag (Helper)

+(Tag*)tagWithValue:(NSString*)tag inContext:(NSManagedObjectContext*)context;

@end
