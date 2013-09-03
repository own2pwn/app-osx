//
//  NSString+Helper.h
//  PrYv
//
//  Created by Victor Kristof on 06.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)
+(NSString*) mimeTypeFromFileExtension:(NSString*) fileName;
-(BOOL) isPicture;
@end
