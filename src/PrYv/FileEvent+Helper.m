//
//  FileEvent+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "FileEvent+Helper.h"
#import "Event+Helper.h"

@implementation FileEvent (Helper)

-(NSString*)description {
	NSMutableString *description = [NSMutableString stringWithString:@""];
	//[description appendFormat:@"\n\tTime: %@",self.time];
	//[description appendString:@"\nType:"];
	//[description appendFormat:@"\n\tClass: %@",self.type_class];
	//[description appendFormat:@"\n\tFormat: %@",self.type_format];
	[description appendFormat:@"\nTags: %@",[self describeTags]];
	[description appendFormat:@"\nFolder: %@",[self.folder description]];
	[description appendString:@"\nFiles attached:"];
	__block int i = 1;
	[self.files enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[description appendFormat:@"\n\t----- %d",i];
		[description appendFormat:@"\t%@",[obj description]];
		i++;
	}];
	return description;
}

-(void)deleteFiles {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	__block NSError *error;
	[self.files enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		error = nil;
		if (![fileManager removeItemAtPath:[obj path]
                                     error:&error]) {
			NSLog(@"Error while deleting file %@ : %@",[obj path],error);
		};
	}];
}
@end
