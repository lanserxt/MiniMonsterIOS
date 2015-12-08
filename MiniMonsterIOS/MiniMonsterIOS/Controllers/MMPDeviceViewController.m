//
//  MMPDeviceViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 24.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceViewController.h"
#import "MMPConstants.h"
#import "MMPDeviceDataViewController.h"

@interface MMPDeviceViewController ()

@end

@implementation MMPDeviceViewController


#pragma mark - Class

+ (instancetype) classObject
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: kMainStoryboard
                                                 bundle: nil];
    MMPDeviceViewController *vc = (MMPDeviceViewController *)[sb instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return vc;
}

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Device Info";
    [self setupViews];
}

- (void) setupViews
{
    for (MMPDeviceDataViewController *controller in self.viewControllers)
    {
        [controller setSelectedDevice: self.selectedDevice];
    }
}


@end
