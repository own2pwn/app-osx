//
//  NoteEvent.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface NoteEvent : Event

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end
