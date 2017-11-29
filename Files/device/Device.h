//
//  Device.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCall.h>
#import <AddressBook/AddressBook.h>

@interface Device : NSObject
{
    @private
    BOOL administrated;
    BOOL registered;
    BOOL apnsRegistered;
    NSString *apnsId;
    BOOL profileLoaded;
    BOOL controlling;
}

@property (nonatomic) BOOL administrated;
@property (nonatomic) BOOL registered;
@property (nonatomic) BOOL apnsRegistered;
@property (nonatomic) NSString *apnsId;
@property (nonatomic) BOOL profileLoaded;
@property (nonatomic) BOOL controlling;

+ (NSString *)getDeviceNumber;
+ (NSString *)getDeviceId;
+ (NSString *)getDeviceType;
+ (NSString *)getDeviceOem;
+ (NSString *)getDeviceMan;
+ (NSString *)getDeviceMod;
+ (NSString *)getDeviceFwV;
+ (NSString *)getDeviceSwV;
+ (NSString *)getDeviceHwV;
+ (NSString *)getDeviceLang;
+ (NSString *)getSwV;
+ (NSString *)getAppVersion;

@end
