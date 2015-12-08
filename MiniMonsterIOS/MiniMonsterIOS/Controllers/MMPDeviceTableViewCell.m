//
//  MMPDeviceTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 06.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceTableViewCell.h"
#import "MMPDevice+CoreDataProperties.h"

NSString* const kMMPDeviceTableViewCellIdentifier = @"MMPDeviceTableViewCell";
const CGFloat kMMPDeviceTableViewCellHeight = 150.0f;

@implementation MMPDeviceTableViewCell

- (void)awakeFromNib
{
    [self.statusCircle.layer setCornerRadius: CGRectGetWidth(self.statusCircle.bounds) / 2.0];    
}

#pragma mark - Methods

- (void) setDataForDevice: (MMPDevice*) device
{
    [self.firmLabel setText: [device firmware]];
}

@end