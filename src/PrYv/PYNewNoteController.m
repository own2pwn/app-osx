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

@interface PYNewNoteController ()

-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                                inArray:(NSMutableArray *)streamNames
                     withLevelDelimiter:(NSString *)delimiter
                                forUser:(User *)user
                                atIndex:(NSUInteger)index;
@end

@implementation PYNewNoteController

-(IBAction)createNote:(id)sender {
	//The content of the note is the only required field
	if ([[_content stringValue] isEqualToString:@""]) {
		NSLog(@"The content is mandatory !");
	}else {
		//Get the general context and create a new note
		NSManagedObjectContext *context = [[PYAppDelegate sharedInstance] managedObjectContext];
        User* current = [User currentUserInContext:context];
        
        NSString* streamId;
        if ([[_streams titleOfSelectedItem] isEqualTo:@""]) {
            streamId = @"diary";
        }else {
            //				NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
            NSString *streamIndex = [NSString stringWithFormat:@"%lu",[_streams indexOfSelectedItem]];
            streamId = [[current streams] objectForKey:streamIndex];
        }
        
		

        PYEvent *event = [[PYEvent alloc] init];
        
        event.streamId = [NSString stringWithString:streamId];
        event.type = @"note/txt";
        event.time = [[NSDate date] timeIntervalSince1970];
        event.eventContent = [NSString stringWithString:[_content stringValue]];
        event.tags = [NSArray arrayWithArray:[_tags objectValue]];
        
        [[current connection] createEvent:event requestType:PYRequestTypeAsync successHandler:^(NSString *newEventId, NSString *stoppedId) {
            NSLog(@"Note created with event ID : %@",newEventId);
            
            PryvedEvent *pryvedEvent = [NSEntityDescription insertNewObjectForEntityForName:@"PryvedEvent"
                                                                inManagedObjectContext:context];            
            NSDate *currentDate = [NSDate date];
            pryvedEvent.type = @"note/txt";
            pryvedEvent.date = currentDate;
            pryvedEvent.eventId = [NSString stringWithString:newEventId];
            
            [current addPryvedEventsObject:pryvedEvent];
            [context save:nil];
            
        } errorHandler:^(NSError *error) {
            NSLog(@"Error when pryving a note : %@",error);
        }];
		
        [event release];
		[self.window close];
	}
}

-(NSUInteger)createStreamNameForStreams:(NSArray *)streams
                                inArray:(NSMutableArray *)streamNames
                     withLevelDelimiter:(NSString *)delimiter
                                forUser:(User *)user
                                atIndex:(NSUInteger)index
{
    for (PYStream *stream in streams){
        [user.streams setObject:[stream streamId] forKey:[NSString stringWithFormat:@"%lu",index]];
        index++;
        [streamNames addObject:[NSString stringWithFormat:@"%@%@",delimiter,stream.name]];
        if ([stream.children count] > 0) {
            index = [self createStreamNameForStreams:stream.children inArray:streamNames withLevelDelimiter:@"- " forUser:user atIndex:index];
            
        }
    }
    
    return index;
    
}


//Reset the window so that next time you open it, it is a new window
-(void)windowWillClose:(NSNotification *)notification {
	[_content setStringValue:@""];
	[_tags setStringValue:@""];
	[_content becomeFirstResponder];
	
}

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {
        //Initalization code goes here.
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
	User *current = [User currentUserInContext:[[PYAppDelegate sharedInstance] managedObjectContext]];
	current.streams = [[NSMutableDictionary alloc] init];
    [[current connection] getAllStreamsWithRequestType:PYRequestTypeAsync gotCachedStreams:^(NSArray *cachedStreamsList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:cachedStreamsList inArray:streamNames withLevelDelimiter:@"" forUser:current atIndex:0];
        
        NSRange range = NSMakeRange(0, [[_popUpButtonContent arrangedObjects] count]);
        [_popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_popUpButtonContent addObjects:streamNames];
        [_streams selectItemAtIndex:0];
        
        [streamNames release];
        
    } gotOnlineStreams:^(NSArray *onlineStreamList) {
        NSMutableArray *streamNames = [[NSMutableArray alloc] init];
        
        [self createStreamNameForStreams:onlineStreamList inArray:streamNames withLevelDelimiter:@"" forUser:current atIndex:0];
        
        NSRange range = NSMakeRange(0, [[_popUpButtonContent arrangedObjects] count]);
        [_popUpButtonContent removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
        [_popUpButtonContent addObjects:streamNames];
        [_streams selectItemAtIndex:0];
        
        [streamNames release];
        
    } errorHandler:^(NSError *error) {
        NSLog(@"%@",error);
    }];

}

@end
