//
//  MMPAddSetViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 11.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPAddSetViewController.h"
#import "MMPSet+CoreDataProperties.h"
#import <MagicalRecord.h>
#import "MMPTextFieldTableViewCell.h"
#import "MMPConstants.h"
#import <SVProgressHUD.h>
#import "MMPControl+CoreDataProperties.h"
#import "MMPDevicesUtils.h"
#import "MMPControlChooserViewController.h"
#import "MMPWatchdogTableViewCell.h"
#import "MMPTemperatureTableViewCell.h"
#import "MMPSliderTableViewCell.h"
#import "MMPSwitchTableViewCell.h"
#import <UIAlertView+Blocks.h>
#import <AFNetworking.h>
#import "MMPDevicesUtils.h"
#import "MMPDevice+CoreDataProperties.h"

typedef NS_ENUM(NSInteger, MMSetSection)
{
    MMSetSectionName = 0,
    MMSetSectionControls,
    MMSetSectionCount
};

static NSString * const kNewSetUdid = @"newUdid";

@interface MMPAddSetViewController () <MMPTextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MMPSliderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSString *setName;
@property (nonatomic) NSArray *linkedControls;
@end

@implementation MMPAddSetViewController

#pragma mark - Class

+ (instancetype) classObject
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: kMainStoryboard
                                                 bundle: nil];
    MMPAddSetViewController *vc = (MMPAddSetViewController *)[sb instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return vc;
}

#pragma mark - View Lyfecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _selectedSet ? @"Edit Set" :  @"Add Set";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemSave target:self action:@selector(saveAction)];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self updateControls];
}

- (void) updateControls
{
    _setName = _selectedSet ? _selectedSet.name : @"";
    _linkedControls = [MMPControl MR_findAllSortedBy: @"name"
                                           ascending: YES
                                       withPredicate: [NSPredicate predicateWithFormat: @"setId matches[c] %@", _selectedSet ? _selectedSet.setId : kNewSetUdid]];
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return MMSetSectionCount;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    switch (section)
    {
        case MMSetSectionName:
            return @"Info";
        case MMSetSectionControls:
            return @"Controls";
    }
    return @"";
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return section == MMSetSectionName ? 1 : 1 + [_linkedControls count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == MMSetSectionName)
    {
        switch (indexPath.row)
        {
            case MMSetSectionName:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Name"];
                [tfCell.textField setText: _setName];
                [tfCell.textField setPlaceholder: @"Set name"];
                [tfCell setDelegate: self];
                cell = tfCell;
                break;
            }
            default:
                break;
        }
    }
    else
    {
        if (indexPath.row == [_linkedControls count])
        {
            MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                forIndexPath: indexPath];
            [tfCell.titleLabel setText: @"Tap to add"];
            [tfCell.textField setPlaceholder: @""];
            [tfCell.textField setEnabled: NO];
            [tfCell setDelegate: self];
            cell = tfCell;
        }
        else
        {
            MMPControl *control = _linkedControls[indexPath.row];
            switch ([[control type] integerValue])
            {
                case MMPControlTypeSlider:
                {
                    MMPSliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier: kMMPSliderTableViewCellIdentifier
                                                                                         forIndexPath: indexPath];
                    [sliderCell setDataForControl: control];
                    [sliderCell setDelegate: self];
                    [sliderCell.powerSetButton setTag: indexPath.row];
                    cell = sliderCell;
                    break;
                }
                    
                case MMPControlTypeSwitch:
                {
                    MMPSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier: kMMPSwitchTableViewCellIdentifier
                                                                                         forIndexPath: indexPath];
                    [switchCell setDataForControl: control];
                    [switchCell setDelegate: self];
                    [switchCell.portResetButton setTag: indexPath.row];
                    cell = switchCell;
                    break;
                }
                    
                case MMPControlTypeTemperature:
                {
                    MMPTemperatureTableViewCell *tempCell = [tableView dequeueReusableCellWithIdentifier: kMMPTemperatureTableViewCellIdentifier
                                                                                            forIndexPath: indexPath];
                    [tempCell setDataForControl: control];
                    cell = tempCell;
                    break;
                }
                    
                case MMPControlTypeWatchdog:
                {
                    MMPWatchdogTableViewCell *watchCell = [tableView dequeueReusableCellWithIdentifier: kMMPWatchdogTableViewCellIdentifier
                                                                                          forIndexPath: indexPath];
                    [watchCell setDataForControl: control];
                    cell = watchCell;
                    break;
                }
            }
        }
        
    }
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.section == MMSetSectionControls)
    {
        if (indexPath.section == MMSetSectionControls && indexPath.row == [_linkedControls count])
        {
            
            return kMMPTextFieldTableViewCellHeight;
        }
        else
        {
            MMPControl *control = _linkedControls[indexPath.row];
            switch ([[control type] integerValue])
            {
                case MMPControlTypeSlider:
                {
                    return kMMPSliderTableViewCellHeight;
                }
                    
                case MMPControlTypeSwitch:
                {
                    return kMMPSwitchTableViewCellHeight;
                }
                    
                case MMPControlTypeTemperature:
                {
                    return kMMPTemperatureTableViewCellHeight;
                }
                    
                case MMPControlTypeWatchdog:
                {
                    return kMMPWatchdogTableViewCellHeight;
                }
            }
        }
    }
    return kMMPTextFieldTableViewCellHeight;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.section == MMSetSectionControls && indexPath.row == [self tableView: self.tableView
                                                                numberOfRowsInSection: MMSetSectionControls] -1)
    {
        
        MMPControlChooserViewController *chooserVC = [MMPControlChooserViewController classObject];
        [chooserVC setSelectedSetId: _selectedSet ? _selectedSet.setId : kNewSetUdid];
        [chooserVC setSetControlIDs: [_linkedControls valueForKey: @"controlId"]];
        
        [self.navigationController pushViewController: chooserVC
                                             animated: YES];
    }
    else
    {
        
        if (indexPath.section == MMSetSectionControls)
        {
            MMPControl *control = _linkedControls[indexPath.row];
            switch ([[control type] integerValue])
            {
                case MMPControlTypeSlider:
                {
                    break;
                }
                    
                case MMPControlTypeSwitch:
                {
                    break;
                }
                    
                case MMPControlTypeTemperature:
                {
                    if ([control.data isEqualToString: kNoData])
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
                                                  [self promptForTempOnPort: [control.portNumber integerValue]
                                                            withDefaultData: control.data
                                                                  andDevice: [MMPDevice MR_findFirstByAttribute: @"deviceId"
                                                                                                      withValue: control.deviceId]];
                                              }
                                          }];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void) promptForTempOnPort: (NSInteger) portNumber
             withDefaultData: (NSString*) placeholder
                   andDevice: (MMPDevice*) device
{
    UIAlertView *alertView = [UIAlertView showWithTitle:@"Temperture" message:@"Please enter temp" style:UIAlertViewStylePlainTextInput cancelButtonTitle: @"Cancel" otherButtonTitles: @[@"OK"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (alertView.cancelButtonIndex != buttonIndex)
        {
            if ([self isNumeric: [[alertView textFieldAtIndex:0] text]])
            {
                [self setTemp: [[alertView textFieldAtIndex:0] text]
                       onPort: portNumber
                    andDevice: device];
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
    [[alertView textFieldAtIndex:0] setText: [NSString stringWithFormat: @"%@",placeholder]];
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
andDevice: (MMPDevice*) device
{
    [SVProgressHUD showWithStatus: @"Setting temp..."
                         maskType: SVProgressHUDMaskTypeBlack];
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?t%ld=+%2.1f", device.host, device.port, device.password, (long)portNumber+1, [temp floatValue]];
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


#pragma mark - MMPTextfield Delegate

- (void) textFieldEditingEnded: (UITextField*) textField
                       forCell: (MMPTextFieldTableViewCell*) cell
{
    _setName = textField.text;
}

#pragma mark - Actions

- (void) saveAction
{
    if (_selectedSet)
    {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            MMPSet *localSet = [_selectedSet MR_inContext: [NSManagedObjectContext MR_defaultContext]];
            if (_setName && _setName.length > 0)
            {
                [localSet setName: _setName];
            }
            
            for (MMPControl *control in _linkedControls)
            {
                MMPControl *localControl = [control MR_inContext: [NSManagedObjectContext MR_defaultContext]];
                [localControl setSetId: _selectedSet.setId];
            }
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                [self.navigationController popViewControllerAnimated: YES];
            }];
        }];
    }
    else
    {
        if (_setName && _setName.length > 0)
        {
            MMPSet *set = [MMPSet setWithName: _setName];
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                
                for (MMPControl *control in _linkedControls)
                {
                    MMPControl *localControl = [control MR_inContext: [NSManagedObjectContext MR_defaultContext]];
                    [localControl setSetId: set.setId];
                }
                
            } completion:^(BOOL contextDidSave, NSError *error) {
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
                    NSLog(@"Saved %lu set", (unsigned long)[MMPSet MR_countOfEntities]);
                    [self.navigationController popViewControllerAnimated: YES];
                }];
            }];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle: @"Error"
                                        message: @"Set name can't be empty"
                                       delegate: nil
                              cancelButtonTitle: @"OK"
                              otherButtonTitles: nil] show];
        }
    }
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
    MMPControl *control = _linkedControls[portNumber];
    MMPDevice *device = [MMPDevice MR_findFirstByAttribute: @"deviceId"
                                                 withValue: control.deviceId];
    
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?cpw%ld=%.0f", device.host, device.port, device.password, (long)control.portNumber + 1, value];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             [SVProgressHUD showSuccessWithStatus: @"Changed"];
             
             NSArray *sliders = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"controlId matches[c] %@", control.controlId]];
             
             [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
                 
                 for (MMPControl *cntrl in sliders)
                 {
                     MMPControl *localControl = [cntrl MR_inContext: localContext];
                     [localControl setData: [NSString stringWithFormat: @"%.0f", value]];
                 };
                 
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
    MMPControl *control = _linkedControls[portNumber];
    MMPDevice *device = [MMPDevice MR_findFirstByAttribute: @"deviceId"
                                                 withValue: control.deviceId];
    
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?sw=%ld-%@", device.host, device.port, device.password, (long)portNumber + 1, value ? @"1" : @"0"];
    NSLog(@"Switching %@", url);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [SVProgressHUD showSuccessWithStatus: @"Changed"];
             
             NSArray *switches = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"controlId matches[c] %@", control.controlId]];
             [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
                 
                 for (MMPControl *swtControls in switches)
                 {
                     MMPControl *localControl = [swtControls MR_inContext: localContext];
                     [localControl setData: value ? @"1" : @"0"];
                 }
                 
                 MMPSwitchTableViewCell *switchCell = [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: portNumber
                                                                                                                inSection: 0]];
                 [[switchCell portSwitch] setOn: value
                                       animated: YES];
                 
             } completion:^(BOOL success, NSError *error) {
                 [[MMPDevicesUtils sharedUtils] updateDevices];
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
    MMPControl *control = _linkedControls[portNumber];
    MMPDevice *device = [MMPDevice MR_findFirstByAttribute: @"deviceId"
                                                 withValue: control.deviceId];
    
    NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?rst=%ld", device.host, device.port, device.password, (long)portNumber +1];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    [manager GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [SVProgressHUD showSuccessWithStatus: @"Port is reset"];
             [[MMPDevicesUtils sharedUtils] updateDevices];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             [SVProgressHUD showErrorWithStatus: @"Please try later"];
         }];
}

- (void) nameChangedForCell: (MMPDataTableViewCell*) cell
                  withValue: (NSString*) name
                    atIndex: (NSInteger) index
{
    MMPControl *control = _linkedControls[index];
    NSArray *switches = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"controlId matches[c] %@", control.controlId]];
    
    [MagicalRecord saveWithBlock: ^(NSManagedObjectContext *localContext) {
        
        for (MMPControl *swtControls in switches)
        {
            MMPControl *localControl = [swtControls MR_inContext: localContext];
            [localControl setName: name];
        }
    } completion:^(BOOL success, NSError *error) {
        [self.tableView reloadData];
    }];
}

@end