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

@interface PYDetailPopupController ()

@end

@implementation PYDetailPopupController

-(id)initWithWindowNibName:(NSString *)windowNibName andFiles:(NSArray *)files {
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        _files = [files copy];
    }
    
    return self;
}

- (IBAction)pryvFilesWithDetails:(id)sender {
    User *current = [User currentUser];
    NSString* streamId;
    if ([[_streamPopUpButton titleOfSelectedItem] isEqualTo:@""]) {
        streamId = @"diary";
    }else {
        //				NSString *streamName = [NSString stringWithString:[_streams titleOfSelectedItem]];
        NSString *streamIndex = [NSString stringWithFormat:@"%lu",[_streamPopUpButton indexOfSelectedItem]];
        streamId = [[current streams] objectForKey:streamIndex];
    }
    
    PYFileController *fileController = [[PYFileController alloc] init];
    [fileController pryvFiles:[_files autorelease]
                   inStreamId:@"diary"
                     withTags:[NSArray arrayWithArray:[_tagsTokenField objectValue]]];
    [fileController release];
    
    [self close];

}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSString *label = [NSString stringWithFormat:@"You are about to pryv the file %@",[(NSURL*)[_files objectAtIndex:0] lastPathComponent]];
    [_fileToPryv setStringValue:label];
	User *current = [User currentUser];
	current.streams = [[NSMutableDictionary alloc] init];
    PYUtility *utility = [[PYUtility alloc] init];
    [utility setupStreamPopUpButton:_streamPopUpButton withArrayController:_popUpButtonContent forUser:current];
    
    [utility release];
}

-(void)awakeFromNib{
    
}

@end
