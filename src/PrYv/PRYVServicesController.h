//
//  PRYVServicesController.h
//  PrYv
//
//  Created by Victor Kristof on 20.03.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PRYVFileController.h"

@interface PRYVServicesController : NSObject{
@private
    PRYVFileController* _fileController;
}

-(void)pryvFilesFromService:(NSPasteboard*)pboard
       userData:(NSString*)userData
          error:(NSString**)error;

@end
