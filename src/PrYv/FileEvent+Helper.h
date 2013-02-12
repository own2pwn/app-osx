//
//  FileEvent+Helper.h
//  PrYv
//
//  Created by Victor Kristof on 11.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "FileEvent.h"

@interface FileEvent (Helper)

-(id)initWithTime:(NSNumber*)time
					 tags:(NSSet*)tags
				   folder:(Folder*)folder
					files:(NSSet*)files;
-(NSString*)description;

-(void)deleteFiles;
@end
