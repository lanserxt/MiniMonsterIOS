//
//  MMPObjectFactory.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 20.10.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPObjectFactory.h"

@implementation MMPObjectFactory

#pragma mark - Init

static MMPObjectFactory *_sharedFactory = nil;

+ (MMPObjectFactory *) sharedFactory
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedFactory = [self new];
    });
    
    return _sharedFactory;
}

@end
