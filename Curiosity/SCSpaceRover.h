//
//  SCSpaceRover.h
//  Curiosity
//
//  Created by Stefan Ceriu on 13/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, SCSpaceRoverHeading) {
    SCSpaceRoverHeadingNorth,
    SCSpaceRoverHeadingEast,
    SCSpaceRoverHeadingSouth,
    SCSpaceRoverHeadingWest
};

typedef NS_ENUM (NSUInteger, SCSpaceRoverCommand) {
    SCSpaceRoverCommandMoveLeft = 1,
    SCSpaceRoverCommandMoveRight,
    SCSpaceRoverCommandAdvance
};

@protocol SCSpaceRoverDelegate;

@interface SCSpaceRover : NSObject

- (instancetype)initPlateauBounds:(CGSize)plateauBounds
                  initialPosition:(CGPoint)initialPosition
                   initialHeading:(SCSpaceRoverHeading)initialHeading;

- (void)processCommands:(NSArray *)commands withCallback:(void(^)())callback;

@property (nonatomic, assign, readonly) CGPoint position;

@property (nonatomic, assign, readonly) SCSpaceRoverHeading heading;

@property (nonatomic, weak) id<SCSpaceRoverDelegate> delegate;

@end

@protocol SCSpaceRoverDelegate <NSObject>

- (void)spaceRoverDidChangePosition:(SCSpaceRover *)spaceRover;

- (void)spaceRoverDidChangeHeading:(SCSpaceRover *)spaceRover;

@end
