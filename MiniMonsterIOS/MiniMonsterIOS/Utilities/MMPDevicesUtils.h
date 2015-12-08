//
//  MMPDevicesUtils.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 08.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPDeviceDelegate.h"

@class MMPDevice;

@interface MMPDevicesUtils : NSObject

@property (nonatomic, weak) id <MMPDeviceDelegate> delegate;

+ (MMPDevicesUtils *) sharedUtils;

- (BOOL) isUpdating;
- (BOOL) isUpdatingDevice: (NSString*) deviceId;
- (void) updateDevices;
- (void) startUpdatingLoopForDevice: (MMPDevice*) device;

@end
