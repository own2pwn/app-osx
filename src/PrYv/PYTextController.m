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
#import "PryvedEvent.h"
#import "Constants.h"

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
        event.time = [[NSDate date] timeIntervalSince1970];
        event.type = @"note/txt";
        event.eventContent = [NSString stringWithString:text];
        
        [[user connection] createEvent:event requestType:PYRequestTypeAsync successHandler:^(NSString *newEventId, NSString *stoppedId) {
            NSLog(@"Pryved text with event ID : %@", newEventId);
            
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Text pryved successfully !";
            notification.informativeText = [NSString stringWithFormat:@"Your text \"%@\" has been pryved.",event.eventContent];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
            
            //Add text event to list of last synced events
            PryvedEvent *pryvedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"PryvedEvent"
                                                                     inManagedObjectContext:context];
            NSDate *currentDate = [NSDate date];
            pryvedEvent.date = currentDate;
            pryvedEvent.eventId = [NSString stringWithString:newEventId];
            pryvedEvent.type = [NSString stringWithString:kPYLastPryvedEventText];
            pryvedEvent.content = [NSString stringWithString:text];
            
            [user addPryvedEventsObject:pryvedEvent];
            [context save:nil];
            
        } errorHandler:^(NSError *error) {
            NSLog(@"Error while pryving text : %@", error);
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Problem while pryving text.";
            notification.informativeText = [NSString stringWithFormat:@"%@",[[error userInfo] valueForKey:NSLocalizedDescriptionKey]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];

        }];
    }
}

@end
