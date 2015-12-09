//
//  MMPInfoViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 20.10.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPInfoViewController.h"

@interface MMPInfoViewController ()

@end

@implementation MMPInfoViewController

#pragma mark - View Lyfe Cycle


- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    self.title = @"About";
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

@end
