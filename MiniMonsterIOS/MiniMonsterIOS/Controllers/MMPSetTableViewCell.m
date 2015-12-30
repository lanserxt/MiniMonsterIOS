//
//  MMPSetTableViewCell.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 23.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSetTableViewCell.h"
#import "MMPSet+CoreDataProperties.h"

NSString* const kMMPSetTableViewCellIdentifier = @"MMPSetTableViewCell";
const CGFloat kMMPSetTableViewCellHeight = 70.0f;

@implementation MMPSetTableViewCell

#pragma mark - Methods

- (void) setDataForSet: (MMPSet*) set
{
    [self.setNameLabel setText: set.name];
}

@end
