//
//  MMPSwitchesViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 07.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSwitchesViewController.h"
#import "MMPSwitchTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"
#import <SVProgressHUD.h>

@interface MMPSwitchesViewController () <MMPSwitchDelegate>

@property (nonatomic) NSArray *switchesData;

@end

@implementation MMPSwitchesViewController
#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    self.title = @"Ports";
    [self updateControls];
    [self.tabBarController.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
                                                                                              target: self
                                                                                              action: @selector(editAction)] animated: YES];
}

- (void) updateControls
{
    [self loadSliders];
    [self.tableView reloadData];
}

- (void) loadSliders
{
    _switchesData = [MMPControl MR_findAllSortedBy: @"portNumber"
                                          ascending: YES
                                      withPredicate: [NSPredicate predicateWithFormat: @"deviceId == %@ AND type = %@", self.selectedDevice.deviceId, @(MMPControlTypeSwitch)]
                                         inContext: [NSManagedObjectContext MR_defaultContext]];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_switchesData count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier: kMMPSwitchTableViewCellIdentifier
                                                                         forIndexPath: indexPath];
    [switchCell setDataForControl: _switchesData[indexPath.row]];
    [switchCell setDelegate: self];
    [switchCell.portResetButton setTag: indexPath.row];
    return switchCell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPSwitchTableViewCellHeight;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"Port status";
}

#pragma mark - MMPSwitch Delegate

- (void) switchPressedForCell: (MMPDataTableViewCell *) cell
                    withValue: (BOOL) isOn
                      atIndex: (NSInteger) index
{
    [self setSwitchState: isOn
                  onPort: index];
}

- (void) setSwitchState: (BOOL) value
                 onPort: (NSInteger) portNumber
{
    [SVProgressHUD showWithStatus:value ?  @"Turning on..." : @"Turning off..."
                         maskType: SVProgressHUDMaskTypeBlack];
    MMPControl *control = (MMPControl*)_switchesData[portNumber];
    
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?sw=%ld-%@", self.selectedDevice.host, self.selectedDevice.port, self.selectedDevice.password, (long)portNumber, value ? @"1" : @"0"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD showSuccessWithStatus: @"Changed"];
             
             [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
                 
                 MMPControl *localControl = [control MR_inContext: localContext];
                 [localControl setData: value ? @"1" : @"0"];
                 
                 MMPSwitchTableViewCell *switchCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: portNumber
                                                                                                                inSection: 0]];
                 [[switchCell portSwitch] setOn: value
                                       animated: YES];
                 
             } completion:^(BOOL success, NSError *error) {
             }];
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: @"Please try later"];
         }];
}

- (void) resetPressedForCell: (MMPDataTableViewCell *) cell
                      atIndex: (NSInteger) index
{
    [self setResetPort: index];
}

- (void) setResetPort: (NSInteger) portNumber
{
    [SVProgressHUD showWithStatus: @"Resetting port..."
                         maskType: SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?rst=%ld", self.selectedDevice.host, self.selectedDevice.port, self.selectedDevice.password, (long)portNumber];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD showSuccessWithStatus: @"Port is reset"];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: @"Please try later"];
         }];
}

- (void) nameChangedForCell: (MMPDataTableViewCell*) cell
                  withValue: (NSString*) name
                    atIndex: (NSInteger) index
{
    MMPControl *control = (MMPControl*)_switchesData[index];
    [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
        
        MMPControl *localControl = [control MR_inContext: localContext];
        [localControl setName: name];
    } completion:^(BOOL success, NSError *error) {
        [self.tableView reloadData];
    }];
}

#pragma mark - Action

- (void) editAction
{
    [self.tableView setEditing: !self.tableView.isEditing
                      animated: YES];
}

@end
