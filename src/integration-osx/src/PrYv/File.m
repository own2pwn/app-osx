//
//  File.m
//  osx-integration
//
//  Created by Victor Kristof on 10.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "File.h"


@implementation File

@synthesize filename;
@synthesize isPicture;
@synthesize mimeType;
@synthesize path;
@synthesize size;

-(id)init{
    self = [super init];
	
	return self;
}

@end
