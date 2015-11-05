//
//  MMPDevicesViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 20.10.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDevicesViewController.h"
#import <MagicalRecord.h>
#import "MMPDevice+CoreDataProperties.h"

@interface MMPDevicesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noDevicesLabel;
@property (nonatomic) NSMutableArray *devices;
@end

@implementation MMPDevicesViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _devices = [NSMutableArray arrayWithCapacity: 0];
    self.title = @"Devices";
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self loadDevices];
}

- (void) loadDevices
{
    _devices = [[MMPDevice MR_findAllSortedBy: @"added"
                                    ascending: YES] mutableCopy];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    [_noDevicesLabel setHidden: _devices.count > 0 ? YES : NO];
    return [_devices count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return nil;
}

#pragma mark - Actions


@end
