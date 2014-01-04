//
//  DragAndDropStatusMenuView.m
//  PrYv
//
//  Created by Victor Kristof on 13.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import "DragAndDropStatusMenuView.h"
#import "PYFileController.h"
#import "PYStatusMenuController.h"
#import "PYDetailPopupController.h"

@interface DragAndDropStatusMenuView ()

-(void)mouseDown:(NSEvent *)theEvent;
-(void)menuWillOpen:(NSMenu *)menu;
-(void)menuDidClose:(NSMenu *)menu;
-(void)drawRect:(NSRect)dirtyRect;
-(NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender;

@end

@implementation DragAndDropStatusMenuView

@synthesize statusItem = _statusItem;
@synthesize statusMenuController = _statusMenuController;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		_statusItem = nil;
		_menu = nil;
        _statusMenuController = nil;
		_isMenuVisible = NO;
        [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
    }
	
    return self;
}


-(void)drawRect:(NSRect)dirtyRect {
	// Draw status bar background, highlighted if menu is showing
    [_statusItem drawStatusBarBackgroundInRect:[self bounds]
                                withHighlight:_isMenuVisible];
	NSRect rect = {0,0,22,22};
	[[NSImage imageNamed:@"FaviconBlack22.png"] drawInRect:dirtyRect
												  fromRect:rect
												 operation:NSCompositeSourceOver
												  fraction:1];
}

-(void)mouseDown:(NSEvent *)theEvent {
	[[self menu] setDelegate:self];
    [_statusMenuController updateLastPryvedEvents];
	[_statusItem popUpStatusItemMenu:[self menu]];
    //[self setNeedsDisplay:YES];
}

- (void)menuWillOpen:(NSMenu *)menu {
    _isMenuVisible = YES;
    [self setNeedsDisplay:YES];
    //[_menu update];
}

- (void)menuDidClose:(NSMenu *)menu {
    _isMenuVisible = NO;
    [self.menu setDelegate:nil];
    [self setNeedsDisplay:YES];
}

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
		__block NSMutableArray *urls = [[NSMutableArray alloc] init];
		[files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			[urls addObject:[NSURL fileURLWithPath:obj]];
		}];
        
        PYDetailPopupController *detailPopupController =[[PYDetailPopupController alloc]
                                                         initWithWindowNibName:@"DetailPopupController"
                                                         andFiles:files];
        [detailPopupController showWindow:self];
        
//		PYFileController *fileController = [[PYFileController alloc] init];
//		[fileController pryvFiles:[urls autorelease]
//						 inStreamId:@"diary"
//					withTags:[[[NSArray alloc] init] autorelease]];
//		[fileController release];
    }
    return YES;
}

-(void)dealloc {
	[_statusItem release];
	_statusItem = nil;
	[super dealloc];
}

@end
