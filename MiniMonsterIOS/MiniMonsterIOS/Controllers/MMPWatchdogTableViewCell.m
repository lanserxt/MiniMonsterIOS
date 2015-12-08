//
//  MMPWatchdogTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPWatchdogTableViewCell.h"

NSString* const kMMPWatchdogTableViewCellIdentifier = @"MMPWatchdogTableViewCell";
const CGFloat kMMPWatchdogTableViewCellHeight = 44.0f;

@implementation MMPWatchdogTableViewCell

#pragma mark - Methods

- (void) setDataForControl: (MMPControl*) control
{
    [self.watchNameLabel setText: control.name];
    [self.watchResetCountLabel setText: control.data];
}

@end
