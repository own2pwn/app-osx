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
#import "User+Extras.h"
#import "User.h"
#import "Note.h"
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
	NSLog(@"#################");
	NSLog(@"CURRENT USER");
	NSLog(@"Username : %@",current.username);
	NSLog(@"oAuthToken : %@", current.oAuthToken);
	__block int i = 1;
	[current.notes enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		NSLog(@"Note %d",i);
		NSLog(@"\tTitle : %@", [obj title]);
		NSLog(@"\tContent : %@", [obj content]);
		NSLog(@"\tFolder : %@",[[obj folder] description]);
		NSLog(@"\tTags : ");
		NSSet *tagSet = [NSSet setWithSet:[obj tags]];
		[tagSet enumerateObjectsUsingBlock:^(id t, BOOL *stop) {
			NSLog(@"\t\t%@", (NSString*)[t tag]);
		}];
		i++;
	}];
	i = 1;
	[current.files enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		NSLog(@"File %d",i);
		NSLog(@"%@",[obj description]);
		i++;

	}];
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
