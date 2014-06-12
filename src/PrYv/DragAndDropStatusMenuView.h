//
//  DragAndDropStatusMenuView.h
//  PrYv
//
//  Created by Victor Kristof on 13.02.13.
//  Copyright (c) 2013 PrYv. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PYStatusMenuController;

@interface DragAndDropStatusMenuView : NSView <NSObject, NSMenuDelegate>{
@private
	NSMenu *_menu;
	BOOL _isMenuVisible;
    BOOL _connected;
	
}
@property(retain, nonatomic) NSStatusItem* statusItem;
@property(retain, nonatomic) PYStatusMenuController *statusMenuController;

@end
