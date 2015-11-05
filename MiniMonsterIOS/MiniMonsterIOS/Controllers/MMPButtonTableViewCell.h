//
//  MMPButtonTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const kMMPButtonTableViewCellIdentifier;
extern const CGFloat kMMPButtonTableViewCellHeight;
@protocol MMPButtonDelegate;

@interface MMPButtonTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) id<MMPButtonDelegate> delegate;

@end

@protocol MMPButtonDelegate <NSObject>

- (void) buttonPressed: (UIButton*) button
               forCell: (MMPButtonTableViewCell*) cell;

@end
