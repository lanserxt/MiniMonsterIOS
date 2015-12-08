//
//  MMPDeviceDataViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 24.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceDataViewController.h"

@interface MMPDeviceDataViewController () <MMPDeviceDelegate>

@end

@implementation MMPDeviceDataViewController

- (void) updateControls
{
    
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    [[MMPDevicesUtils sharedUtils] setDelegate: self];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

#pragma mark - Device Delegate

- (void) deviceIsUpdated: (NSString *) deviceId
{
    [self updateControls];
    NSLog(@"Updated %@", deviceId);
}

@end
