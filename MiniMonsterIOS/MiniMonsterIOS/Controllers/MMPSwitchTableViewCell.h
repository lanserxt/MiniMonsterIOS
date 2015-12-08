//
//  MMPSwitchTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 07.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDataTableViewCell.h"
#import "MMPSwitchDelegate.h"

extern NSString* const kMMPSwitchTableViewCellIdentifier;
extern const CGFloat kMMPSwitchTableViewCellHeight;

@interface MMPSwitchTableViewCell : MMPDataTableViewCell

@property (nonatomic, weak) IBOutlet UISwitch *portSwitch;
@property (nonatomic, weak) IBOutlet UITextField *portNameField;
@property (nonatomic, weak) IBOutlet UIButton *portResetButton;
@property (nonatomic, weak) IBOutlet UILabel *portNameLabel;

@property (nonatomic, weak) id<MMPSwitchDelegate> delegate;
@end

