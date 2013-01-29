//
//  Tag+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Tag+Helper.h"
#import "PRYVAppDelegate.h"

@implementation Tag (Helper)

+(Tag*)tagWithValue:(NSString *)tag inContext:(NSManagedObjectContext *)context{
	Tag *newTag =(Tag*)[NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
	newTag.tag = tag;
	return [newTag autorelease];
}

@end
