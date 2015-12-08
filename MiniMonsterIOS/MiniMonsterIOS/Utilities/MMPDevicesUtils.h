//
//  MMPDevicesUtils.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 08.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPDeviceDelegate.h"

@interface MMPDevicesUtils : NSObject

@property (nonatomic, weak) id <MMPDeviceDelegate> delegate;

@end
