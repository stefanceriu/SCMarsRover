//
//  SCCommandCenter.m
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "SCCommandCenter.h"
#import "SCSpaceRover.h"

@interface SCCommandCenter ()

@property (nonatomic, strong, readonly) NSMutableArray<SCSpaceRover *> *spaceRovers;

@property (nonatomic, assign) CGSize plateauSize;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation SCCommandCenter

- (instancetype)init
{
    if(self = [super init]) {
        _spaceRovers = [[NSMutableArray alloc] init];
        
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return self;
}

- (void)processInput:(NSString *)input
{
    [self.spaceRovers removeAllObjects];
    
    NSParameterAssert(input.length > 0);
    
    NSArray<NSString *> *lines = [input componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray<NSString *> *plateauComponents = [lines.firstObject componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(plateauComponents.count == 2, @"Plateau details should only comprise of 2 components");
    self.plateauSize = CGSizeMake(plateauComponents.firstObject.integerValue + 1, plateauComponents.lastObject.integerValue + 1);
    
    dispatch_group_t dispatchGroup = dispatch_group_create();
    [[lines subarrayWithRange:NSMakeRange(1, lines.count - 1)] enumerateObjectsUsingBlock:^(NSString *line, NSUInteger lineIndex, BOOL *stop) {
        if(lineIndex % 2 == 0) {
            [self _deployRoverWithInput:line];
        } else {
            dispatch_group_enter(dispatchGroup);
            [self.operationQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
                SCSpaceRover *spaceRover = self.spaceRovers[lineIndex/2];
                
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                [spaceRover processCommands:[self _buildCommandsOutOfInputLine:line] withCallback:^{
                    dispatch_semaphore_signal(semaphore);
                    dispatch_group_leave(dispatchGroup);
                }];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            }]];
        }
    }];
    
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
        [self.delegate commandCenterDidFinishProcessingInput:self];
        
        [self.spaceRovers enumerateObjectsUsingBlock:^(SCSpaceRover *rover, NSUInteger idx, BOOL *stop) {
            [self _printSpaceRoverDetails:rover];
        }];
    });
}

#pragma mark - Private

- (void)_deployRoverWithInput:(NSString *)input
{
    NSArray<NSString *> *deploymentComponents = [input componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSAssert(deploymentComponents.count == 3, @"Rover deployment details should comprise of only 3 components");
    
    CGPoint position = CGPointMake(deploymentComponents[0].integerValue, deploymentComponents[1].integerValue);
    
    static NSDictionary *cardinalLetterToSpaceRoverHeading;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cardinalLetterToSpaceRoverHeading = @{@"N" : @(SCSpaceRoverHeadingNorth),
                                              @"E" : @(SCSpaceRoverHeadingEast),
                                              @"S" : @(SCSpaceRoverHeadingSouth),
                                              @"W" : @(SCSpaceRoverHeadingWest)};
    });
    
    SCSpaceRover *spaceRover = [[SCSpaceRover alloc] initPlateauBounds:self.plateauSize initialPosition:position initialHeading:[cardinalLetterToSpaceRoverHeading[deploymentComponents.lastObject] unsignedIntegerValue]];
    [self.spaceRovers addObject:spaceRover];
    
    [self.delegate commandCenter:self didDeployRover:spaceRover];
}

- (NSArray *)_buildCommandsOutOfInputLine:(NSString *)line
{
    NSParameterAssert([line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].count == 1);
    
    static NSDictionary *letterToCommand;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        letterToCommand = @{@"L" : @(SCSpaceRoverCommandMoveLeft),
                            @"R" : @(SCSpaceRoverCommandMoveRight),
                            @"M" : @(SCSpaceRoverCommandAdvance)};
    });
    
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    
    for (NSInteger charIndex = 0; charIndex < line.length; charIndex++) {
        [commands addObject:@([letterToCommand[[line substringWithRange:NSMakeRange(charIndex, 1)]] unsignedIntegerValue])];
    }
    
    return commands;
}

- (void)_printSpaceRoverDetails:(SCSpaceRover *)spaceRover
{
    static NSDictionary *roverHeadingToCardinalLetter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        roverHeadingToCardinalLetter = @{@(SCSpaceRoverHeadingNorth) : @"N",
                                         @(SCSpaceRoverHeadingEast)  : @"E",
                                         @(SCSpaceRoverHeadingSouth) : @"S",
                                         @(SCSpaceRoverHeadingWest)  : @"W"};
    });
    
    NSLog(@"%d %d %@", (int)spaceRover.position.x, (int)spaceRover.position.y, roverHeadingToCardinalLetter[@(spaceRover.heading)]);
}

#pragma mark - Private setters

- (void)setPlateauSize:(CGSize)plateauSize
{
    if(CGSizeEqualToSize(_plateauSize, plateauSize)) {
        return;
    }
    
    _plateauSize = plateauSize;
    
    [self.delegate commandCenter:self didProcessPlateauSize:plateauSize];
}

@end
