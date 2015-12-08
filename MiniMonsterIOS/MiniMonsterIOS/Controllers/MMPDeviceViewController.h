//
//  MMPDeviceViewController.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 24.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPDevice;

@interface MMPDeviceViewController : UITabBarController

+ (instancetype) classObject;

@property (nonatomic) MMPDevice *selectedDevice;

@end
