//
//  MMPTemperatureTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDataTableViewCell.h"

extern NSString* const kMMPTemperatureTableViewCellIdentifier;
extern const CGFloat kMMPTemperatureTableViewCellHeight;

@interface MMPTemperatureTableViewCell : MMPDataTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *portNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *tempLabel;

@end
