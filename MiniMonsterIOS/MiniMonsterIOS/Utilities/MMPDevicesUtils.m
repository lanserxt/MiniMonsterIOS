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

@property (nonatomic, assign) NSInteger innerDevicesCount;
@property (nonatomic, assign) BOOL innerIsUpdating;
@property (nonatomic) NSMutableArray *devicesIdList;

@end


@implementation MMPDevicesUtils

#pragma mark - Shared Object

+ (MMPDevicesUtils *) sharedUtils
{
    static MMPDevicesUtils *_sharedUtils = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtils = [MMPDevicesUtils new];
        _sharedUtils.devicesIdList = [NSMutableArray arrayWithCapacity: 0];
    });
    return _sharedUtils;
}

#pragma mark - Methods

- (BOOL) isUpdating
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.updating_get_queue", NULL);
    __block BOOL blockFlag = nil;
    dispatch_sync(q, ^{
        blockFlag = self.innerIsUpdating;
    });
    return blockFlag;
}

- (BOOL) isUpdatingDevice: (NSString*) deviceId
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.updating_device_get_queue", NULL);
    __block BOOL blockFlag = nil;
    dispatch_sync(q, ^{
        blockFlag = [self.devicesIdList containsObject: deviceId];
    });
    return blockFlag;
}

- (void) setIsUpdating: (BOOL) isUpdating
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.updating_set_queue", NULL);
    dispatch_sync(q, ^{
        self.innerIsUpdating = isUpdating;
    });
}

- (NSInteger) devicesCount
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.devices_count_get_queue", NULL);
    __block NSInteger blockFlag = 0;
    dispatch_sync(q, ^{
        blockFlag = self.innerDevicesCount;
    });
    return blockFlag;
}

- (void) setDevicesCount: (NSInteger) devicesCount
{
    dispatch_queue_t q = dispatch_queue_create("com.mmp.devices_count_set_queue", NULL);
    dispatch_sync(q, ^{
        self.innerDevicesCount = devicesCount;
    });
}


- (void) updateDevices
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSInteger count = [MMPDevice MR_countOfEntities];
        if (count > 0)
        {
            [self setDevicesCount: count];
            [self setIsUpdating: YES];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
            [self.devicesIdList removeAllObjects];
            
            for (MMPDevice *device in [MMPDevice MR_findAll])
            {
                [self refreshDevice: device];
            }
        }
    });
}

- (void) refreshDevice: (MMPDevice*) device
{
    if (![self isUpdatingDevice: device.deviceId] && device.deviceId)
    {
        [self.devicesIdList addObject: device.deviceId];
    }
    else
    {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer: [AFHTTPResponseSerializer serializer]];
    if (self.delegate && [self.delegate respondsToSelector: @selector(deviceIsUpdating:)])
    {
        [self.delegate deviceIsUpdating: device.deviceId];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *url = [NSString stringWithFormat: @"%@:%@/%@/?js=", device.host, device.port, device.password];
        
        NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod: @"GET"
                                                                          URLString: url
                                                                         parameters: nil
                                                                              error: nil];
        [request setTimeoutInterval: kDefaultTimeout];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.devicesIdList removeObject: device.deviceId];
            [self decDevicesCount];
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
            [self startUpdatingLoopForDevice: device];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.devicesIdList removeObject: device.deviceId];
            [self decDevicesCount];
            [self setDeviceInactive: device];
            [self startUpdatingLoopForDevice: device];
        }];
        [manager.operationQueue addOperation:operation];
    });
}

- (void) startUpdatingLoopForDevice: (MMPDevice*) device
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, [device.updateInterval integerValue] * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self refreshDevice: device];
    });
}

- (void) decDevicesCount
{
    [self setDevicesCount: [self devicesCount] -1];
    if ([self devicesCount] == 0)
    {
        [self setIsUpdating: NO];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    }
}

- (void) updateDevice: (MMPDevice*) device
             withData: (NSDictionary*) dict
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        MMPDevice *localDevice = [device MR_inContext: localContext];
        localDevice.deviceData = [NSKeyedArchiver archivedDataWithRootObject: dict];
        localDevice.isOnline = @(YES);
        localDevice.latestUpdate = [NSDate date];
        
        for (NSInteger portIndex = 0; portIndex < [dict[kPorts] count]; portIndex++)
        {
            NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSwitch), @(portIndex)] inContext: localContext];
            for (MMPControl *control  in controls)
            {                
                control.data = [dict[kPorts][portIndex] stringValue];
            }
        }
        
        for (NSInteger sliderIndex = 0; sliderIndex < 2 ; sliderIndex++)
        {
            NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSwitch), @(sliderIndex)] inContext: localContext];
            for (MMPControl *control  in controls)
            {
                control.data = [dict[sliderIndex == 0 ? kSlider1 : kSlider2] stringValue];
            }
        }
        
        for (NSInteger tempIndex = 0; tempIndex < [dict[kTemperature] count] ; tempIndex++)
        {
            NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSwitch), @(tempIndex)] inContext: localContext];
            for (MMPControl *control  in controls)
            {
                control.data = ![dict[kTemperature][tempIndex] isKindOfClass: [NSString class]] ? [dict[kTemperature][tempIndex] stringValue] : dict[kTemperature][tempIndex];
            }
        }
        for (NSInteger watchIndex = 0; watchIndex < [dict[kWatchDog] count] ; watchIndex++)
        {
            NSArray *controls = [MMPControl MR_findAllWithPredicate: [NSPredicate predicateWithFormat: @"deviceId = %@ AND type = %@ AND portNumber == %@", device.deviceId, @(MMPControlTypeSwitch), @(watchIndex)] inContext: localContext];
            for (MMPControl *control  in controls)
            {
                control.data = [dict[kWatchDog][watchIndex] stringValue];
            }
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
        localDevice.latestUpdate = [NSDate date];
    } completion:^(BOOL contextDidSave, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector: @selector(deviceIsUpdated:)])
        {
            [self.delegate deviceIsUpdated: device.deviceId];
        }
    }];
}

- (NSString*) replaceLeadingZerosForString: (NSString*) jsonString
{
    NSRange range = [jsonString rangeOfString: @"[0]+[1-9]*[.][0-9]+"
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