//
//  MMPControlSelectionDelegate.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 16.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPControl;

@protocol MMPControlSelectionDelegate <NSObject>

- (void) controlSelectionDone;

@end
