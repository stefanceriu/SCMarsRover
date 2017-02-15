//
//  AppDelegate.m
//  Curiosity
//
//  Created by Stefan Ceriu on 13/02/2017.
//  Copyright © 2017 stefanceriu. All rights reserved.
//

#import "AppDelegate.h"

#import "SCCommandCenter.h"
#import "SCRootViewController.h"

@interface AppDelegate () <SCRootViewControllerDelegate>

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, strong) SCCommandCenter *commandCenter;
@property (nonatomic, strong) SCRootViewController *rootViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.commandCenter = [[SCCommandCenter alloc] init];
    
    self.rootViewController = [[SCRootViewController alloc] initWithCommandCenter:self.commandCenter];
    [self.rootViewController setDelegate:self];
    
    [self.window setContentView:self.rootViewController.view];
}

#pragma mark - SCRootViewControllerDelegate

- (void)rootViewControllerDidRequestDeployment:(SCRootViewController *)rootViewController
{
    [self.commandCenter processInput:(@"5 5\n"
                                      "1 2 N\n"
                                      "LMLMLMLMM\n"
                                      "3 3 E\n"
                                      "MMRMMRMRRM")];
}

#pragma mark - Others

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
