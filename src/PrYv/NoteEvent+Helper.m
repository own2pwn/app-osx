//
//  NoteEvent+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "NoteEvent+Helper.h"

@implementation NoteEvent (Helper)

-(NSString*)description{
	NSMutableString *description = [NSMutableString stringWithString:@""];
	//[description appendFormat:@"\nTime: %@",self.time];
	//[description appendString:@"\nType:"];
	//[description appendFormat:@"\n\tClass: %@",self.type_class];
	//[description appendFormat:@"\n\tFormat: %@",self.type_format];
	[description appendFormat:@"\nTags: %@",[self describeTags]];
	[description appendFormat:@"\nFolder: %@",[self.folder description]];
	[description appendString:@"\nNote"];
	[description appendFormat:@"\n\tTitle: %@",self.title];
	[description appendFormat:@"\n\tContent: %@",self.content];
	return description;
}

@end
