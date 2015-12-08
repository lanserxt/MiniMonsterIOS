//
//  MMPWatchdogTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDataTableViewCell.h"

extern NSString* const kMMPWatchdogTableViewCellIdentifier;
extern const CGFloat kMMPWatchdogTableViewCellHeight;

@interface MMPWatchdogTableViewCell : MMPDataTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *watchNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *watchResetCountLabel;


@end
