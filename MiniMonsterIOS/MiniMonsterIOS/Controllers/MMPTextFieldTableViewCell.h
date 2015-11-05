//
//  MMPTextFieldTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 03.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kMMPTextFieldTableViewCellIdentifier;
extern const CGFloat kMMPTextFieldTableViewCellHeight;

@interface MMPTextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end
