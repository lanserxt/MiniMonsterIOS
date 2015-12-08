//
//  MMPDevice+CoreDataProperties.m
//  
//
//  Created by Anton Gubarenko on 22.10.15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MMPDevice+CoreDataProperties.h"
#import "MMPConstants.h"

@implementation MMPDevice (CoreDataProperties)

@dynamic deviceId;
@dynamic host;
@dynamic port;
@dynamic localName;
@dynamic password;
@dynamic addedDate;
@dynamic thumb;
@dynamic deviceData;
@dynamic updateInterval;
@dynamic isOnline;
@dynamic latestUpdate;

#pragma mark - Methods

- (nullable NSString*) deviceName
{
    NSDictionary *dataDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData: self.deviceData];
    return dataDictionary[kId];
}

- (nullable NSString*) firmware
{
    NSDictionary *dataDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData: self.deviceData];
    return dataDictionary[kFirmware];
    
}

@end
