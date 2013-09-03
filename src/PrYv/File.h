//
//  File.h
//  osx-integration
//
//  Created by Victor Kristof on 03.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSNumber * isPicture;
@property (nonatomic, retain) Event *event;

@end
