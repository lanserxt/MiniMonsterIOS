//
//  MMPControl+CoreDataProperties.h
//  
//
//  Created by Anton Gubarenko on 21.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPControl.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPControl (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *controlId;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *data;
@property (nullable, nonatomic, retain) UNKNOWN_TYPEdeviceId;

@end

NS_ASSUME_NONNULL_END
