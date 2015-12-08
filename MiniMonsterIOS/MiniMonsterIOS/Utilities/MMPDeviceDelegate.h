//
//  MMPDeviceDelegate.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 08.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMPDeviceDelegate <NSObject>

@optional
- (void) deviceIsUpdating: (NSString*) deviceId;
- (void) deviceIsUpdated: (NSString*) deviceId;

@end