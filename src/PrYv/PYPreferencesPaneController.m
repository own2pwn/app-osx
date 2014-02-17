//
//  PYPreferencesPaneControllerViewController.m
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import "PYPreferencesPaneController.h"
#import <ServiceManagement/ServiceManagement.h>

@interface PYPreferencesPaneController ()

@end

@implementation PYPreferencesPaneController

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    if (self) {
        
    }
    return self;
}

- (IBAction)changeTabView:(id)sender {
    [_tabView selectTabViewItemAtIndex:[sender tag]];
    NSString *identifier = [NSString stringWithFormat:@"%ld",(long)[sender tag]];
    [_toolbar setSelectedItemIdentifier:identifier];
}

-(NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:@"0",@"1", nil];
}


-(void)windowDidLoad{
    [super windowDidLoad];
    [_toolbar setSelectedItemIdentifier:@"0"];    
}

-(IBAction)toggleLaunchAtLogin:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    if (clickedSegment == 0) { // ON
                               // Turn on launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.pryv.PryvHelper", YES)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Couldn't add Helper App to launch at login item list."];
            [alert runModal];
        }
    }
    if (clickedSegment == 1) { // OFF
                               // Turn off launch at login
        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.pryv.PryvHelper", NO)) {
            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
                                             defaultButton:@"OK"
                                           alternateButton:nil
                                               otherButton:nil
                                 informativeTextWithFormat:@"Couldn't remove Helper App from launch at login item list."];
            [alert runModal];
        }
    }
}

@end
