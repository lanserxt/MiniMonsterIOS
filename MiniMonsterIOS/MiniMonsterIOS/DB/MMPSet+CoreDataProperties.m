//
//  MMPSet+CoreDataProperties.m
//  
//
//  Created by Anton Gubarenko on 18.11.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPSet+CoreDataProperties.h"
#import <MagicalRecord.h>

@implementation MMPSet (CoreDataProperties)

@dynamic setId;
@dynamic name;
@dynamic addedDate;

#pragma mark - Init

+ (instancetype) setWithName: (NSString*) name
{
    MMPSet *set = [MMPSet MR_createEntityInContext: [NSManagedObjectContext MR_defaultContext]];
    set.setId = [[NSUUID UUID] UUIDString];
    set.name = name;
    set.addedDate = [NSDate date];
    return set;
}

@end
