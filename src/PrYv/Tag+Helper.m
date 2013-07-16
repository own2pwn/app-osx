//
//  Tag+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Tag+Helper.h"
#import "PYAppDelegate.h"

@implementation Tag (Helper)

+(Tag*)tagWithValue:(NSString *)val
          inContext:(NSManagedObjectContext *)context {
    
	Tag *newTag =(Tag*)[NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                     inManagedObjectContext:context];
	newTag.value = val;
	return [newTag autorelease];
}

@end
