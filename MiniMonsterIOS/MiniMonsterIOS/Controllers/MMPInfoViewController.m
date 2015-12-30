//
//  MMPInfoViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 20.10.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPInfoViewController.h"
#import "MMPConstants.h"

@interface MMPInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation MMPInfoViewController

#pragma mark - View Lyfe Cycle

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.navigationItem setTitle: @"About"];
    
    self.tabBarController.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    self.versionLabel.text = [NSString stringWithFormat: @"%@ v%1.1f", [[[NSBundle mainBundle] infoDictionary]  objectForKey:(id)kCFBundleNameKey], [[[[NSBundle mainBundle] infoDictionary]  objectForKey:(id)kCFBundleVersionKey] floatValue]];
}

#pragma mark - Actions

- (IBAction)homePageAction:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kHomePage]];
}

- (IBAction)purchaseAction:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: kShopPage]];
}

@end
