//
//  MMPControl+CoreDataProperties.h
//  
//
//  Created by Anton Gubarenko on 22.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPControl.h"

typedef NS_ENUM(NSInteger, MMPControlType)
{
    MMPControlTypeSwitch = 0,
    MMPControlTypeSlider,
    MMPControlTypeTemperature,
    MMPControlTypeWatchdog
};

NS_ASSUME_NONNULL_BEGIN

@interface MMPControl (CoreDataProperties)

+ (instancetype) controlWithDeviceId: (NSString*) deviceId
                             andType: (MMPControlType) type;

- (instancetype) controlCopyForSet: (NSString*) setId;

@property (nullable, nonatomic, retain) NSString *controlId;
@property (nullable, nonatomic, retain) NSString *data;
@property (nullable, nonatomic, retain) NSString *deviceId;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSNumber *interval;
@property (nullable, nonatomic, retain) NSNumber *maxValue;
@property (nullable, nonatomic, retain) NSString *request;
@property (nullable, nonatomic, retain) NSString *setId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *portNumber;
@property (nullable, nonatomic, retain) NSNumber *isOutState;

@end

NS_ASSUME_NONNULL_END
