//
//  MMPObjectFactory.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 20.10.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMPBaseViewController.h"

@interface MMPObjectFactory : NSObject

+ (MMPObjectFactory *) sharedFactory;

+ (MMPBaseViewController*) infoVC;

@end
