//
//  PRYVNewNoteController.m
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "PRYVNewNoteController.h"
#import "Note.h"
#import "PRYVAppDelegate.h"
#import "User.h"
#import "User+Extras.h"
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
		Note *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
		
		//Construct the note using the fields in the panel
		newNote.title = [title stringValue];
		newNote.content = [content stringValue];
		newNote.folder = (Folder*)[NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:context];
		newNote.folder.name = [folder stringValue];
		NSMutableSet *newTags = [[NSMutableSet alloc] init];
		[[tags objectValue] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[newTags addObject:[Tag tagWithValue:obj inContext:context]];
		}];
		newNote.tags = newTags;
		[newTags release];
		
		//Add the note in the user set of notes and save the changes
		User *current = [User currentUserInContext:context];
		[current addNotesObject:newNote];
		[context save:nil];
		
		NSLog(@"Note created with title : %@",[title stringValue]);
		[self.window close];
		
	}
}

-(void)windowWillClose:(NSNotification *)notification{
	[title setStringValue:@""];
	[content setStringValue:@""];
	[folder setStringValue:@""];
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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
