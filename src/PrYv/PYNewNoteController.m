//
//  PRYVNewNoteController.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PYNewNoteController.h"
#import "PYAppDelegate.h"
#import "User.h"
#import "User+Helper.h"
#import "PryvedEvent.h"
#import "Constants.h"
#import "PYUtility.h"


@interface PYNewNoteController ()

@end

@implementation PYNewNoteController

-(IBAction)createNote:(id)sender {
	//The content of the note is the only required field
	if ([[_content stringValue] isEqualToString:@""]) {
		NSLog(@"The content is mandatory !");
	}else {
		//Get the general context and create a new note
        User* current = [User currentUser];
        
        NSString* streamId;
        if ([[_streams titleOfSelectedItem] isEqualTo:@""]) {
            streamId = @"diary";
        }else {
            //NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
            NSString *streamIndex = [NSString stringWithFormat:@"%lu",[_streams indexOfSelectedItem]];
            streamId = [[current streams] objectForKey:streamIndex];
        }
        
        PYEvent *event = [[PYEvent alloc] init];
        
        event.streamId = [NSString stringWithString:streamId];
        event.type = @"note/txt";
        [event setEventDate:[NSDate date]];
        event.eventContent = [NSString stringWithString:[_content stringValue]];
        event.tags = [NSArray arrayWithArray:[_tags objectValue]];
        
        [[current connection] eventCreate:event successHandler:^(NSString *newEventId, NSString *stoppedId, PYEvent *event) {
            NSLog(@"Note created with event ID : %@",newEventId);
            
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"Note pryved successfully.";
            notification.informativeText = [NSString stringWithFormat:@"Your note \"%@\" has been pryved.",event.eventContent];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
            
            //Add this event to the last synced events list
            /*X2
            PryvedEvent *pryvedEvent = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"PryvedEvent" inManagedObjectContext:context];
            NSDate *currentDate = [NSDate date];
            pryvedEvent.type = [NSString stringWithString:kPYLastPryvedEventNote];
            pryvedEvent.content = [NSString stringWithString:event.eventContent];
            pryvedEvent.date = currentDate;
            pryvedEvent.eventId = [NSString stringWithString:newEventId];
            [current addPryvedEventsObject:pryvedEvent];
            [current updateNumberOfPryvedEventsInContext:context];
            [context save:nil];
             */
            
        } errorHandler:^(NSError *error) {
            NSLog(@"Error when pryving a note : %@", error);
            
            //Display notification
            NSUserNotification *notification = [[NSUserNotification alloc] init];
            notification.title = @"The note could not by pryved.";
            notification.informativeText = [NSString stringWithFormat:@"%@",[[error userInfo] valueForKey:NSLocalizedDescriptionKey]];
            [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
        }];
        		
        [event release];
		[self.window close];
	}
}


////Reset the window so that next time you open it, it is a new window
//-(void)windowWillClose:(NSNotification *)notification {
//	[_content setStringValue:@""];
//	[_tags setStringValue:@""];
//	[_content becomeFirstResponder];
//	
//}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        //Initalization code goes here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
	User *current = [User currentUser];
	current.streams = [[NSMutableDictionary alloc] init];
    PYUtility *utility = [[PYUtility alloc] init];
    [utility setupStreamPopUpButton:_streams withArrayController:_popUpButtonContent forUser:current];
    [utility release];
    
}

@end
