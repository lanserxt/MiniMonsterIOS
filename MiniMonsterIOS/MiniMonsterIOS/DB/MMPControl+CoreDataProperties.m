//
//  MMPControl+CoreDataProperties.m
//  
//
//  Created by Anton Gubarenko on 22.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPControl+CoreDataProperties.h"
#import <MagicalRecord.h>

@implementation MMPControl (CoreDataProperties)

@dynamic controlId;
@dynamic data;
@dynamic deviceId;
@dynamic type;
@dynamic interval;
@dynamic maxValue;
@dynamic request;
@dynamic setId;
@dynamic name;
@dynamic portNumber;
@dynamic isOutState;

#pragma mark - Init

+ (instancetype) controlWithDeviceId: (NSString*) deviceId
                             andType: (MMPControlType) type
{
    MMPControl *control = [MMPControl MR_createEntityInContext: [NSManagedObjectContext MR_defaultContext]];
    control.controlId = [[NSUUID UUID] UUIDString];
    control.deviceId = [deviceId copy];
    control.type = @(type);
    return control;
}

@end
