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
#import "MMPControl+CoreDataProperties.h"
#import "MMPDevicesUtils.h"

typedef NS_ENUM(NSInteger, MMPDeviceCell)
{
    MMPDeviceCellHost = 0,
    MMPDeviceCellPort,
    MMPDeviceCellPassword,
    MMPDeviceCellValidate,
    MMPDeviceCellCount
};

typedef NS_ENUM(NSInteger, MMPDeviceInfoCell)
{
    MMPDeviceInfoCellId = 0,
    MMPDeviceInfoCellFirmware,
    MMPDeviceInfoCellCount
};

@interface MMPAddDeviceViewController () <UITableViewDataSource, UITableViewDelegate, MMPButtonDelegate, MMPTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isValidatedDevice;
@property (nonatomic) NSDictionary *deviceData;
@end

@implementation MMPAddDeviceViewController

#pragma mark - Class

+ (instancetype) classObject
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: kMainStoryboard
                                                 bundle: nil];
    MMPAddDeviceViewController *vc = (MMPAddDeviceViewController *)[sb instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return vc;
}


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
                [tfCell setDelegate: self];
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
                [tfCell setDelegate: self];
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
                [tfCell setDelegate: self];
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

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.section == 0 && indexPath.row == MMPDeviceCellValidate)
    {
        return kMMPButtonTableViewCellHeight;
    }
    return kMMPTextFieldTableViewCellHeight;
}

#pragma mark - Action

- (void) saveAction
{
    NSDictionary *info = [self deviceDictionary];
    
    MMPDevice *addedDevice = [MMPDevice MR_createEntity];
    addedDevice.deviceId = [[NSUUID UUID] UUIDString];
    addedDevice.host = info[kHost];
    addedDevice.port = info[kPort];
    addedDevice.password = info[kPassword];
    addedDevice.addedDate = [NSDate date];
    addedDevice.deviceData = [NSKeyedArchiver archivedDataWithRootObject: _deviceData];
    addedDevice.updateInterval = @(kDefaultUpdateDeviceInterval);
    addedDevice.isOnline = @(YES);
    addedDevice.latestUpdate = [NSDate date];
    
    for (NSInteger portIndex = 0; portIndex < [_deviceData[kPorts] count]; portIndex++)
    {
        MMPControl *control = [MMPControl controlWithDeviceId: addedDevice.deviceId
                                                      andType: MMPControlTypeSwitch];
        control.data = [_deviceData[kPorts][portIndex] stringValue];
        control.name = [NSString stringWithFormat: @"Port %ld", (long)portIndex];
        control.portNumber = @(portIndex);
        control.isOutState = @([_deviceData[kPortsState][portIndex] boolValue]);
    }
    
    for (NSInteger sliderIndex = 0; sliderIndex < 2 ; sliderIndex++)
    {
        MMPControl *control = [MMPControl controlWithDeviceId: addedDevice.deviceId
                                                      andType: MMPControlTypeSlider];
        control.data = [_deviceData[sliderIndex == 0 ? kSlider1 : kSlider2] stringValue];
        control.maxValue = _deviceData[kSliderMax];
        control.portNumber = @(sliderIndex);
    }
    
    for (NSInteger tempIndex = 0; tempIndex < [_deviceData[kTemperature] count] ; tempIndex++)
    {
        MMPControl *control = [MMPControl controlWithDeviceId: addedDevice.deviceId
                                                      andType: MMPControlTypeTemperature];
        control.data = ![_deviceData[kTemperature][tempIndex] isKindOfClass: [NSString class]] ? [_deviceData[kTemperature][tempIndex] stringValue] : _deviceData[kTemperature][tempIndex];
        control.name = [NSString stringWithFormat: @"Port %ld", (long)tempIndex];
        control.portNumber = @(tempIndex);
    }
    for (NSInteger watchIndex = 0; watchIndex < [_deviceData[kWatchDog] count] ; watchIndex++)
    {
        MMPControl *control = [MMPControl controlWithDeviceId: addedDevice.deviceId
                                                      andType: MMPControlTypeWatchdog];
        control.data = [_deviceData[kWatchDog][watchIndex] stringValue];
        control.name = [NSString stringWithFormat: @"Port %ld", (long)watchIndex];
        control.portNumber = @(watchIndex);
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"Saved %lu controls for device", (unsigned long)[MMPControl MR_countOfEntitiesWithPredicate: [NSPredicate predicateWithFormat: @"deviceId == %@", addedDevice.deviceId]]);
        [[MMPDevicesUtils sharedUtils] startUpdatingLoopForDevice: addedDevice];
        [self.navigationController popViewControllerAnimated: YES];
    }];
}

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
             _deviceData = [NSJSONSerialization JSONObjectWithData: responseObject
                                                           options: kNilOptions
                                                             error: &jsonError];
             if (!jsonError)
             {
                 _isValidatedDevice = YES;
                 [self showSave];
                 [self.tableView reloadData];
             }
             else
             {
                 NSString *jsonString = [[NSString alloc] initWithData: responseObject
                                                              encoding: NSUTF8StringEncoding];
                 jsonString = [self replaceLeadingZerosForString: [jsonString copy]];
                 NSError *validateError;
                 _deviceData = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding: NSUTF8StringEncoding]
                                                               options: 0
                                                                 error: &validateError];
                 if (!validateError)
                 {
                     _isValidatedDevice = YES;
                     [self showSave];
                     [self.tableView reloadData];
                 
                 }
             }
             [SVProgressHUD dismiss];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: [error localizedDescription]];
         }];
    
}

- (NSString*) replaceLeadingZerosForString: (NSString*) jsonString
{
    NSRange range = [jsonString rangeOfString: @"([0]+[1-9]*[.][0-9]+)[\\S]"
                                      options: NSRegularExpressionSearch];
    if (range.location != NSNotFound)
    {
        range.length = range.length - 1;
        CGFloat floatData = [[jsonString substringWithRange: range] floatValue];
        jsonString = [jsonString stringByReplacingCharactersInRange: range
                                                         withString: [NSString stringWithFormat: @"%f", floatData]];
        return [self replaceLeadingZerosForString: jsonString];
    }
    else
        return jsonString;
}

- (NSDictionary*) deviceDictionary
{
    return @{
             kHost : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellHost
                                                                                                             inSection:0]] textField] text],
             kPort : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellPort
                                                                                                             inSection:0]] textField] text],
             kPassword : [[(MMPTextFieldTableViewCell*)[self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: MMPDeviceCellPassword
                                                                                                                 inSection:0]] textField] text]
             };
}

- (void) showSave
{
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave
                                                                                              target: self
                                                                                              action: @selector(saveAction)]];
}

#pragma mark - TextField Delegate

- (void) textFieldEditingStarted: (UITextField *) textField
                         forCell: (MMPTextFieldTableViewCell *) cell
{
    if (_isValidatedDevice)
    {
        [self.navigationItem setRightBarButtonItem: nil];
        _isValidatedDevice = NO;
        [self.tableView reloadData];
    }
}

@end
