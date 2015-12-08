//
//  MMPTextFieldTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 03.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPTextFieldTableViewCell.h"

NSString* const kMMPTextFieldTableViewCellIdentifier = @"MMPTextFieldTableViewCell";
const CGFloat kMMPTextFieldTableViewCellHeight = 44.0f;

@implementation MMPTextFieldTableViewCell

#pragma mark - UITextField Delegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
    
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
