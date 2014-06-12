//
//  PYUtilities.h
//  osx-integration
//
//  Created by Victor Kristof on 04.01.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface PYUtility : NSObject

+(void)setupStreamPopUpButton:(NSPopUpButton*)streams
           withArrayController:(NSArrayController*)popUpBUttonContent
                       forUser:(User*)user;

@end
