//
//  DragAndDropStatusMenuView.h
//  PrYv
//
//  Created by Victor Kristof on 13.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DragAndDropStatusMenuView : NSView <NSDraggingDestination, NSObject, NSMenuDelegate>{
@private
	NSMenu *_menu;
	BOOL _isMenuVisible;
	
}
@property(retain, nonatomic) NSStatusItem* statusItem;

@end
