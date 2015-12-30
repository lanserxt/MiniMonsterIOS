//
//  MMPAddSetControlViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 11.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPAddSetControlViewController.h"
#import "MMPSet+CoreDataProperties.h"
#import <MagicalRecord.h>
#import "MMPTextFieldTableViewCell.h"
#import "MMPConstants.h"
#import <SVProgressHUD.h>
#import "MMPControl+CoreDataProperties.h"
#import "MMPDevicesUtils.h"

typedef NS_ENUM(NSInteger, MMSetCell)
{
    MMSetCellName = 0,
    MMSetCellCount
};


@interface MMPAddSetControlViewController () <UIPickerViewDataSource, UIPickerViewDataSource, MMPTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL isValidatedDevice;
@property (nonatomic) NSString *setName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomTableConstraint;
@end

@implementation MMPAddSetControlViewController

#pragma mark - Class

+ (instancetype) classObject
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName: kMainStoryboard
                                                 bundle: nil];
    MMPAddSetControlViewController *vc = (MMPAddSetControlViewController *)[sb instantiateViewControllerWithIdentifier: NSStringFromClass([self class])];
    return vc;
}

#pragma mark - View Lyfecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Set";
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

#pragma mark - TableView Data Source

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
    return MMSetCellCount;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    switch (section)
    {
        case 0:
            return @"Name";
            
    }
    return @"";
}

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    return section == 0 ? 1 : 0;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case MMSetCellName:
            {
                MMPTextFieldTableViewCell *tfCell = [tableView dequeueReusableCellWithIdentifier: kMMPTextFieldTableViewCellIdentifier
                                                                                    forIndexPath: indexPath];
                [tfCell.titleLabel setText: @"Name"];
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
        /*switch (indexPath.row)
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
        }*/
        
    }
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPTextFieldTableViewCellHeight;
}

#pragma mark - MMPTextfield Delegate

- (void) textFieldEditingEnded: (UITextField*) textField
                       forCell: (MMPTextFieldTableViewCell*) cell
{
    _setName = textField.text;
}

@end