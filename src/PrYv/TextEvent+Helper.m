//
//  TextEvent+Helper.m
//  PrYv
//
//  Created by Victor Kristof on 03.04.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "TextEvent+Helper.h"

@implementation TextEvent (Helper)

-(NSString *)description {
    NSMutableString *description = [NSMutableString stringWithString:@""];
    [description appendFormat:@"\nText: %@",self.text];
    return description;
}
@end
