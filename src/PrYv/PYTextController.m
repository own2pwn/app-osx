//
//  PRYVTextController.m
//  PrYv
//
//  Created by Victor Kristof on 03.04.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYTextController.h"
#import "TextEvent.h"
#import "PYAppDelegate.h"
#import "User.h"
#import "User+Helper.h"

@implementation PYTextController

-(void)pryvText:(NSString *)text{
    if ([text isEqualToString:@""]) {
		NSLog(@"No text entered !");
	}else {
        //Get the general context
		NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
		TextEvent *newTextEvent = [NSEntityDescription insertNewObjectForEntityForName:@"TextEvent"
                                                                inManagedObjectContext:context];
        newTextEvent.text = [NSString stringWithString:text];
        
        //Add the text in the user event set
		//User *current = [User currentUserInContext:context];
		//[current addEventsObject:newTextEvent];
		[context save:nil];
		
		NSLog(@"Text pryved : %@",text);
    }
}

@end
