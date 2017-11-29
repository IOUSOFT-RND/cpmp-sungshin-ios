//
//  DevInfo.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DevInfo.h"
#import "Debug.h"

#import "Device.h"
#import "DeviceDb.h"

@implementation DevInfo
@synthesize devNum;
@synthesize devId;
@synthesize devType;
@synthesize swV;
@synthesize regId;


- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.devNum = [Device getDeviceNumber];
    self.devId =  [Device getDeviceId];
    self.devType = [Device getDeviceType];
    self.swV = [Device getSwV];
    self.regId = [DeviceDb getDeviceApnsId];

    return self;
}

- (id)initAuth
{
    self = [super init];
    if (!self)
        return nil;
    
    self.devNum = [Device getDeviceNumber];
    self.devId =  [Device getDeviceId];
    self.devType = [Device getDeviceType];
    self.swV = [Device getSwV];
    
    return self;
}

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (devNum != nil)
        [dic setObject:devNum forKey:@"DevNum"];
    
    if (devId != nil)
        [dic setObject:devId forKey:@"DevID"];
    
    if (devType != nil)
        [dic setObject:devType forKey:@"DevType"];
    
    if (swV != nil)
        [dic setObject:swV forKey:@"SwV"];
    
    if (regId != nil)
        [dic setObject:regId forKey:@"Reg"];
    
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"DevNum"] != nil)
        devNum = [input objectForKey:@"DevNum"];
    
    if ([input objectForKey:@"DevID"] != nil)
        devId = [input objectForKey:@"DevID"];
    
    if ([input objectForKey:@"DevType"] != nil)
        devType = [input objectForKey:@"DevType"];
    
    if ([input objectForKey:@"SwV"] != nil)
        swV = [input objectForKey:@"SwV"];
    
    if ([input objectForKey:@"Reg"] != nil)
        regId = [input objectForKey:@"Reg"];
    

}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"DevInfo ["];
    [string appendFormat:@"devNum=%@", devNum];
    [string appendFormat:@" devId=%@", devId];
    [string appendFormat:@" devType=%@", devType];
    [string appendFormat:@" swV=%@", swV];
    [string appendFormat:@" regId=%@", regId];
    [string appendString:@"]"];
    
    return string;
}

@end
