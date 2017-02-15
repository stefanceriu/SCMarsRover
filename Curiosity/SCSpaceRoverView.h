//
//  SCSpaceRoverView.h
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSUInteger, SCSpaceRoverViewDirection) {
    SCSpaceRoverViewDirectionUp,
    SCSpaceRoverViewDirectionRight,
    SCSpaceRoverViewDirectionDown,
    SCSpaceRoverViewDirectionLeft
};

@interface SCSpaceRoverView : NSView

@property (nonatomic, assign) CGPoint gridPosition;

@property (nonatomic, assign) SCSpaceRoverViewDirection direction;

@end
