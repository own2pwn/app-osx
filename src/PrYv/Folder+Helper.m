//
//  Folder+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "Folder+Helper.h"

@implementation Folder (Helper)

- (NSString *)description
{
	NSMutableString *description = [NSMutableString stringWithFormat:@"%@",self.name];
//	  NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", self.name];
//    [description appendFormat:@"– Id: %@", self.folderId];
//    [description appendFormat:@"– Parent Id: %@", self.parentFolderId];
//    [description appendFormat:@"– Hidden: %@", self.hidden];
//    [description appendFormat:@"– Trashed: %@", self.trashed];
//    [description appendString:@">"];
    return description;
}

@end
