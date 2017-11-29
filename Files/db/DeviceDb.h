//
//  DeviceDb.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Db.h"

@interface DeviceDb : NSObject <Db>

+(BOOL)isDeviceProfileLoaded;
+(BOOL)isDeviceControl;
+(BOOL)isDeviceApnsRegistered;
+(BOOL)isDeviceRegistered;
+(BOOL)isDeviceAdminstrated;
+(NSString *)getDeviceApnsId;
+(NSString *)getDeviceAdminstratedPassword;
+(NSString *)getAppVersion;

+(void)setDeviceProfileLoaded:(BOOL) value;
+(void)setDeviceApnsControl:(BOOL) value;
+(void)setDeviceApnsRegistered:(BOOL) value;
+(void)setDeviceRegistered:(BOOL) value;
+(void)setDeviceAdminstrated:(BOOL) value;
+(void)setDeviceApnsId:(NSString *) value;
+(void)setDeviceAdminstratedPassword:(NSString *) value;
+(void)setAppVersion :(NSString *) value;
@end
