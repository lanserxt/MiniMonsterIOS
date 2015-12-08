//
//  MMPSetsViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 18.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSetsViewController.h"
#import "MMPSet+CoreDataProperties.h"
#import <MagicalRecord.h>

@interface MMPSetsViewController ()

@property (nonatomic) NSMutableArray *sets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MMPSetsViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sets = [NSMutableArray arrayWithCapacity: 0];
    self.title = @"Sets";
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self loadSets];
}

- (void) loadSets
{
    _sets = [[MMPSet MR_findAllSortedBy: @"addedDate"
                                    ascending: YES] mutableCopy];
}


@end
