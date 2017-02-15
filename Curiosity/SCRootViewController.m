//
//  SCRootViewController.m
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "SCRootViewController.h"
#import "SCRootViewControllerView.h"

#import "SCCommandCenter.h"
#import "SCSpaceRover.h"

#import "SCSpaceRoverView.h"

@interface SCRootViewController () <SCCommandCenterDelegate, SCSpaceRoverDelegate>

@property (nonatomic, strong) SCCommandCenter *commandCenter;

@property (nonatomic, strong) NSMapTable *roversToViews;

@property (nonatomic, weak) IBOutlet NSButton *deployButton;

@end

@implementation SCRootViewController

- (instancetype)initWithCommandCenter:(SCCommandCenter *)commandCenter
{
    if(self = [super init]) {
        _commandCenter = commandCenter;
        [_commandCenter setDelegate:self];
        
        _roversToViews = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsWeakMemory];
    }
    
    return self;
}

#pragma mark - SCCommandCenterDelegate

- (void)commandCenter:(SCCommandCenter *)commandCenter didProcessPlateauSize:(CGSize)plateauSize
{
    [(SCRootViewControllerView *)self.view setGridSize:plateauSize];
}

- (void)commandCenter:(SCCommandCenter *)commandCenter didDeployRover:(SCSpaceRover *)spaceRover
{
    SCSpaceRoverView *spaceRoverView = [[SCSpaceRoverView alloc] init];
    [spaceRoverView setGridPosition:spaceRover.position];
    [(SCRootViewControllerView *)self.view addSpaceRoverView:spaceRoverView];
    
    [self.roversToViews setObject:spaceRoverView forKey:spaceRover];
    [spaceRover setDelegate:self];
}

- (void)commandCenterDidFinishProcessingInput:(SCCommandCenter *)commandCenter
{
    [self.deployButton setHidden:NO];
}

#pragma mark - SCSpaceRoverDelegate

- (void)spaceRoverDidChangeHeading:(SCSpaceRover *)spaceRover
{
    SCSpaceRoverView *spaceRoverView = [self.roversToViews objectForKey:spaceRover];
    [self _updateRoverView:spaceRoverView withRover:spaceRover];
}

- (void)spaceRoverDidChangePosition:(SCSpaceRover *)spaceRover
{
    SCSpaceRoverView *spaceRoverView = [self.roversToViews objectForKey:spaceRover];
    [self _updateRoverView:spaceRoverView withRover:spaceRover];
}

#pragma mark - Private

- (void)_updateRoverView:(SCSpaceRoverView *)spaceRoverView withRover:(SCSpaceRover *)spaceRover
{
    static NSDictionary *spaceRoverHeadingToViewDirection;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        spaceRoverHeadingToViewDirection = @{@(SCSpaceRoverHeadingNorth) : @(SCSpaceRoverViewDirectionUp),
                                             @(SCSpaceRoverHeadingEast)  : @(SCSpaceRoverViewDirectionRight),
                                             @(SCSpaceRoverHeadingSouth) : @(SCSpaceRoverViewDirectionDown),
                                             @(SCSpaceRoverHeadingWest)  : @(SCSpaceRoverViewDirectionLeft)};
    });
    
    [spaceRoverView setDirection:[spaceRoverHeadingToViewDirection[@(spaceRover.heading)] unsignedIntegerValue]];

    [spaceRoverView setGridPosition:spaceRover.position];
    [self.view setNeedsLayout:YES];
}

- (IBAction)_onDeployButtonTap:(NSButton *)sender
{
    [(SCRootViewControllerView *)self.view removeAllSpaceRoverViews];
    [self.delegate rootViewControllerDidRequestDeployment:self];
    [self.deployButton setHidden:YES];
}

@end
