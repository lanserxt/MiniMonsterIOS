//
//  MMPNumberTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 09.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kMMPNumberTableViewCellIdentifier;

@interface MMPNumberTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *numberValueLabel;

@end