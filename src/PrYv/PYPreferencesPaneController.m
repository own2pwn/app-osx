//
//  PYPreferencesPaneControllerViewController.m
//  osx-integration
//
//  Created by Victor Kristof on 05.12.13.
//  Copyright (c) 2013 Pryv. All rights reserved.
//

#import "PYPreferencesPaneController.h"
#import "StartAtLoginController.h"
#import "Constants.h"
#import <ServiceManagement/ServiceManagement.h>

@interface PYPreferencesPaneController ()

-(void) enableStartAtLogin:(BOOL)state;
-(void) setAppVersion;
-(void) setLaunchAtLogin;

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
    
    [self setLaunchAtLogin];
    [self setAppVersion];
    
}

-(IBAction)toggleLaunchAtLogin:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    
    if (clickedSegment == 0) { // ON
        [self enableStartAtLogin:YES];
        
        // Turn on launch at login
//        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.pryv.PryvHelper", YES)) {
//            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
//                                             defaultButton:@"OK"
//                                           alternateButton:nil
//                                               otherButton:nil
//                                 informativeTextWithFormat:@"Couldn't add Helper App to launch at login item list."];
//            [alert runModal];
//        }
    }
    if (clickedSegment == 1) { //
        [self enableStartAtLogin:NO];
        
        // Turn off launch at login
//        if (!SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.pryv.PryvHelper", NO)) {
//            NSAlert *alert = [NSAlert alertWithMessageText:@"An error ocurred"
//                                             defaultButton:@"OK"
//                                           alternateButton:nil
//                                               otherButton:nil
//                                 informativeTextWithFormat:@"Couldn't remove Helper App from launch at login item list."];
//            [alert runModal];
//            
//        }
    }
}


#pragma mark - Private Methods

-(void) enableStartAtLogin:(BOOL)state{
    
    StartAtLoginController *loginController = [[StartAtLoginController alloc]
                                               initWithIdentifier:kPYHelperBundleId];
    NSString *identifier;
    if (state) identifier = @"1";
    else identifier = @"0";
    
    loginController.enabled = state;
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:kPYStartAtLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAppVersion{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
    NSString *labelText = [NSString
                           stringWithString:[kPYAppVersionPrefix stringByAppendingString:version]];
    //NSString *labelText = [NSString stringWithFormat:@" %@", version];
    [_appVersionLabel setStringValue:labelText];
}

-(void)setLaunchAtLogin{
    NSString* selectedIdentifier = [[NSUserDefaults standardUserDefaults]
                                    objectForKey:kPYStartAtLogin];
    
    if ([selectedIdentifier isEqualToString:@"1"])
        [_launchAtLoginSwitch setSelectedSegment:0];
    else
        [_launchAtLoginSwitch setSelectedSegment:1];
    
    [_toolbar setSelectedItemIdentifier:kPYPreferencesGeneralTab];

}

@end
