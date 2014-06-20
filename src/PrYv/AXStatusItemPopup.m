//
//  StatusItemPopup.m
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//

#import "AXStatusItemPopup.h"
#import "Constants.h"
#import "PYDetailPopupController.h"
#import "PYAppDelegate.h"

#define kMinViewWidth 22

//
// Private variables
//
@interface AXStatusItemPopup () {
    NSViewController *_viewController;
    BOOL _active;
    BOOL _connected;
    NSImageView *_imageView;
    NSStatusItem *_statusItem;
    NSPopover *_popover;
    id _popoverTransiencyMonitor;
}
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender;
@end

///////////////////////////////////

//
// Implementation
//
@implementation AXStatusItemPopup

- (id)initWithViewController:(NSViewController *)controller
{
    return [self initWithViewController:controller image:nil];
}

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image
{
    return [self initWithViewController:controller image:image alternateImage:nil];
}

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage
{
    return [self initWithViewController:controller image:image alternateImage:alternateImage disconnectedImage:nil];
}


- (id)initWithViewController:(NSViewController *)controller
                       image:(NSImage *)image
              alternateImage:(NSImage *)alternateImage
           disconnectedImage:(NSImage *)disconnectedImage
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    self = [super initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
    if (self) {
        _viewController = controller;
        
        self.image = image;
        self.alternateImage = alternateImage;
        self.disconnectedImage = disconnectedImage;
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
        [self addSubview:_imageView];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.view = self;
        
        _active = NO;
        _animated = YES;
        _connected = YES;
        
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
    }
    return self;
}


////////////////////////////////////
#pragma mark - Drawing
////////////////////////////////////

- (void)drawRect:(NSRect)dirtyRect
{
    // set view background color
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
    } else {
        [[NSColor clearColor] setFill];
    }
    NSRectFill(dirtyRect);
    
    // set image
    _connected = [[PYAppDelegate sharedInstance] connected];
    NSImage *image = (_active ? _alternateImage : (_connected ? _image : _disconnectedImage));
    
    _imageView.image = image;
}

////////////////////////////////////
#pragma mark - Position / Size
////////////////////////////////////

- (void)setContentSize:(CGSize)size
{
    _popover.contentSize = size;
}

////////////////////////////////////
#pragma mark - Mouse Actions
////////////////////////////////////

- (void)mouseDown:(NSEvent *)theEvent
{
    if (_popover.isShown) {
        [self hidePopover];
    } else {
        [self showPopover];
    }    
}

////////////////////////////////////
#pragma mark - Setter
////////////////////////////////////

- (void)setActive:(BOOL)active
{
    _active = active;
    [self setNeedsDisplay:YES];
}

- (void)setImage:(NSImage *)image
{
    _image = image;
    [self updateViewFrame];
}

- (void)setAlternateImage:(NSImage *)image
{
    _alternateImage = image;
    if (!image && _image) {
        _alternateImage = _image;
    }
    [self updateViewFrame];
}

////////////////////////////////////
#pragma mark - Helper
////////////////////////////////////

- (void)updateViewFrame
{
    CGFloat width = MAX(MAX(kMinViewWidth, self.alternateImage.size.width), self.image.size.width);
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    NSRect frame = NSMakeRect(0, 0, width, height);
    self.frame = frame;
    _imageView.frame = frame;
    
    [self setNeedsDisplay:YES];
}

////////////////////////////////////
#pragma mark - Show / Hide Popover
////////////////////////////////////

- (void)showPopover
{
    [self showPopoverAnimated:_animated];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    self.active = YES;
    
    if (!_popover) {
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = _viewController;
    }
    
    if (!_popover.isShown) {
        _popover.animates = animated;
        [_popover showRelativeToRect:self.frame ofView:self preferredEdge:NSMinYEdge];
        _popoverTransiencyMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask handler:^(NSEvent* event) {
            [self hidePopover];
        }];
    }
}

- (void)hidePopover
{
    self.active = NO;
    
    if (_popover && _popover.isShown) {
        [_popover close];

		if (_popoverTransiencyMonitor) {
            [NSEvent removeMonitor:_popoverTransiencyMonitor];
            _popoverTransiencyMonitor = nil;
        }
    }
}

////////////////////////////////////
#pragma mark - Drag and Drop
////////////////////////////////////

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        NSString *file = [files objectAtIndex:0];
        BOOL isDirectory;
        if([[NSFileManager defaultManager]
            fileExistsAtPath:file isDirectory:&isDirectory] && isDirectory){
            NSLog(@"Is directory");
        }
        NSInteger *userChoice = NSAlertDefaultReturn;
        if ([files count] > 1 || ([[NSFileManager defaultManager] fileExistsAtPath:file isDirectory:&isDirectory] && isDirectory)){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSAlert *alert = [NSAlert alertWithMessageText:@"Pryving multiple files"
                                             defaultButton:@"OK"
                                           alternateButton:@"Cancel"
                                               otherButton:nil
                                 informativeTextWithFormat:@"You are about to pryv multiple files at once. One event will be created per file."];
            [alert setShowsSuppressionButton:YES];
            if (![defaults objectForKey:kPYMultipleFilesAlert]) userChoice = [alert runModal];
            if ([[alert suppressionButton] state] == NSOnState) {
                // Suppress this alert from now on.
                [defaults setBool:YES forKey:kPYMultipleFilesAlert];
            }
        }
        
        if ((int)userChoice == NSAlertDefaultReturn){
            __block NSMutableArray *urls = [[NSMutableArray alloc] init];
            [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [urls addObject:[NSURL fileURLWithPath:obj]];
            }];
            
            PYDetailPopupController *detailPopupController =[[PYDetailPopupController alloc]
                                                             initWithWindowNibName:@"DetailPopupController"
                                                             andFiles:urls];
            [detailPopupController showWindow:self];
            [detailPopupController.window makeKeyAndOrderFront:self];
            
        }
    }
    return YES;
}


@end

