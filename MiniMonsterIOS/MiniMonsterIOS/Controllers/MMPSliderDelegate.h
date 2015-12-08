//
//  MMPSliderDelegate.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 07.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPSliderTableViewCell.h"

@protocol MMPSliderDelegate

- (void) savePressedForCell: (MMPDataTableViewCell*) cell
                  withValue: (CGFloat) savedValue
                    atIndex: (NSInteger) index;

@end
