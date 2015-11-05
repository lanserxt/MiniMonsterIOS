//
//  MMPAddDeviceViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 03.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPAddDeviceViewController.h"
#import "MMPDevice+CoreDataProperties.h"
#import <MagicalRecord.h>
#import "MMPTextFieldTableViewCell.h"
#import <AFNetworking.h>
#import "MMPButtonTableViewCell.h"
#import "MMPConstants.h"
#import <SVProgressHUD.h>

typedef NS_ENUM(NSInteger, MMPDeviceCell)
{
    MMPDeviceCellHost = 0,
    MMPDeviceCellPort,
    MMPDeviceCellPassword,
    MMPDeviceCellName,
    MMPDeviceCellValidate,
    MMPDeviceCellCount
};

typedef NS_ENUM(NSInteger, MMPDeviceInfoCell)
{
    MMPDeviceInfoCellId = 0,
    MMPDeviceInfoCellFirmware,
    MMPDeviceInfoCellCount
};

@interface MMPAddDeviceViewController () <UITableViewDataSource, UITableViewDelegate, MMPButtonDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isValidatedDevice;
@property (nonatomic) NSDictionary *deviceData;
@end

@implementation MMPAddDeviceViewController

#pragma mark - View Lyfecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Device";
}

#pragma mark - TableView Data Source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return !_isValidatedDevice ? 1 : 2;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    switch (section)
    {
        case 0:
            return @"Connection";
            
        case 1:
            return @"Info";
            
    }
    return @"";
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return section == 0 ? MMPDeviceCellCount : MMPDeviceInfoCellCount;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case MMPDeviceCellHost:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Host"];
                [tfCell.textField setPlaceholder: @"http://192.168.0.1"];
                [tfCell.textField setText: @"http://fasterpast.ru"];
                cell = tfCell;
                break;
            }
            case MMPDeviceCellPort:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Port"];
                [tfCell.textField setPlaceholder: @"80"];
                [tfCell.textField setText: @"9898"];
                cell = tfCell;
                break;
            }
            case MMPDeviceCellPassword:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Password"];
                [tfCell.textField setPlaceholder: @"secret"];
                [tfCell.textField setSecureTextEntry: YES];
                [tfCell.textField setText: @"password"];
                cell = tfCell;
                break;
            }
            case MMPDeviceCellName:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Device name"];
                [tfCell.textField setPlaceholder: @"Living room Monster"];
                [tfCell.textField setText: @"Demo device"];
                cell = tfCell;
                break;
            }
            case MMPDeviceCellValidate:
            {
                MMPButtonTableViewCell *btCell = [tableView dequeueReusableCellWithIdentifier: kMMPButtonTableViewCellIdentifier
                                                                                 forIndexPath: indexPath];
                [btCell.button setTitle: @"Validate"
                               forState: UIControlStateNormal];
                [btCell setDelegate: self];
                cell = btCell;
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (indexPath.row)
        {
            case MMPDeviceInfoCellId:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                 forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"ID"];
                [tfCell.textField setText: _deviceData[kId]];
                [tfCell.textField setUserInteractionEnabled: NO];
                [tfCell.textField setFont: [UIFont systemFontOfSize: 12.0f]];
                cell = tfCell;
                break;
            }
            case MMPDeviceInfoCellFirmware:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                 forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Firmware"];
                [tfCell.textField setText: _deviceData[kFirmware]];
                [tfCell.textField setUserInteractionEnabled: NO];
                [tfCell.textField setFont: [UIFont systemFontOfSize: 12.0f]];
                cell = tfCell;
                break;
            }
        }
        
    }
    return cell;
}

#pragma mark - Action


#pragma mark - Button Delegate

- (void) buttonPressed: (UIButton *) button
               forCell: (MMPButtonTableViewCell *) cell
{
    [self validateHost];
}

- (void) validateHost
{
    NSDictionary *info = [self deviceDictionary];
    NSString *port = [info[kPort] length] > 0 ? [@":" stringByAppendingString: info[kPort]] : @"";
    NSString *password = [info[kPassword] length] > 0 ? [@"/" stringByAppendingString: info[kPassword]] : @"";
    [SVProgressHUD showWithStatus: @"Validating"
                         maskType: SVProgressHUDMaskTypeBlack];
    
    NSString *url = [NSString stringWithFormat: @"%@%@%@/?js=", info[kHost], port, password];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET: url
      parameters: nil
         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             NSError *jsonError;
             _deviceData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options: NSJSONReadingMutableContainers
                                                                    error: &jsonError];
             if (!jsonError)
             {
                 _isValidatedDevice = YES;
                 [self showSave];
                 [self.tableView reloadData];
             }
             [SVProgressHUD dismiss];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: [error localizedDescription]];
         }];
    
    
}

- (NSDictionary*) deviceDictionary
{
    return @{
             kHost : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellHost
                                                                                                             inSection:0]] textField] text],
             kPort : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellPort
                                                                                                             inSection:0]] textField] text],
             kPassword : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellPassword
                                                                                                                 inSection:0]] textField] text],
             kName : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellName
                                                                                                             inSection:0]] textField] text]
             };
}

- (void) showSave
{
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave
                                                                                              target: self
                                                                                              action: nil]];
}

@end
