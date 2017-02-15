//
//  SCRootViewController.h
//  Curiosity
//
//  Created by Stefan Ceriu on 15/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCCommandCenter;

@protocol SCRootViewControllerDelegate;

@interface SCRootViewController : NSViewController

- (instancetype)initWithCommandCenter:(SCCommandCenter *)commandCenter;

@property (nonatomic, weak) id<SCRootViewControllerDelegate> delegate;

@end

@protocol SCRootViewControllerDelegate <NSObject>

- (void)rootViewControllerDidRequestDeployment:(SCRootViewController *)rootViewController;

@end
