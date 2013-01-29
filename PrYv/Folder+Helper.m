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
	
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@", self.id=%@", self.folderId];
    [description appendFormat:@", self.name=%@", self.name];
    [description appendFormat:@", self.parentFolderId=%@", self.parentFolderId];
    [description appendFormat:@", self.hidden=%@", self.hidden];
    [description appendFormat:@", self.trashed=%@", self.trashed];
    [description appendString:@">"];
    return description;
}

@end
