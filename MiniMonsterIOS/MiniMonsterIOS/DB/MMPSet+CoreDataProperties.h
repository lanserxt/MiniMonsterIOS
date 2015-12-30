//
//  MMPSet+CoreDataProperties.h
//  
//
//  Created by Anton Gubarenko on 18.11.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPSet.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPSet (CoreDataProperties)

+ (instancetype) setWithName: (NSString*) name;

@property (nullable, nonatomic, retain) NSString *setId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *addedDate;

@end

NS_ASSUME_NONNULL_END
