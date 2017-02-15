//
//  SCRootViewControllerView.m
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "SCRootViewControllerView.h"
#import "SCSpaceRoverView.h"

@interface SCRootViewControllerView ()

@property (nonatomic, strong) NSMutableArray<SCSpaceRoverView *> *rovers;

@end

@implementation SCRootViewControllerView

- (instancetype)init
{
    if(self = [super init]) {
        [self setWantsLayer:YES];
    }
    
    return self;
}

- (void)setGridSize:(CGSize)gridSize
{
    _gridSize = gridSize;
    
    [self setNeedsDisplay:YES];
}

- (void)addSpaceRoverView:(SCSpaceRoverView *)spaceRoverView
{
    [self addSubview:spaceRoverView];
    
    if(self.rovers == nil) {
        self.rovers = [[NSMutableArray alloc] init];
    }
    [self.rovers addObject:spaceRoverView];
    
    [self setNeedsLayout:YES];
}

- (void)removeAllSpaceRoverViews
{
    [self.rovers enumerateObjectsUsingBlock:^(SCSpaceRoverView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    [self.rovers removeAllObjects];
}

- (void)layout
{
    [self.rovers enumerateObjectsUsingBlock:^(SCSpaceRoverView *spaceRoverView, NSUInteger idx, BOOL *stop) {
        [spaceRoverView setFrame:[self rectOfCellAtColumn:spaceRoverView.gridPosition.x row:spaceRoverView.gridPosition.y]];
    }];
}

- (void)drawRect:(NSRect)dirtyRect
{
    for (NSUInteger x = 0; x < self.gridSize.width; x++) {
        for (NSUInteger y = 0; y < self.gridSize.height; y++) {
            NSColor *color = (x % 2 == y % 2) ? [NSColor lightGrayColor] : [NSColor grayColor];
            [color set];
            [NSBezierPath fillRect:[self rectOfCellAtColumn:x row:y]];
        }
    }
}

- (NSRect)rectOfCellAtColumn:(NSUInteger)column row:(NSUInteger)row
{
    NSRect frame = [self frame];
    CGFloat cellWidth = frame.size.width / self.gridSize.width;
    CGFloat cellHeight = frame.size.height / self.gridSize.height;
    
    CGFloat x = column * cellWidth;
    CGFloat y = row * cellHeight;
    
    NSRect rect = NSMakeRect(x, y, cellWidth, cellHeight);
    return [self backingAlignedRect:rect options:(NSAlignMinXNearest | NSAlignMinYNearest | NSAlignMaxXNearest | NSAlignMaxYNearest)];
}

@end
