//
//  PRYVNewNoteController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PRYVNewNoteController : NSWindowController <NSWindowDelegate> {
@private
	IBOutlet NSTextField *_title;
	IBOutlet NSTextField *_content;
	IBOutlet NSTokenField *_tags;
	IBOutlet NSPopUpButton *_folder;
}

-(IBAction)createNote:(id)sender;

@end
