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
@property (nullable, nonatomic, retain) NSString *host;
@property (nullable, nonatomic, retain) NSString *port;
@property (nullable, nonatomic, retain) NSString *localName;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSDate *addedDate;
@property (nullable, nonatomic, retain) NSData *thumb;
@property (nullable, nonatomic, retain) NSData *deviceData;
@property (nullable, nonatomic, retain) NSNumber *updateInterval;
@property (nullable, nonatomic, retain) NSNumber *isOnline;
@property (nullable, nonatomic, retain) NSDate *latestUpdate;

- (nullable NSString*) deviceName;
- (nullable NSString*) firmware;

@end

NS_ASSUME_NONNULL_END
