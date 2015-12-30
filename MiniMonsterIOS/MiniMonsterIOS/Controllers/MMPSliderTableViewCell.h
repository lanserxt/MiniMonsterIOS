//
//  MMPSliderTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDataTableViewCell.h"
#import "MMPSliderDelegate.h"

extern NSString* const kMMPSliderTableViewCellIdentifier;
extern const CGFloat kMMPSliderTableViewCellHeight;

@interface MMPSliderTableViewCell : MMPDataTableViewCell

@property (nonatomic, weak) IBOutlet UISlider *powerSlider;
@property (nonatomic, weak) IBOutlet UITextField *powerValueField;
@property (nonatomic, weak) IBOutlet UIButton *powerSetButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonWidthConstraint;

@property (nonatomic, weak) id<MMPSliderDelegate> delegate;

- (void) setSavedData: (CGFloat) savedData;

@end


