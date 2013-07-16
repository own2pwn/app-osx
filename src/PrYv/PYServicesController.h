//
//  PRYVServicesController.h
//  PrYv
//
//  Created by Victor Kristof on 20.03.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PYFileController.h"
#import "PYTextController.h"

@interface PYServicesController : NSObject{
@private
    PYFileController* _fileController;
    PYTextController* _textController;
}

-(void)pryvFilesFromService:(NSPasteboard*)pboard
       userData:(NSString*)userData
          error:(NSString**)error;
-(void)pryvSelectedText:(NSPasteboard*)pboard
               userData:(NSString*)userData
                  error:(NSString**)error;

@end
