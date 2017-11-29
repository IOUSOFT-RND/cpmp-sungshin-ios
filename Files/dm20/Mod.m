//
//  Mod.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Cred.h"
#import "MoData.h"
#import "Alerts.h"
#import "Mod.h"
#import "Debug.h"

@implementation Mod
@synthesize cred;
@synthesize moData;
@synthesize alerts;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    return self;
}

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (cred != nil)
        [dic setObject:[cred encode] forKey:@"CRED"];
    
    if (moData != nil)
        [dic setObject:[moData encode] forKey:@"MOData"];
    
    if (alerts != nil)
        [dic setObject:[alerts encode] forKey:@"Alert"];
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"CRED"] != nil)
    {
        cred = [[Cred alloc] init];
        [cred decode:[input objectForKey:@"CRED"]];
    }
    
    if ([input objectForKey:@"MOData"] != nil)
    {
        moData = [[MoData alloc] init];
        [moData decode:[input objectForKey:@"MOData"]];
    }
    
    if ([input objectForKey:@"Alert"] != nil)
    {
        alerts = [[Alerts alloc] init];
        [alerts decode:[input objectForKey:@"Alert"]];
    }
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Mod ["];
    [string appendFormat:@" %@", [cred toString]];
    [string appendFormat:@" %@", [moData toString]];
    [string appendFormat:@" %@", [alerts toString]];
    [string appendString:@"]"];
    
    return string;
}

@end
