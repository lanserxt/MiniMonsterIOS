//
//  MMPWatchdogViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPWatchdogViewController.h"
#import "MMPWatchdogTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"

@interface MMPWatchdogViewController ()
@property (nonatomic) NSArray *watchDogs;
@end

@implementation MMPWatchdogViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];    
    [self.tabBarController.navigationItem setTitle: @"W-Dog"];
    [self.tabBarController.navigationItem setRightBarButtonItem: nil];
    [self updateControls];
}

- (void) updateControls
{
    [self loadWatchDogs];
    [self.tableView reloadData];
}

- (void) loadWatchDogs
{
    _watchDogs = [MMPControl MR_findAllSortedBy: @"name"
                                       ascending: YES
                                   withPredicate: [NSPredicate predicateWithFormat: @"deviceId matches[c] %@ AND type = %@ AND setId == nil", self.selectedDevice.deviceId, @(MMPControlTypeWatchdog)]];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_watchDogs count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPWatchdogTableViewCell *watchCell = [tableView dequeueReusableCellWithIdentifier: kMMPWatchdogTableViewCellIdentifier
                                                                         forIndexPath: indexPath];
    [watchCell setDataForControl: _watchDogs[indexPath.row]];
    return watchCell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPWatchdogTableViewCellHeight;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"Reset count for W-dog";
}

@end