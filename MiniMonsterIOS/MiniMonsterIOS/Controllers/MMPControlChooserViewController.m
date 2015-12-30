//
//  MMPControlChooserViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 17.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPControlChooserViewController.h"
#import <MagicalRecord.h>
#import "MMPDevice+CoreDataProperties.h"
#import "MMPConstants.h"
#import "MMPControl+CoreDataProperties.h"

typedef NS_ENUM(NSInteger, MMPPickerSection)
{
    MMPPickerSectionDevice = 0,
    MMPPickerSectionControls,
    MMPPickerSectionCount
};


@interface MMPControlChooserViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) NSArray *devices;
@property (nonatomic) NSMutableDictionary *controls;
@property (nonatomic, assign) NSInteger selectedDeviceIndex;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@end

@implementation MMPControlChooserViewController

#pragma mark - Class

+ (instancetype) classObject
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: kMainStoryboard
                                                 bundle: nil];
    MMPControlChooserViewController *vc = (MMPControlChooserViewController *)[sb instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return vc;
}

#pragma mark - View Lyfecycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    
    [self loadData];
    [self.navigationItem setRightBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                              target: self
                                                                                              action: @selector(addControlAction)]];
}

- (void) loadData
{
    _devices = [MMPDevice MR_findAllSortedBy: @"addedDate"
                                   ascending: YES];
    _controls = [NSMutableDictionary dictionaryWithCapacity: 0];
    
    if ([_devices count])
    {
        self.selectedDeviceIndex = 0;
        for (NSInteger deviceIndex = 0; deviceIndex < [_devices count]; deviceIndex++)
        {
            _controls[@(deviceIndex)] = [MMPControl MR_findAllSortedBy: @"name"
                                                             ascending: YES
                                                         withPredicate: [NSPredicate predicateWithFormat: @"deviceId matches[c] %@ AND setId == nil AND NOT (controlId IN %@)", [(MMPDevice*)_devices[deviceIndex] deviceId], _setControlIDs]];
        }
    }
}

#pragma mark - PickerView DataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView *) pickerView
{
    return MMPPickerSectionCount;
}

- (NSInteger) pickerView: (UIPickerView *) pickerView
 numberOfRowsInComponent: (NSInteger) component
{
    return component == MMPPickerSectionDevice ? [_devices count] : [_controls[@(self.selectedDeviceIndex)] count];
}

- (NSString *)pickerView: (UIPickerView *) pickerView
             titleForRow: (NSInteger) row
            forComponent: (NSInteger) component
{
    
    return @"";
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize: 12.0f];
        pickerLabel.textAlignment= NSTextAlignmentCenter;
    }
    switch (component)
    {
        case MMPPickerSectionDevice:
        {
            pickerLabel.text = [_devices[row] host];
            break;
        }
            
        case MMPPickerSectionControls:
            pickerLabel.text = [NSString stringWithFormat: @"%@ %@",[self nameForType: [[(MMPControl*)_controls[@(_selectedDeviceIndex)][row] type] integerValue]], [_controls[@(_selectedDeviceIndex)][row] name]];
            break;
    }
    
    return pickerLabel;
}

- (NSString*) nameForType: (MMPControlType) type
{
    switch (type)
    {
        case MMPControlTypeSlider:
            return @"Slider";
        case MMPControlTypeSwitch:
            return @"Switch";
        case MMPControlTypeWatchdog:
            return @"W-Dog";
        case MMPControlTypeTemperature:
            return @"Temp";
        default:
            break;
    }
    return @"";
}

#pragma mark - PickerView Delegate

-(void)pickerView: (UIPickerView *) pickerView
     didSelectRow: (NSInteger) row
      inComponent: (NSInteger) component
{
    if (component == MMPPickerSectionDevice)
    {
        self.selectedDeviceIndex = row;
        [self.pickerView reloadComponent: MMPPickerSectionControls];
    }
}

#pragma mark - Actions

- (void) addControlAction
{
    NSInteger selectedControlIndex = [self.pickerView selectedRowInComponent: MMPPickerSectionControls];
    if (selectedControlIndex > -1)
    {
        [(MMPControl*)_controls[@(_selectedDeviceIndex)][selectedControlIndex] controlCopyForSet: self.selectedSetId];
        [self.navigationController popViewControllerAnimated: YES];
    }
}

@end