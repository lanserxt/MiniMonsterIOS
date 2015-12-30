//
//  MMPControlChooserViewController.h
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 17.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPBaseViewController.h"

@protocol MMPControlSelectionDelegate;

@interface MMPControlChooserViewController : MMPBaseViewController

+ (instancetype) classObject;

@property (nonatomic) NSString *selectedSetId;
@property (nonatomic) NSArray *setControlIDs;
@property (nonatomic, weak) id<MMPControlSelectionDelegate> delegate;

@end