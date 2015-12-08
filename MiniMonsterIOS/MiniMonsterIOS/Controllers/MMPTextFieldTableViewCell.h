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

@protocol MMPTextFieldDelegate;

@interface MMPTextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) id<MMPTextFieldDelegate> delegate;
@end

@protocol MMPTextFieldDelegate <NSObject>

- (void) textFieldEditingStarted: (UITextField*) textField
                         forCell: (MMPTextFieldTableViewCell*) cell;

@end