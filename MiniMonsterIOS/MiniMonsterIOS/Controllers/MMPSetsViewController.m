//
//  MMPSetsViewController.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 18.11.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPSetsViewController.h"
#import <MagicalRecord.h>
#import "MMPSet+CoreDataProperties.h"
#import "MMPSetTableViewCell.h"
#import "MMPControl+CoreDataProperties.h"
#import "MMPAddSetViewController.h"


@interface MMPSetsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noDevicesLabel;
@property (nonatomic) NSMutableArray *sets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MMPSetsViewController

#pragma mark - View Lyfe Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _sets = [NSMutableArray arrayWithCapacity: 0];
}

- (void) viewWillAppear: (BOOL) animated
{
    [super viewWillAppear: animated];
    [self.tabBarController.navigationItem setTitle: @"Sets"];
    [self loadSets];
    
    self.tabBarController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target:self action:@selector(editAction:)];
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    [self.tableView reloadData];
}

- (void) loadSets
{
    _sets = [[MMPSet MR_findAllSortedBy: @"addedDate"
                              ascending: YES] mutableCopy];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
}

#pragma mark - TableView Data Source

- (NSInteger) tableView: (UITableView *) tableView
  numberOfRowsInSection: (NSInteger) section
{
    [_noDevicesLabel setHidden: _sets.count > 0 ? YES : NO];
    [_tableView setHidden: _sets.count > 0 ? NO : YES];
    return [_sets count];
}

- (UITableViewCell*) tableView: (UITableView *) tableView
         cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPSetTableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier: kMMPSetTableViewCellIdentifier
                                                                      forIndexPath: indexPath];
    [deviceCell setDataForSet: _sets[indexPath.row]];
    return deviceCell;
}

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    MMPAddSetViewController *setVC = [MMPAddSetViewController classObject];
    [setVC setSelectedSet: _sets[indexPath.row]];
    [self.tabBarController.navigationController pushViewController: setVC
                                                          animated: YES];
    
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    return kMMPSetTableViewCellHeight;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString*) tableView: (UITableView *) tableView
titleForHeaderInSection: (NSInteger) section
{
    return @"Swipe to delete";
}

- (void) tableView: (UITableView *) tableView
commitEditingStyle: (UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        MMPSet *deletedSet = _sets[indexPath.row];
        
        NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"setId == %@", deletedSet.setId]];
        for (MMPControl *control in controls)
        {
            [control MR_deleteEntity];
        }
        [deletedSet MR_deleteEntity];
        [_sets removeObjectAtIndex: indexPath.row];
        [self.tableView deleteRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: indexPath.row
                                                                     inSection: indexPath.section]]
                              withRowAnimation: UITableViewRowAnimationFade];
        
    }
}

#pragma mark - Actions

- (IBAction) editAction: (id) sender
{
    [self.tableView setEditing: YES
                      animated: YES];
    [self.tabBarController.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                                                                              target: self
                                                                                                              action: @selector(doneAction)]];
}

- (void) doneAction
{
    [self.tableView setEditing: NO
                      animated: YES];
    [self.tabBarController.navigationItem setLeftBarButtonItem: [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit
                                                                                                              target: self
                                                                                                              action: @selector(editAction:)]];
}

- (void) addAction
{
    [self.tabBarController.navigationController pushViewController: [MMPAddSetViewController classObject]
                                                          animated: YES];
}
@end