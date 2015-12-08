//
//  MMPMainTabViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 18.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPMainTabViewController.h"
#import "MMPSet+CoreDataProperties.h"
#import <MagicalRecord.h>

@interface MMPMainTabViewController ()

@end

@implementation MMPMainTabViewController

#pragma mark - View Lyfecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self loadAvailableTab];
}

- (void) loadAvailableTab
{
    if ([MMPSet MR_countOfEntities] == 0)
    {
        [self setSelectedIndex: 1];
    }
}

@end
