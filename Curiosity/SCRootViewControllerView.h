//
//  SCRootViewControllerView.h
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCSpaceRoverView;

@interface SCRootViewControllerView : NSView

@property (nonatomic, assign) CGSize gridSize;

- (void)addSpaceRoverView:(SCSpaceRoverView *)spaceRoverView;

- (void)removeAllSpaceRoverViews;

@end
