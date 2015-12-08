//
//  MMPButtonTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPButtonTableViewCell.h"

NSString* const kMMPButtonTableViewCellIdentifier = @"MMPButtonTableViewCell";
const CGFloat kMMPButtonTableViewCellHeight = 80.0f;

@implementation MMPButtonTableViewCell

#pragma mark - Actions

- (IBAction)buttonAction: (id) sender
{
    if (self.delegate && [self.delegate respondsToSelector: @selector(buttonPressed:forCell:)])
    {
        [self.delegate buttonPressed: sender
                             forCell: self];
    }
}

@end
