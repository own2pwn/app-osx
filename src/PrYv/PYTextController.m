//
//  PRYVTextController.m
//  PrYv
//
//  Created by Victor Kristof on 03.04.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYTextController.h"
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
		User *user = [User currentUserInContext:context];
        
        PYEvent *event = [[PYEvent alloc] init];
        event.streamId = @"diary";
        event.time = NSTimeIntervalSince1970;
        event.type = @"note/txt";
        event.eventContent = [NSString stringWithString:text];
        
        [[user connection] createEvent:event requestType:PYRequestTypeAsync successHandler:^(NSString *newEventId, NSString *stoppedId) {
            NSLog(@"Pryved text with event ID : %@", newEventId);
        } errorHandler:^(NSError *error) {
            NSLog(@"Error while pryving text : %@", error);
        }];
    }
}

@end
