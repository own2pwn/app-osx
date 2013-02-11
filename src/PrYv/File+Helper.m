//
//  File+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 06.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "File+Helper.h"

@implementation File (Helper)

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithFormat:@"\n\tFilename : %@\n",self.filename];
	[description appendFormat:@"\tMIME-Type : %@\n",self.mimeType];
	[description appendFormat:@"\tSize : %@\n",self.size];
	[description appendFormat:@"\tPath : %@\n",self.path];
	
	return description;
}

@end
