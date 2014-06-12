//
//  PYDetailPopupController.m
//  osx-integration
//
//  Created by Victor Kristof on 04.01.14.
//  Copyright (c) 2014 Pryv. All rights reserved.
//

#import "PYDetailPopupController.h"
#import "User.h"
#import "User+Helper.h"
#import "PYUtility.h"
#import "PYAppDelegate.h"
#import "File.h"
#import "File+Helper.h"
#import "PYFileController.h"
#import "PYTextController.h"
#import "Constants.h"

@interface PYDetailPopupController ()

@end

@implementation PYDetailPopupController

-(id)initWithWindowNibName:(NSString *)windowNibName andFiles:(NSArray *)files {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        [NSApp activateIgnoringOtherApps:YES];
        _files = [files copy];
        _pryvType = kPYEventypeFiles;
    }
    
    return self;
}

-(id)initWithWindowNibName:(NSString *)windowNibName andText:(NSString *)text {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        [NSApp activateIgnoringOtherApps:YES];
        [_pryvButton setAction:@selector(pryvText:)];
        _text = [text copy];
        _pryvType = kPYEvenTypeText;
    }
    
    return self;
}

- (IBAction)pryvFiles:(id)sender {
    User *current = [User currentUser];
    NSString* streamId;
    if ([[_streamPopUpButton titleOfSelectedItem] isEqualTo:@""]) {
        streamId = [[current streams] objectForKey:@"0"];
    }else {
        //				NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
        NSString *streamIndex = [NSString stringWithFormat:@"%lu"
                                 ,[_streamPopUpButton indexOfSelectedItem]];
        streamId = [[current streams] objectForKey:streamIndex];
    }
    
    PYFileController *fileController = [[PYFileController alloc] init];
    [fileController pryvFiles:[_files autorelease]
                   inStreamId:streamId
                     withTags:[NSArray arrayWithArray:[_tagsTokenField objectValue]]];
    [fileController release];
    
    [self close];
    
}


-(IBAction)pryvText:(id)sender{
    User *current = [User currentUser];
    NSString* streamId;
    if ([[_streamPopUpButton titleOfSelectedItem] isEqualTo:@""]) {
        streamId = [[current streams] objectForKey:@"0"];
    }else {
        //				NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
        NSString *streamIndex = [NSString stringWithFormat:@"%lu"
                                 ,[_streamPopUpButton indexOfSelectedItem]];
        streamId = [[current streams] objectForKey:streamIndex];
    }
    
    PYTextController *textController = [[PYTextController alloc] init];
    
    [textController pryvText:_text
                  inStreamId:streamId
                    withTags:[NSArray arrayWithArray:[_tagsTokenField objectValue]]];
    
    [textController release];
    
    [self close];
    
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    if ([_pryvType isEqualToString:kPYEventypeFiles]){
        
        [_pryvButton setAction:@selector(pryvFiles:)];
        [_pryvButton setTitle:@"Pryv file"];
        [_detailsWindow setTitle:@"Pryv file"];
        
        NSString *label = [NSString
                           stringWithFormat:@"You are about to pryv the file %@."
                           ,[(NSURL*)[_files objectAtIndex:0] lastPathComponent]];
        [_infoToPryv setStringValue:label];
        
        
        
    }else if ([_pryvType isEqualToString:kPYEvenTypeText]){
        
        [_pryvButton setAction:@selector(pryvText:)];
        [_pryvButton setTitle:@"Pryv text"];
        [_detailsWindow setTitle:@"Pryv text"];
        NSString *label = [NSString stringWithFormat:@"You are about to pryv some text."];
        [_infoToPryv setStringValue:label];
        
    }
    
    User *current = [User currentUser];
    current.streams = [[NSMutableDictionary alloc] init];
    [PYUtility setupStreamPopUpButton:_streamPopUpButton
                  withArrayController:_popUpButtonContent
                              forUser:current];
    
}

-(void)awakeFromNib{
    
}

@end
