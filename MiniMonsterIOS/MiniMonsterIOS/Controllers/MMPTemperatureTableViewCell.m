//
//  MMPTemperatureTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPTemperatureTableViewCell.h"

NSString* const kMMPTemperatureTableViewCellIdentifier = @"MMPTemperatureTableViewCell";
const CGFloat kMMPTemperatureTableViewCellHeight = 44.0f;

@implementation MMPTemperatureTableViewCell

#pragma mark - Methods

- (void) setDataForControl: (MMPControl*) control
{
    [self.portNameLabel setText: control.name];
    [self.tempLabel setText: [control.data isEqualToString: kNoData] ? @"-" :[NSString stringWithFormat: @"%@ °C", control.data]];
}

@end
