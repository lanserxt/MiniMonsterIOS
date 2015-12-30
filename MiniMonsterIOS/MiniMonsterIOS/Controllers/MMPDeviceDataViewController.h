//
//  MMPDeviceDataViewController.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 24.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPDevice+CoreDataProperties.h"
#import <MagicalRecord.h>
#import <UIAlertView+Blocks.h>
#import <AFNetworking.h>
#import "MMPDevicesUtils.h"

@interface MMPDeviceDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) MMPDevice *selectedDevice;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

- (void) updateControls;

@end
