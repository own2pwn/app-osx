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
	NSMutableString *description = [NSMutableString stringWithFormat:@"\n\tFilename : %@",self.filename];
	[description appendFormat:@"\n\tMIME-Type : %@",self.mimeType];
	[description appendFormat:@"\n\tSize : %@",self.size];
	[description appendFormat:@"\n\tData path : %@",self.path];
	
	return description;
}

@end
