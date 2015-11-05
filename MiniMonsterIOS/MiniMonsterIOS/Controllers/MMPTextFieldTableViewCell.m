//
//  MMPTextFieldTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 03.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPTextFieldTableViewCell.h"

NSString* const kMMPTextFieldTableViewCellIdentifier = @"MMPTextFieldTableViewCell";
const CGFloat kMMPTextFieldTableViewCellHeight = 77.0f;

@implementation MMPTextFieldTableViewCell

#pragma mark - UITextField Delegate

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
