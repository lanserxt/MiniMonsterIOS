//
//  MMPDeviceTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 06.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kMMPDeviceTableViewCellIdentifier;
extern const CGFloat kMMPDeviceTableViewCellHeight;

@class MMPDevice;

@interface MMPDeviceTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *statusCircle;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UILabel *firmLabel;

- (void) setDataForDevice: (MMPDevice*) device;

@end
