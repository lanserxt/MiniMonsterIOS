//
//  MMPSetTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 23.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString* const kMMPSetTableViewCellIdentifier;
extern const CGFloat kMMPSetTableViewCellHeight;

@class MMPSet;

@interface MMPSetTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *setNameLabel;

- (void) setDataForSet: (MMPSet*) set;

@end