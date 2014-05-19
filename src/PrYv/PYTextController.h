//
//  PRYVTextController.h
//  PrYv
//
//  Created by Victor Kristof on 03.04.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PYTextController : NSObject

-(void)pryvText:(NSString*)text
     inStreamId:(NSString*)streamId
       withTags:(NSArray*)tags;

@end
