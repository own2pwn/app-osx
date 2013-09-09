//
//  PRYVNewNoteController.h
//  PrYv
//
//  Created by Victor Kristof on 29.01.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PYNewNoteController : NSWindowController <NSWindowDelegate> {
@private
    IBOutlet NSArrayController *_popUpButtonContent;
	IBOutlet NSTextField *_content;
	IBOutlet NSTokenField *_tags;
	IBOutlet NSPopUpButton *_streams;
}

-(IBAction)createNote:(id)sender;

@end
