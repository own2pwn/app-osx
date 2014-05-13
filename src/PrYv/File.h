//
//  File.h
//  osx-integration
//
//  Created by Victor Kristof on 10.09.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface File : NSObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * isPicture;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * size;

@end
