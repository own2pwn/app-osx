//
//  User.h
//  PrYv
//
//  Created by Victor Kristof on 06.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Note;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * channelId;
@property (nonatomic, retain) NSString * oAuthToken;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSSet *notes;
@property (nonatomic, retain) NSSet *files;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;
- (void)addFilesObject:(File *)value;
- (void)removeFilesObject:(File *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;
@end
