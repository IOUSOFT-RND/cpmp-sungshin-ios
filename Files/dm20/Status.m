//
//  Status.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Alerts.h"
#import "Status.h"
#import "Debug.h"

@implementation Status
@synthesize cred;
@synthesize moData;
@synthesize alerts;
@synthesize results;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    return self;
}

- (id)encode
{
    if (results != nil)
    {
        return results;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (cred != nil)
        [dic setObject:cred forKey:@"CRED"];
    
    if (moData != nil)
        [dic setObject:moData forKey:@"MOData"];
    
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
    
    if ([input isKindOfClass:[NSArray class]] == YES)
    {
        results = input;
    }
    else
    {
        if ([input objectForKey:@"CRED"] != nil)
            cred = [input objectForKey:@"CRED"];
        
        if ([input objectForKey:@"MOData"] != nil)
            moData = [input objectForKey:@"MOData"];
        
        if ([input objectForKey:@"Alert"] != nil)
        {
            alerts = [[Alerts alloc] init];
            [alerts decode:[input objectForKey:@"Alert"]];
        }
    }
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Status ["];
    [string appendFormat:@"cred=%@", cred];
    [string appendFormat:@" moData=%@", moData];
    [string appendFormat:@" %@", [alerts toString]];
    [string appendFormat:@" results=%@", results];
    [string appendString:@"]"];
    
    return string;
}

@end
