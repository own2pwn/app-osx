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
    NSString* _text;
    NSString* _pryvType;
}
@property (assign) IBOutlet NSWindow *detailsWindow;
@property (assign) IBOutlet NSTextField *infoToPryv;
@property (assign) IBOutlet NSButton *pryvButton;
@property (assign) IBOutlet NSTokenField *tagsTokenField;
@property (assign) IBOutlet NSPopUpButton *streamPopUpButton;
@property (assign) IBOutlet NSArrayController *popUpButtonContent;

-(id)initWithWindowNibName:(NSString *)windowNibName andFiles:(NSArray*)files;
-(id)initWithWindowNibName:(NSString *)windowNibName andText:(NSString*)text;
-(IBAction)pryvFiles:(id)sender;
-(IBAction)pryvText:(id)sender;

@end
