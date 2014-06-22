//
//  StatusItemPopup.m
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//
//  Source: https://github.com/ShadowLightz/AXStatusItemPopup/tree/working
//

#import "AXStatusItemPopup.h"
#import "PYAppDelegate.h"
#import "Constants.h"
#import "PYDetailPopupController.h"

#define kMinViewWidth 22

BOOL shouldBecomeKeyWindow;
NSWindow* windowToOverride;

//
// Private properties
//
@interface AXStatusItemPopup ()
@property NSViewController *viewController;
@property NSImageView *imageView;
@property NSPopover *popover;
@property(assign, nonatomic, getter=isActive) BOOL active;
@property(assign, nonatomic) BOOL connected;

@end

//#####################################################################################
#pragma mark - Implementation AXStatusItemPopup
//#####################################################################################

@implementation AXStatusItemPopup

//*******************************************************************************
#pragma mark - Allocators
//*******************************************************************************

+ (id) statusItemPopupWithViewController:(NSViewController *)controller
{
    return [[self alloc] initWithViewController:controller];
}

+ (id) statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image
{
    return [[self alloc] initWithViewController:controller image:image];
}

+ (id) statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage
{
    return [[self alloc] initWithViewController:controller image:image alternateImage:alternateImage];
}

//*******************************************************************************
#pragma mark - Initiators
//*******************************************************************************

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

- (id)initWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage disconnectedImage:(NSImage *)disconnectedImage
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    self = [super initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
    if (self)
    {
        _active = NO;
        _animated = YES;
        _viewController = controller;
        
        self.image = image;
        self.alternateImage = alternateImage;
        self.disconnectedImage = disconnectedImage;
        
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, kMinViewWidth, height)];
        [self addSubview:_imageView];
        
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.view = self;
        self.statusItem.target = self;
        self.statusItem.action = @selector(togglePopover:);
        
        self.popover = [[NSPopover alloc] init];
        self.popover.contentViewController = self.viewController;
        self.popover.animates = self.animated;
        self.popover.delegate = self;
        
        windowToOverride = self.window;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidResignActive:) name:NSApplicationDidResignActiveNotification object:nil];
    }
    return self;
}


//*******************************************************************************
#pragma mark - Drawing
//*******************************************************************************

- (void)drawRect:(NSRect)dirtyRect
{
    // set view background color
    if (self.isActive)
    {
        [[NSColor selectedMenuItemColor] setFill];
    } else {
        [[NSColor clearColor] setFill];
    }
    NSRectFill(dirtyRect);
    
    // set image
    self.connected = [[PYAppDelegate sharedInstance] connected];
    NSImage *image = (self.isActive ? self.alternateImage : (self.connected ? self.image : self.disconnectedImage));
    _imageView.image = image;
}

//*******************************************************************************
#pragma mark - Mouse Events
//*******************************************************************************

- (void)mouseDown:(NSEvent *)theEvent
{
    [self togglePopover];
}

//*******************************************************************************
#pragma mark - Setter
//*******************************************************************************

- (void)setActive:(BOOL)active
{
    _active = active;
    shouldBecomeKeyWindow = active;
    [self setNeedsDisplay:YES];
    [NSApp activateIgnoringOtherApps:active];
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

//*******************************************************************************
#pragma mark - Notification Handler
//*******************************************************************************

- (void)applicationDidResignActive:(NSNotification*)note
{
    [self hidePopover];
}

//*******************************************************************************
#pragma mark - Popover Delegate
//*******************************************************************************

//This is safer then caring for the sended events. Sometimes to popup doesn't close, in these
//cases popover and status item became out of sync
- (void) popoverWillShow: (NSNotification*) note
{
    self.active = YES;
}

- (void) popoverWillClose: (NSNotification*) note
{
    self.active = NO;
}

//*******************************************************************************
#pragma mark - Show / Hide Popover
//*******************************************************************************

- (void) togglePopover
{
    [self togglePopoverAnimated:self.isAnimated];
}

- (void) togglePopoverAnimated:(BOOL)animated
{
    if (self.isActive)
    {
        [self hidePopover];
    } else {
        [self showPopoverAnimated:animated];
    }
}

- (void)showPopover
{
    [self showPopoverAnimated:self.isAnimated];
}

- (void)showPopoverAnimated:(BOOL)animated
{
    BOOL willAnswer = [self.delegate respondsToSelector:@selector(shouldPopupOpen)];
    if (!willAnswer || (willAnswer && [self.delegate shouldPopupOpen]))
    {
        if (!self.popover.isShown)
        {
            _popover.animates = animated;
            if ([self.delegate respondsToSelector:@selector(popupWillOpen)])
            {
                [self.delegate popupWillOpen];
            }
            [_popover showRelativeToRect:self.frame ofView:self preferredEdge:NSMinYEdge];
        }
        [self.window makeKeyWindow];
        if ([self.delegate respondsToSelector:@selector(popupDidOpen)])
        {
            [self.delegate popupDidOpen];
        }
    }
}

- (void)hidePopover
{
    BOOL willAnswer = [self.delegate respondsToSelector:@selector(shouldPopupClose)];
    if (!willAnswer || (willAnswer && [self.delegate shouldPopupClose]))
    {
        if (_popover && _popover.isShown)
        {
            if ([self.delegate respondsToSelector:@selector(popupWillClose)])
            {
                [self.delegate popupWillClose];
            }
            [_popover close];
        }
        if ([self.delegate respondsToSelector:@selector(popupDidClose)])
        {
            [self.delegate popupDidClose];
        }
    }
}

//*******************************************************************************
#pragma mark - Helper
//*******************************************************************************

- (void)updateViewFrame
{
    CGFloat width = MAX(MAX(kMinViewWidth, self.alternateImage.size.width), self.image.size.width);
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    
    NSRect frame = NSMakeRect(0, 0, width, height);
    self.frame = frame;
    self.imageView.frame = frame;
    
    [self setNeedsDisplay:YES];
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

//#####################################################################################
#pragma mark - Implementation NSWindow+canBecomeKeyWindow
//#####################################################################################

#import <objc/objc-class.h>

@implementation NSWindow (canBecomeKeyWindow)

//This is to fix a bug with 10.7 where an NSPopover with a text field
//cannot be edited if its parent window won't become key
//This technique is called method swizzling.
- (BOOL)swizzledPopoverCanBecomeKeyWindow
{
    if (self == windowToOverride) {
        return shouldBecomeKeyWindow;
    } else {
        return [self swizzledPopoverCanBecomeKeyWindow];
    }
}

+ (void)load
{
    method_exchangeImplementations(
                                   class_getInstanceMethod(self, @selector(canBecomeKeyWindow)),
                                   class_getInstanceMethod(self, @selector(swizzledPopoverCanBecomeKeyWindow)));
}

@end

