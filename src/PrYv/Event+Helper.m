//
//  Event+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 12.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Event+Helper.h"

@implementation Event (Helper)

-(NSString*)describeTags {
	NSMutableString *description = [NSMutableString stringWithString:@""];
	[self.tags enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[description appendFormat:@"%@ ",[obj value]];
	}];
	return description;
}

@end
