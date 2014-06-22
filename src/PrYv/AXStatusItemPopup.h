//
//  StatusItemPopup.h
//  StatusItemPopup
//
//  Created by Alexander Schuch on 06/03/13.
//  Copyright (c) 2013 Alexander Schuch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (canBecomeKeyWindow)

@end

@protocol AXStatusItemPopupDelegate <NSObject>

@optional

- (BOOL) shouldPopupOpen;
- (void) popupWillOpen;
- (void) popupDidOpen;

- (BOOL) shouldPopupClose;
- (void) popupWillClose;
- (void) popupDidClose;

@end

@interface AXStatusItemPopup : NSView <NSPopoverDelegate>

// properties
@property(assign, nonatomic, getter=isAnimated) BOOL animated;
@property(retain, nonatomic) NSStatusItem *statusItem;
@property(retain, nonatomic) NSImage *image;
@property(retain, nonatomic) NSImage *alternateImage;
@property(retain, nonatomic) NSImage *disconnectedImage;
@property(assign) id<AXStatusItemPopupDelegate> delegate;


// alloc
+ (id)statusItemPopupWithViewController:(NSViewController *)controller;
+ (id)statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image;
+ (id)statusItemPopupWithViewController:(NSViewController *)controller image:(NSImage *)image alternateImage:(NSImage *)alternateImage;

// init
- (id)initWithViewController:(NSViewController *)controller;
- (id)initWithViewController:(NSViewController *)controller
                       image:(NSImage *)image;
- (id)initWithViewController:(NSViewController *)controller
                       image:(NSImage *)image
              alternateImage:(NSImage *)alternateImage;
- (id)initWithViewController:(NSViewController *)controller
                       image:(NSImage *)image
              alternateImage:(NSImage *)alternateImage
           disconnectedImage:(NSImage *)disconnectedImage;



// show / hide popover
- (void)togglePopover;
- (void)togglePopoverAnimated: (BOOL)animated;
- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;

@end
