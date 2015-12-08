//
//  MMPDataTableViewCell.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 05.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPControl.h"
#import "MMPConstants.h"

@interface MMPDataTableViewCell : UITableViewCell

- (void) setDataForControl: (MMPControl*) control;

@end
