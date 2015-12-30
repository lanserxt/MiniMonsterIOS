//
//  MMPAddSetViewController.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 11.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPBaseViewController.h"
@class MMPSet;

@interface MMPAddSetViewController : MMPBaseViewController

+ (instancetype) classObject;

@property (nonatomic) MMPSet *selectedSet;

@end
