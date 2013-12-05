//
//  PYPreferencesPaneControllerViewController.m
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import "PYPreferencesPaneController.h"

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


@end
