//
//  PRYVNewNoteController.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVNewNoteController.h"
#import "NoteEvent.h"
#import "PRYVAppDelegate.h"
#import "User.h"
#import "User+Helper.h"
#import "Tag+Helper.h"
#import "Tag.h"
#import "Folder.h"

@interface PRYVNewNoteController ()

@end

@implementation PRYVNewNoteController

-(IBAction)createNote:(id)sender{
	//The content of the note is the only required field
	if ([[content stringValue] isEqualToString:@""]) {
		NSLog(@"The content is mandatory !");
	}else{
		//Get the general context and create a new note
		NSManagedObjectContext *context = [[PRYVAppDelegate sharedInstance] managedObjectContext];
		NoteEvent *newNoteEvent = [NSEntityDescription insertNewObjectForEntityForName:@"NoteEvent" inManagedObjectContext:context];
		
		//Construct the note using the fields in the panel
		newNoteEvent.title = [title stringValue];
		newNoteEvent.content = [content stringValue];
		newNoteEvent.folder = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
		if ([[folder titleOfSelectedItem] isEqualTo:@"None"]) {
			newNoteEvent.folder.name = @"";
		}else{
			newNoteEvent.folder.name = [folder titleOfSelectedItem];
		}
		NSMutableSet *newTags = [[NSMutableSet alloc] init];
		[[tags objectValue] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[newTags addObject:[Tag tagWithValue:obj inContext:context]];
		}];
		newNoteEvent.tags = newTags;
		[newTags release];
		
		//Add the note in the user set of notes and save the changes
		User *current = [User currentUserInContext:context];
		[current addEventsObject:newNoteEvent];
		[context save:nil];
		
		NSLog(@"Note created with title : %@",[title stringValue]);
		[self.window close];
		
	}
}
//Reset the window so that next time you open it, it is a new window
-(void)windowWillClose:(NSNotification *)notification{
	[title setStringValue:@""];
	[content setStringValue:@""];
	[tags setStringValue:@""];
	[title becomeFirstResponder];
	
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	User *current = [User currentUserInContext:[[PRYVAppDelegate sharedInstance] managedObjectContext]];
	NSArray *folderNames = [current folderNames];
	[folder addItemsWithTitles: folderNames];
}

@end
