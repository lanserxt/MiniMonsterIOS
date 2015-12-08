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
#import "MMPDeviceTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"
#import "MMPAddDeviceViewController.h"
#import "MMPDeviceViewController.h"

@interface MMPDevicesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noDevicesLabel;
@property (nonatomic) NSMutableArray *devices;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MMPDevicesViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _devices = [NSMutableArray arrayWithCapacity: 0];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    self.title = @"Devices";
    [self loadDevices];
    
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
}

- (void) loadDevices
{
    _devices = [[MMPDevice MR_findAllSortedBy: @"addedDate"
                                    ascending: YES] mutableCopy];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    [_noDevicesLabel setHidden: _devices.count > 0 ? YES : NO];
    [_tableView setHidden: _devices.count > 0 ? NO : YES];
    return [_devices count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPDeviceTableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier: kMMPDeviceTableViewCellIdentifier
                                                                        forIndexPath: indexPath];
    [deviceCell setDataForDevice: _devices[indexPath.row]];
    return deviceCell;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPDeviceViewController *deviceVC = [MMPDeviceViewController classObject];
    [deviceVC setSelectedDevice: _devices[indexPath.row]];
    [self.tabBarController.navigationController pushViewController: deviceVC
                                                          animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPDeviceTableViewCellHeight;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"Swipe to delete";
}

- (void) tableView: (UITableView *) tableView
commitEditingStyle: (UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MMPDevice *deletedDevice = _devices[indexPath.row];
        
        NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"deviceId == %@", deletedDevice.deviceId]];
        for (MMPControl *control in controls)
        {
            [control MR_deleteEntity];
        }
        [deletedDevice MR_deleteEntity];
        [_devices removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row
                                                                    inSection: indexPath.section]]
                              withRowAnimation: UITableViewRowAnimationFade];
        
        
    }
}

#pragma mark - Actions

- (IBAction) editAction: (id) sender
{
    [self.tableView setEditing: YES
                      animated: YES];
    [self.tabBarController.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                              target: self
                                                                                              action: @selector(doneAction)]];
}

- (void) doneAction
{
    [self.tableView setEditing: NO
                      animated: YES];
    [self.tabBarController.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
                                                                                              target: self
                                                                                              action: @selector(editAction:)]];
}

- (void) addAction
{
    [self.tabBarController.navigationController pushViewController: [MMPAddDeviceViewController classObject]
                                                          animated: YES];
}

@end
