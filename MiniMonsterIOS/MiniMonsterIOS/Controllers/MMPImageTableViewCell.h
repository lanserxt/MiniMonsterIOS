//
//  MMPImageTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 09.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kMMPImageTableViewCellIdentifier;

@interface MMPImageTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;
@property (nonatomic, weak) IBOutlet UILabel *thumbTitle;

@end