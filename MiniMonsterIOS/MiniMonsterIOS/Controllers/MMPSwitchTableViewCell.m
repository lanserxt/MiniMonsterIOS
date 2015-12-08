//
//  MMPSwitchTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 07.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSwitchTableViewCell.h"

NSString* const kMMPSwitchTableViewCellIdentifier = @"MMPSwitchTableViewCell";
const CGFloat kMMPSwitchTableViewCellHeight = 70.0f;

@interface MMPSwitchTableViewCell () <UITextFieldDelegate>

@end

@implementation MMPSwitchTableViewCell

#pragma mark - Methods

- (void) setDataForControl: (MMPControl*) control
{
    if ([self.portNameLabel.text isEqualToString: @""])
    {
        [self.portSwitch addTarget: self
                             action: @selector(switchValueChanged:)
                   forControlEvents: UIControlEventValueChanged];
        
        [self.portResetButton addTarget: self
                                action: @selector(resetAction:)
                      forControlEvents: UIControlEventTouchUpInside];
    }
    [self.portNameLabel setText: control.name];
    [self.portNameField setText: control.name];
    [self.portSwitch setOn: [control.data boolValue]
                  animated: YES];
}

#pragma mark - Actions

- (void) switchValueChanged: (UISwitch*) switchControl
{
    if (self.delegate)
    {
        [self.delegate switchPressedForCell: self
                                  withValue: switchControl.isOn
                                    atIndex: self.portResetButton.tag];
    }
}

- (void) resetAction: (UIButton*) button
{
    if (self.delegate)
    {
        [self.delegate resetPressedForCell: self
                                   atIndex: self.portResetButton.tag];
    }
}

#pragma mark - UITextField

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidEndEditing: (UITextField *) textField
{
    self.portNameLabel.text = textField.text;
    if (self.delegate)
    {
        [self.delegate nameChangedForCell: self
                                withValue: textField.text
                                  atIndex: self.portResetButton.tag];
    }
}

- (void) setEditing: (BOOL) editingOn
{
    [self.portNameField setHidden: !editingOn];
    [self.portResetButton setHidden: !editingOn];
    
    [self.portNameLabel setHidden: editingOn];
    [self.portSwitch setHidden: editingOn];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [self setEditing: editing];
}

@end
