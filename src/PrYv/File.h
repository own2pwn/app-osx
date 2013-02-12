//
//  File.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FileEvent;

@interface File : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) FileEvent *fileEvent;

@end
