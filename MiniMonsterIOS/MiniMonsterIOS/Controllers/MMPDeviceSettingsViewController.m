//
//  MMPDeviceSettingsViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 09.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceSettingsViewController.h"

typedef NS_ENUM(NSInteger, MMPDeviceSettingsCell)
{
    MMPDeviceSettingsCellHost = 0,
    MMPDeviceSettingsCellPort,
    MMPDeviceSettingsCellPassword,
    MMPDeviceCellCount
};

typedef NS_ENUM(NSInteger, MMPDeviceAddSettingsInfoCell)
{
    MMPDeviceAddSettingsInfoCellName = 0,
    MMPDeviceAddSettingsInfoCellThumb,
    MMPDeviceAddSettingsInfoCellUpdate,
    MMPDeviceAddSettingsInfoCellCount
};

typedef NS_ENUM(NSInteger, MMPDeviceSettingsSection)
{
    MMPDeviceSettingsSectionConnection = 0,
    MMPDeviceSettingsSectionInfo,
    MMPDeviceSettingsSectionCount
};

@implementation MMPDeviceSettingsViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    self.title = @"Settings";
    [self updateControls];
    [self.tabBarController.navigationItem setRightBarButtonItem: nil];
}

- (void) updateControls
{
    
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return section == MMPDeviceSettingsSectionConnection ? MMPDeviceSettingsSectionCount : MMPDeviceAddSettingsInfoCellCount;
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    //MMPTemperatureTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: kMMPTemperatureTableViewCellIdentifier
    //                                                                        forIndexPath: indexPath];
    //[tempCell setDataForControl: _tempPorts[indexPath.row]];
    return nil;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return section == MMPDeviceSettingsSectionConnection ? @"Connection" : @"Appearance";
}
@end
