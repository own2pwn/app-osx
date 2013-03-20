//
//  PRYVServicesController.m
//  PrYv
//
//  Created by Victor Kristof on 20.03.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVServicesController.h"

@implementation PRYVServicesController

-(id)init {
    self = [super init];
    if (self) {
        _fileController = [[PRYVFileController alloc] init];
    }
    
    return self;
}

-(void)pryvFilesFromService:(NSPasteboard *)pboard userData:(NSString *)userData error:(NSString **)error{
    
    // Test for strings on the pasteboard.
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		__block NSMutableArray *urls = [[NSMutableArray alloc] init];
		[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[urls addObject:[NSURL fileURLWithPath:obj]];
		}];
        //NSLog(@"Files : %@",files);
		PRYVFileController *fileController = [[PRYVFileController alloc] init];
		[fileController pryvFiles:[urls autorelease]
						 withTags:[[[NSSet alloc] init] autorelease]
					andFolderName:@""];
		[fileController release];
    }
}
@end
