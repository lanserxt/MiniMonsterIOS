//
//  MMPDeviceTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 06.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDeviceTableViewCell.h"
#import "MMPDevice+CoreDataProperties.h"
#import "MMPDevicesUtils.h"

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
    
    if ([[MMPDevicesUtils sharedUtils] isUpdatingDevice: device.deviceId])
    {
        [self.statusCircle setBackgroundColor: [UIColor blueColor]];
        [self.statusLabel setText: @"Updating..."];
    }
    else
    {
        [self.statusCircle setBackgroundColor: [device.isOnline boolValue] ? [UIColor greenColor] : [UIColor redColor]];
        [self.statusLabel setText: [device.isOnline boolValue] ? @"Online" : @"Offline"];
    }
}

@end