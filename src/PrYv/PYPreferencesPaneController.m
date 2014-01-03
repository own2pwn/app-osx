//
//  PYPreferencesPaneControllerViewController.m
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import "PYPreferencesPaneController.h"

@interface PYPreferencesPaneController ()

- (BOOL)launchOnLogin;

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

-(IBAction)checkBoxState : (id)sender;
{
    if (100==[sender tag]) {
        [self launchOnLogin];
    }
    
}

-(NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:@"0",@"1", nil];
}


-(void)windowDidLoad{
    [super windowDidLoad];
    [_toolbar setSelectedItemIdentifier:@"0"];    
}

-(BOOL)launchOnLogin {
    if (self.launchOnLoginSwitch.state == NSOnState) {
        NSLog(@"Launch YES");
        return YES;
    }else {
        NSLog(@"Launch NO");
        return NO;
    }
}

@end
