//
//  PYDetailPopupController.h
//  osx-integration
//
//  Created by Victor Kristof on 04.01.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PYFileController;

@interface PYDetailPopupController : NSWindowController
{
    @private
    PYFileController* _fileController;
    NSArray* _files;
}
@property (assign) IBOutlet NSTextField *fileToPryv;
@property (assign) IBOutlet NSButton *pryvFileButton;
@property (assign) IBOutlet NSTokenField *tagsTokenField;
@property (assign) IBOutlet NSPopUpButton *streamPopUpButton;
@property (assign) IBOutlet NSArrayController *popUpButtonContent;

-(id)initWithWindowNibName:(NSString *)windowNibName andFiles:(NSArray*)files;

@end
