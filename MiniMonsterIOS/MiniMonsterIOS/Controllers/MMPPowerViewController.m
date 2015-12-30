//
//  MMPPowerViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPPowerViewController.h"
#import "MMPSliderTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"
#import <SVProgressHUD.h>

@interface MMPPowerViewController () <MMPSliderDelegate>

@property (nonatomic) NSArray *slidersData;

@end

@implementation MMPPowerViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.navigationItem setTitle: @"PWM"];
    [self updateControls];
    [self.tabBarController.navigationItem setRightBarButtonItem: nil];
}

- (void) updateControls
{
    [self loadSliders];
    [self.tableView reloadData];
}

- (void) loadSliders
{
    _slidersData = [MMPControl MR_findAllSortedBy: @"name"
                                         ascending: YES
                                     withPredicate: [NSPredicate predicateWithFormat: @"deviceId matches[c] %@ AND type = %@ AND setId == nil", self.selectedDevice.deviceId, @(MMPControlTypeSlider)]];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_slidersData count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPSliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier: kMMPSliderTableViewCellIdentifier
                                                                         forIndexPath: indexPath];
    [sliderCell setDataForControl: _slidersData[indexPath.row]];
    [sliderCell setDelegate: self];
    [sliderCell.powerSetButton setTag: indexPath.row];
    return sliderCell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPSliderTableViewCellHeight;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"PWM management";
}

#pragma mark - MMPSlider Delegate

- (void) savePressedForCell: (MMPDataTableViewCell *) cell
                  withValue: (CGFloat) savedValue
                    atIndex: (NSInteger) index
{
    [self setValue: savedValue
            onPort: index];
}

- (void) setValue: (CGFloat) value
           onPort: (NSInteger) portNumber
{
    [SVProgressHUD showWithStatus: @"Setting pwm..."
                         maskType: SVProgressHUDMaskTypeBlack];
    MMPControl *control = (MMPControl*)_slidersData[portNumber];
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?cpw%ld=%.0f", self.selectedDevice.host, self.selectedDevice.port, self.selectedDevice.password, (long)portNumber + 1, value];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD showSuccessWithStatus: @"Changed"];
             
             [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
                 
                 MMPControl *localControl = [control MR_inContext: localContext];
                 [localControl setData: [NSString stringWithFormat: @"%.0f", value]];
                 
                 MMPSliderTableViewCell *sliderCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: portNumber
                                                                           inSection: 0]];
                 [sliderCell setSavedData: [sliderCell.powerValueField.text floatValue]];
                 
             } completion:^(BOOL success, NSError *error) {
                 [self.tableView reloadData];
                 [[MMPDevicesUtils sharedUtils] updateDevices];
             }];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: @"Please try later"];
         }];
}

@end
