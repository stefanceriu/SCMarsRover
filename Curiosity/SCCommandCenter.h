//
//  SCCommandCenter.h
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCSpaceRover;

@protocol SCCommandCenterDelegate;

@interface SCCommandCenter : NSObject

@property (nonatomic, weak) id<SCCommandCenterDelegate> delegate;

- (void)processInput:(NSString *)input;

@end

@protocol SCCommandCenterDelegate <NSObject>

- (void)commandCenter:(SCCommandCenter *)commandCenter didProcessPlateauSize:(CGSize)plateauSize;

- (void)commandCenter:(SCCommandCenter *)commandCenter didDeployRover:(SCSpaceRover *)spaceRover;

- (void)commandCenterDidFinishProcessingInput:(SCCommandCenter *)commandCenter;

@end
