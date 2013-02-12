//
//  PRYVMenuController.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVMenuController.h"
#import "PRYVNewNoteController.h"
#import "PRYVAppDelegate.h"
#import "User+Helper.h"
#import "User.h"
#import "NoteEvent.h"
#import "PRYVFileController.h"

@implementation PRYVMenuController

-(PRYVMenuController*)init{
	self = [super init];
	if (self) {
		//Initialization code goes here
	}
	return self;
}

-(IBAction)openFiles:(id)sender{
	NSOpenPanel *openDialog = [NSOpenPanel openPanel];
	[openDialog retain]; //Mac OS X 10.6 fix	
	fileController = [[PRYVFileController alloc] initWithOpenPanel:openDialog];
	[fileController runDialog];
	
	
}


-(IBAction)displayCurrentUser:(id)sender{
	NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
	User *current = [User currentUserInContext:context];
	NSLog(@"\n%@",[current description]);
}

-(IBAction)purgeEvents:(id)sender{
	NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
	User *current = [User currentUserInContext:context];
	[current purgeEventsInContext:context];
}

-(IBAction)newNote:(id)sender{
	if(!newNoteController){
		newNoteController = [[PRYVNewNoteController alloc] initWithWindowNibName:@"NewNote"];
		[newNoteController.window setDelegate:newNoteController];
	}
	[newNoteController showWindow:self];
}

-(IBAction)goToMyPryv:(id)send{
	NSURL *url = [NSURL URLWithString:@"http://www.pryv.net/"];
	if( ![[NSWorkspace sharedWorkspace] openURL:url] )
		NSLog(@"Failed to open url: %@",[url description]);
}

-(void)dealloc{
	[newNoteController release];
	[fileController release];
	[super dealloc];
}

@end
