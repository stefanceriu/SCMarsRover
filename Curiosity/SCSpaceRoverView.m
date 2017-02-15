//
//  SCSpaceRoverView.m
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "SCSpaceRoverView.h"

@interface SCSpaceRoverView ()

@property (nonatomic, strong) NSImageView *imageView;

@end

@implementation SCSpaceRoverView

- (instancetype)init
{
    if(self = [super init]) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if(self = [super initWithFrame:frameRect]) {
        [self _commonInit];
    }
    
    return self;
}

- (void)_commonInit
{
    [self setWantsLayer:YES];
    [self setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    
    _imageView = [[NSImageView alloc] initWithFrame:self.bounds];
    [_imageView setWantsLayer:YES];
    [_imageView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [_imageView setImageScaling:NSImageScaleProportionallyUpOrDown];
    [self addSubview:_imageView];
    
    [self setDirection:self.direction];
}

- (void)setDirection:(SCSpaceRoverViewDirection)direction
{
    _direction = direction;
    
    static NSDictionary *directionToImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        directionToImage = @{@(SCSpaceRoverViewDirectionUp)    : @"curiosityUp",
                             @(SCSpaceRoverViewDirectionRight) : @"curiosityRight",
                             @(SCSpaceRoverViewDirectionDown)  : @"curiosityDown",
                             @(SCSpaceRoverViewDirectionLeft)  : @"curiosityLeft"};
    });
    
    //Because reasons and because NSImageView is really weird
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageView setImage:[NSImage imageNamed:directionToImage[@(direction)]]];
    });
}

@end
