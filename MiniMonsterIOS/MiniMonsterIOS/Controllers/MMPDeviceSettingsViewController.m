//
//  MMPDeviceSettingsViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 09.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceSettingsViewController.h"
#import "MMPTextFieldTableViewCell.h"
#import "MMPImageTableViewCell.h"
#import "MMPNumberTableViewCell.h"
#import <BDGImagePicker.h>
#import <MMPickerView.h>
#import <UIImage+Resize.h>

typedef NS_ENUM(NSInteger, MMPDeviceSettingsCell)
{
    MMPDeviceSettingsCellHost = 0,
    MMPDeviceSettingsCellPort,
    MMPDeviceSettingsCellPassword,
    MMPDeviceSettingsCellCount
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

@interface MMPDeviceSettingsViewController () <MMPTextFieldDelegate>

@property(nonatomic,strong) BDGImagePicker *imagePicker;

@end

@implementation MMPDeviceSettingsViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardDidShowNotification
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardDidHideNotification
                                               object: nil];
}

- (void)keyboardWillShow: (NSNotification *) notification
{
    NSLog(@"%f", [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height);
    [self.bottomTableConstraint setConstant: [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height - 50.0f];
}

- (void)keyboardWillHide: (NSNotification *) notification
{
    [self.bottomTableConstraint setConstant: 0.0f];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.navigationItem setTitle: @"Settings"];
    [self updateControls];
    [self.tabBarController.navigationItem setRightBarButtonItem: nil];
}

- (void) updateControls
{
    
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return MMPDeviceSettingsSectionCount;
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return section == MMPDeviceSettingsSectionConnection ? MMPDeviceSettingsCellCount : MMPDeviceAddSettingsInfoCellCount;
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case MMPDeviceSettingsCellHost:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Host"];
                [tfCell.textField setPlaceholder: @"http://192.168.0.1"];
                [tfCell.textField setText: self.selectedDevice.host];
                [tfCell setDelegate: self];
                [tfCell.textField setTag: indexPath.row];
                cell = tfCell;
                break;
            }
            case MMPDeviceSettingsCellPort:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Port"];
                [tfCell.textField setPlaceholder: @"80"];
                [tfCell.textField setText: self.selectedDevice.port];
                [tfCell setDelegate: self];
                [tfCell.textField setTag: indexPath.row];
                cell = tfCell;
                break;
            }
            case MMPDeviceSettingsCellPassword:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Password"];
                [tfCell.textField setPlaceholder: @"secret"];
                [tfCell.textField setSecureTextEntry: YES];
                [tfCell.textField setText: self.selectedDevice.password];
                [tfCell setDelegate: self];
                [tfCell.textField setTag: indexPath.row];
                cell = tfCell;
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
            case MMPDeviceAddSettingsInfoCellName:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Name"];
                [tfCell.textField setText: self.selectedDevice.localName];
                [tfCell.textField setFont: [UIFont systemFontOfSize: 12.0f]];
                [tfCell setDelegate: self];
                [tfCell.textField setTag: 4];
                cell = tfCell;
                break;
            }
            case MMPDeviceAddSettingsInfoCellThumb:
            {
                MMPImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier: kMMPImageTableViewCellIdentifier
                                                                                   forIndexPath: indexPath];
                [imageCell.thumbTitle setText: @"Thumb"];
                [imageCell.thumbImageView setImage: [UIImage imageWithData: self.selectedDevice.thumb]];
                cell = imageCell;
                break;
            }
            case MMPDeviceAddSettingsInfoCellUpdate:
            {
                MMPNumberTableViewCell *numCell = [tableView dequeueReusableCellWithIdentifier: kMMPNumberTableViewCellIdentifier
                                                                                  forIndexPath: indexPath];
                [numCell.numberLabel setText: @"Update interval"];
                [numCell.numberValueLabel setText: [NSString stringWithFormat: @"%@ s", self.selectedDevice.updateInterval]];
                cell = numCell;
                break;
            }
        }
        
    }
    return cell;
}
- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.section == MMPDeviceSettingsSectionInfo && indexPath.row == MMPDeviceAddSettingsInfoCellThumb)
    {
        return 70.0f;
    }
    return kMMPTextFieldTableViewCellHeight;
}


- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return section == MMPDeviceSettingsSectionConnection ? @"Connection" : @"Appearance";
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak MMPDeviceDataViewController *weakSelf = self;
    if (indexPath.section == MMPDeviceSettingsSectionInfo && indexPath.row == MMPDeviceAddSettingsInfoCellThumb)
    {
        self.imagePicker = [BDGImagePicker new];
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.title = NSLocalizedString(@"Thumb", @"");
        [self.imagePicker setImagePicked:^(UIImage *image) {
            MMPImageTableViewCell *imageCell = [tableView cellForRowAtIndexPath: indexPath];
            [imageCell.thumbImageView setImage: [image resizedImage: CGSizeMake(150, 150) interpolationQuality: kCGInterpolationDefault]];
            
            NSData *imageData = UIImageJPEGRepresentation(imageCell.thumbImageView.image, kCGInterpolationDefault);
            if (!imageData)
            {
                imageData = UIImagePNGRepresentation(imageCell.thumbImageView.image);
            }
            if (imageData)
            {
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                    localDevice.thumb = imageData;
                }];
            }
        }];
        [self.imagePicker pickImageFromViewController: self];
    }
    if (indexPath.section == MMPDeviceSettingsSectionInfo && indexPath.row == MMPDeviceAddSettingsInfoCellUpdate)
    {
        NSArray *selectableStrings =  @[@"30 s", @"60 s", @"2 min", @"5 min", @"10 min"];
        NSArray *selectableValues =  @[@(30), @(60), @(60 * 2), @(60 * 5), @(60 *10)];
        
        [MMPickerView showPickerViewInView: self.view
                               withStrings: selectableStrings withOptions:nil completion:^(NSString *selectedString) {
                                   MMPNumberTableViewCell *numCell = [tableView cellForRowAtIndexPath: indexPath];
                                   [numCell.numberValueLabel setText: selectedString];
                                   [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                                       MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                                       localDevice.updateInterval = selectableValues[[selectableStrings indexOfObject:selectedString]];
                                   }];
                               }];
    }
}

#pragma mark - TextField Delegate

- (void) textFieldEditingStarted: (UITextField *) textField
                         forCell: (MMPTextFieldTableViewCell *) cell
{
    
}

- (void) textFieldEditingEnded: (UITextField*) textField
                       forCell: (MMPTextFieldTableViewCell*) cell
{
    __weak MMPDeviceDataViewController *weakSelf = self;
    switch(textField.tag)
    {
        case MMPDeviceSettingsCellHost:
        {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                localDevice.host = textField.text;
            }];
            break;
        }
        case MMPDeviceSettingsCellPort:
        {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                localDevice.port = textField.text;
            }];
            break;
        }
        case MMPDeviceSettingsCellPassword:
        {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                localDevice.password = textField.text;
            }];
            break;
        }
        default:
        {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                MMPDevice *localDevice = [weakSelf.selectedDevice MR_inContext: localContext];
                localDevice.localName = textField.text;
            }];
            break;
        }
    }
}

@end
