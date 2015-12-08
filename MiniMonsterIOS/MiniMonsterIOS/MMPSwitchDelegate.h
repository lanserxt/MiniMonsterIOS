//
//  MMPSwitchDelegate.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 07.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPSliderTableViewCell.h"

@protocol MMPSwitchDelegate

- (void) switchPressedForCell: (MMPDataTableViewCell*) cell
                    withValue: (BOOL) isOn
                      atIndex: (NSInteger) index;

- (void) resetPressedForCell: (MMPDataTableViewCell *) cell
                     atIndex: (NSInteger) index;

- (void) nameChangedForCell: (MMPDataTableViewCell*) cell
                    withValue: (NSString*) name
                      atIndex: (NSInteger) index;
@end
