//
//  MMPTemperatureViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPTemperatureViewController.h"
#import "MMPTemperatureTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"
#import <SVProgressHUD.h>


@interface MMPTemperatureViewController ()

@property (nonatomic) NSArray *tempPorts;

@end

@implementation MMPTemperatureViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.navigationItem setTitle: @"t°C"];
    [self updateControls];
    [self.tabBarController.navigationItem setRightBarButtonItem: nil];
}

- (void) updateControls
{
    [self loadTemp];
    [self.tableView reloadData];
}

- (void) loadTemp
{
    _tempPorts = [MMPControl MR_findAllSortedBy: @"name"
                                       ascending: YES
                                   withPredicate: [NSPredicate predicateWithFormat: @"deviceId matches[c] %@ AND type = %@ AND setId == nil", self.selectedDevice.deviceId, @(MMPControlTypeTemperature)]];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return [_tempPorts count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPTemperatureTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: kMMPTemperatureTableViewCellIdentifier
                                                                            forIndexPath: indexPath];
    [tempCell setDataForControl: _tempPorts[indexPath.row]];
    return tempCell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPTemperatureTableViewCellHeight;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"Tap to change temperature";
}

- (NSString*) tableView: (UITableView *) tableView
titleForFooterInSection:(NSInteger)section
{
    return @"Temp set will work only if thermostat is enabled in web interface";
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPControl *tempControl = _tempPorts[indexPath.row];
    
    if ([tempControl.data isEqualToString: kNoData])
    {
        [UIAlertView showWithTitle: @"Error"
                           message: @"Sorry, no temperture sensor on this port"
                 cancelButtonTitle: @"OK"
                 otherButtonTitles: nil
                          tapBlock: nil];
    }
    else
    {
        [UIAlertView showWithTitle: nil
                           message: @"Do you really want to change temp on this port?"
                 cancelButtonTitle: @"No"
                 otherButtonTitles: @[@"Yes"]
                          tapBlock: ^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                              if (alertView.cancelButtonIndex != buttonIndex)
                              {
                                  [self promptForTempOnPort: indexPath.row];
                              }
                          }];
    }
}

- (void) promptForTempOnPort: (NSInteger) portNumber
{
    UIAlertView *alertView = [UIAlertView showWithTitle:@"Temperture" message:@"Please enter temp" style:UIAlertViewStylePlainTextInput cancelButtonTitle: @"Cancel" otherButtonTitles: @[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (alertView.cancelButtonIndex != buttonIndex)
        {
            if ([self isNumeric: [[alertView textFieldAtIndex:0] text]])
            {
                [self setTemp: [[alertView textFieldAtIndex:0] text]
                       onPort: portNumber];
            }
            else
            {
                [UIAlertView showWithTitle: @"Error"
                                   message: @"Sorry, can't detect the temperture value"
                         cancelButtonTitle: @"OK"
                         otherButtonTitles: nil
                                  tapBlock: nil];
            }
            
        }
    }];
    [[alertView textFieldAtIndex:0] setText: [NSString stringWithFormat: @"%@",[_tempPorts[portNumber] data]]];
}

- (BOOL) isNumeric:(NSString*) checkText
{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [numberFormatter setNumberStyle: NSNumberFormatterScientificStyle];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil)
    {
        return YES;
    }
    return NO;
}

- (void) setTemp: (NSString*) temp
          onPort: (NSInteger) portNumber
{
    [SVProgressHUD showWithStatus: @"Setting temp..."
                         maskType: SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?t%ld=+%2.1f", self.selectedDevice.host, self.selectedDevice.port, self.selectedDevice.password, (long)portNumber+1, [temp floatValue]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD showSuccessWithStatus: @"Changed"];
             [[MMPDevicesUtils sharedUtils] updateDevices];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: @"Please try later"];
         }];
}


@end
