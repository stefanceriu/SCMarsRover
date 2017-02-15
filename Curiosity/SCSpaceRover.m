//
//  SCSpaceRover.m
//  Curiosity
//
//  Created by Stefan Ceriu on 13/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "SCSpaceRover.h"

@interface SCSpaceRover ()

@property (nonatomic, assign) CGSize plateauBounds;

@property (nonatomic, assign) CGPoint position;

@property (nonatomic, assign) SCSpaceRoverHeading heading;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation SCSpaceRover

- (instancetype)initPlateauBounds:(CGSize)plateauBounds
                  initialPosition:(CGPoint)initialPosition
                   initialHeading:(SCSpaceRoverHeading)initialHeading
{
    if(self = [super init]) {
        _plateauBounds = plateauBounds;
        _position = initialPosition;
        _heading = initialHeading;
        
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

- (void)processCommands:(NSArray *)commands withCallback:(void(^)())callback
{
    [commands enumerateObjectsUsingBlock:^(NSNumber *commandNumber, NSUInteger idx, BOOL *stop) {
        SCSpaceRoverCommand command = [commandNumber unsignedIntegerValue];
        
        [self.operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
            switch (command) {
                case SCSpaceRoverCommandMoveLeft: {
                    [self _turnLeft];
                    break;
                }
                case SCSpaceRoverCommandMoveRight: {
                    [self _turnRight];
                    break;
                }
                case SCSpaceRoverCommandAdvance: {
                    [self _advance];
                    break;
                }
            }
        }]];
        
        [self.operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
            sleep(1);
        }]];
    }];
    
    [self.operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        if(callback) {
            callback();
        }
    }]];
}

#pragma mark - Private

- (void)_turnLeft
{
    if(self.heading == SCSpaceRoverHeadingNorth) {
        self.heading = SCSpaceRoverHeadingWest;
    } else {
        self.heading = self.heading - 1;
    }
}

- (void)_turnRight
{
    if(self.heading == SCSpaceRoverHeadingWest) {
        self.heading = SCSpaceRoverHeadingNorth;
    } else {
        self.heading = self.heading + 1;
    }
}

- (void)_advance
{
    switch (self.heading) {
        case SCSpaceRoverHeadingNorth:
            self.position = CGPointMake(self.position.x, self.position.y + 1);
            break;
        case SCSpaceRoverHeadingEast:
            self.position = CGPointMake(self.position.x + 1, self.position.y);
            break;
        case SCSpaceRoverHeadingSouth:
            self.position = CGPointMake(self.position.x, self.position.y - 1);
            break;
        case SCSpaceRoverHeadingWest:
            self.position = CGPointMake(self.position.x - 1, self.position.y);
            break;
    }
    
    if(!CGRectContainsPoint(CGRectMake(0, 0, self.plateauBounds.width, self.plateauBounds.height), self.position)) {
        NSLog(@"I just fell off the edge of the world. Bbye now.");
    }
}

- (void)setPosition:(CGPoint)position
{
    if(CGPointEqualToPoint(_position, position)) {
        return;
    }
    
    _position = position;
    
    [self.delegate spaceRoverDidChangePosition:self];
}

- (void)setHeading:(SCSpaceRoverHeading)heading
{
    if(_heading == heading) {
        return;
    }
    
    _heading = heading;
    
    [self.delegate spaceRoverDidChangeHeading:self];
}

@end
