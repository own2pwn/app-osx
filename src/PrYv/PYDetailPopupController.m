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


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSString *label = [NSString stringWithFormat:@"You are about to pryv the file %@",[(NSURL*)[_files objectAtIndex:0] lastPathComponent]];
    [_fileToPryv setStringValue:label];
	User *current = [User currentUserInContext:[[PYAppDelegate sharedInstance] managedObjectContext]];
	current.streams = [[NSMutableDictionary alloc] init];
    PYUtility *utility = [[PYUtility alloc] init];
    [utility setupStreamPopUpButton:_streamPopUpButton withArrayController:_popUpButtonContent forUser:current];
    
    [utility release];
}

-(void)awakeFromNib{
    
}

@end
