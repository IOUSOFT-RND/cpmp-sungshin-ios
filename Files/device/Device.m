//
//  Device.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Device.h"
#import "StringEnumDef.h"
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>
#include <sys/types.h>

#define SIMULATOR false

@implementation Device
@synthesize administrated;
@synthesize registered;
@synthesize apnsRegistered;
@synthesize apnsId;
@synthesize profileLoaded;
@synthesize controlling;


+ (NSString *)getDeviceNumber
{
    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
   
   
    if(number == nil)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:USER_PHONENUMBER] == nil)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_PHONENUMBER];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    number = [[NSUserDefaults standardUserDefaults] objectForKey:USER_PHONENUMBER];
    NSLog(@"number is =%@", number);
    
    if (SIMULATOR)
    {
        number = @"";
        //number = @"01085050633";
    }

    return number;
}

+ (NSString *)getDeviceId
{
//    NSString *Devic = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSMutableString *no = [[NSMutableString alloc] init];
    [no appendString:@"IMEI:"];
    [no appendString:[self getDeviceNumber]];
//    NSArray *split = [Devic componentsSeparatedByString:@"-"];
//    if ([split count] == 1)
//    {
//        NSLog(@"split count < 1");
//        [no appendString:Devic];
//    }
//    else if([split count] > 1)
//    {
//        int splitCount = (int)[split count];
//        
//        for (int i = 0; i < splitCount; i++)
//        {
//            [no appendString:[split objectAtIndex:i]];
//        }
//    }
    return no;
}

+ (NSString *)getDeviceType
{
    NSString *type = [[UIDevice currentDevice] model];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
       type = @"tablet";
   else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
       type = @"iphone";
    
    NSLog(@"%@", type);
    
    return type;
}

+ (NSString *)getDeviceOem
{
    NSString *oem = @"Apple";
    
    NSLog(@"%@", oem);
    
    return oem;
}

+ (NSString *)getDeviceMan
{
    NSString *man = @"Apple";
    
    NSLog(@"%@", man);
    
    return man;
}

+ (NSString *)getDeviceMod
{
    NSString *mod = [[UIDevice currentDevice]localizedModel];;
    NSLog(@"%@", mod);
    
    return mod;
}

+ (NSString *)getDeviceFwV
{
    NSString *fwv = [[UIDevice currentDevice] systemVersion];
    
    NSLog(@"%@", fwv);
    
    return fwv;
}

+ (NSString *)getDeviceSwV
{
    NSString *swv = [[UIDevice currentDevice] systemVersion];
    
    NSLog(@"%@", swv);
    
    return swv;
}

+ (NSString *)getDeviceHwV
{
    size_t size;
    char *buf;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    buf = malloc(size);
    sysctlbyname("hw.machine", buf, &size, NULL, 0);
    
    NSString *value = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
    

    if([value isEqualToString:@""])
        NSLog(@"is null");
    NSLog(@"%@", value);
    free(buf);
    
    return value;
    
}

+ (NSString *)getDeviceLang
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* lang = [languages objectAtIndex:0];
    
    NSLog(@"%@", lang);
    
    return lang;
}


+(NSString *)getSwV
{
    //app Version
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    //bulid version
    //NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSLog(@"app software version = %@",appVersion);
    
    return appVersion;
}

+(NSString *)getAppVersion
{
    NSDictionary *appPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appPlist objectForKey:@"app_version"];
    NSLog(@"app software version = %@",appVersion);
    
    return appVersion;
}

@end
