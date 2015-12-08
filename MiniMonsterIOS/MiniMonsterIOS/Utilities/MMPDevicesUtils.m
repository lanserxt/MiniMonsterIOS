//
//  MMPDevicesUtils.m
//  MiniMonsterIOS
//
//  Created by Anton Gubarenko on 08.12.15.
//  Copyright © 2015 Anton Gubarenko. All rights reserved.
//

#import "MMPDevicesUtils.h"
#import "MMPDevice+CoreDataProperties.h"
#import "MMPControl+CoreDataProperties.h"
#import <AFNetworking.h>
#import <MagicalRecord.h>
#import "MMPConstants.h"

@interface MMPDevicesUtils ()

@property (nonatomic, assign) NSInteger devicesCount;
@property (nonatomic, assign) BOOL isUpdating;

@end


@implementation MMPDevicesUtils

#pragma mark - Shared Object

+ (MMPDevicesUtils *) sharedUtils{
    
    static MMPDevicesUtils *_sharedUtils = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = [MMPDevicesUtils new];
    });
    return _sharedUtils;
}

#pragma mark - Methods

- (BOOL) isUpdating
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.updating_get_queue", NULL);
    __block BOOL blockFlag = nil;
    dispatch_sync(q, ^{
        blockFlag = self.isUpdating;
    });
    return blockFlag;
}

- (void) setIsUpdating: (BOOL) isUpdating
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.updating_set_queue", NULL);
    dispatch_sync(q, ^{
        self.isUpdating = isUpdating;
    });
}

- (void) updateDevices
{
    self.devicesCount = [MMPDevice MR_countOfEntities];
    
    for (MMPDevice *device in [MMPDevice MR_findAll])
    {
        if (self.delegate && [self.delegate respondsToSelector: @selector(deviceIsUpdating:)])
        {
            [self.delegate deviceIsUpdating: device.deviceId];
        }
        NSString *url = [NSString stringWithFormat: @"%@%@%@/?js=", device.host, device.port, device.password];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
        
        [manager GET: url
          parameters: nil
             success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSError *jsonError;
                 NSDictionary *deviceData = [NSJSONSerialization JSONObjectWithData: responseObject
                                                               options: kNilOptions
                                                                 error: &jsonError];
                 if (!jsonError)
                 {
                     [self updateDevice: device
                               withData: deviceData];
                 }
                 else
                 {
                     NSString *jsonString = [[NSString alloc] initWithData: responseObject
                                                                  encoding: NSUTF8StringEncoding];
                     jsonString = [self replaceLeadingZerosForString: [jsonString copy]];
                     NSError *validateError;
                     deviceData = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding: NSUTF8StringEncoding]
                                                                   options: 0
                                                                     error: &validateError];
                     if (!validateError)
                     {
                         [self updateDevice: device
                                   withData: deviceData];
                     }
                     else
                     {
                         [self setDeviceInactive: device];
                     }
                 }
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self setDeviceInactive: device];
             }];
    }
}

- (void) updateDevice: (MMPDevice*) device
             withData: (NSDictionary*) dict
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MMPDevice *localDevice = [device MR_inContext: localContext];
        localDevice.deviceData = [NSKeyedArchiver archivedDataWithRootObject: dict];
        
        for (NSInteger portIndex = 0; portIndex < [dict[kPorts] count]; portIndex++)
        {
            MMPControl *control = [MMPControl MR_findFirstWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSwitch), @(portIndex)] inContext: localContext];
            control.data = [dict[kPorts][portIndex] stringValue];
        }
        
        for (NSInteger sliderIndex = 0; sliderIndex < 2 ; sliderIndex++)
        {
            MMPControl *control = [MMPControl MR_findFirstWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSlider), @(sliderIndex)] inContext: localContext];
            control.data = [dict[sliderIndex == 0 ? kSlider1 : kSlider2] stringValue];
        }
        
        for (NSInteger tempIndex = 0; tempIndex < [dict[kTemperature] count] ; tempIndex++)
        {
            MMPControl *control = [MMPControl MR_findFirstWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeTemperature), @(tempIndex)] inContext: localContext];
            control.data = ![dict[kTemperature][tempIndex] isKindOfClass: [NSString class]] ? [dict[kTemperature][tempIndex] stringValue] : dict[kTemperature][tempIndex];
        }
        for (NSInteger watchIndex = 0; watchIndex < [dict[kWatchDog] count] ; watchIndex++)
        {
            MMPControl *control = [MMPControl MR_findFirstWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeWatchdog), @(watchIndex)] inContext: localContext];
            control.data = [dict[kWatchDog][watchIndex] stringValue];
        }
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(deviceIsUpdated:)])
        {
            [self.delegate deviceIsUpdated: device.deviceId];
        }
    }];
}

- (void) setDeviceInactive :(MMPDevice*) device
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MMPDevice *localDevice = [device MR_inContext: localContext];
        localDevice.isOnline = @(NO);
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(deviceIsUpdated:)])
        {
            [self.delegate deviceIsUpdated: device.deviceId];
        }
    }];
}

- (NSString*) replaceLeadingZerosForString: (NSString*) jsonString
{
    NSRange range = [jsonString rangeOfString: @"([0]+[1-9]*[.][1-9])[\\S]"
                                      options: NSRegularExpressionSearch];
    if (range.location != NSNotFound)
    {
        range.length = range.length - 1;
        CGFloat floatData = [[jsonString substringWithRange: range] floatValue];
        jsonString = [jsonString stringByReplacingCharactersInRange: range
                                                         withString: [NSString stringWithFormat: @"%f", floatData]];
        return [self replaceLeadingZerosForString: jsonString];
    }
    else
        return jsonString;
}

@end