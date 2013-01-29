//
//  Folder.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Folder : NSManagedObject

@property (nonatomic, retain) NSString * folderId;
@property (nonatomic, retain) NSString * parentFolderId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSNumber * trashed;
@property (nonatomic, retain) Note *note;

@end
