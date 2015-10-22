//
//  MMPDevice+CoreDataProperties.h
//  
//
//  Created by Anton Gubarenko on 22.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPDevice.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMPDevice (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deviceId;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *port;
@property (nullable, nonatomic, retain) NSString *localName;

@end

NS_ASSUME_NONNULL_END
