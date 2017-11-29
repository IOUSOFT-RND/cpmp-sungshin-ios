//
//  Alerts.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Alerts.h"
#import "Debug.h"

@implementation Alert
@synthesize mimeType;
@synthesize sourceUri;
@synthesize targetUri;
@synthesize data;

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (mimeType != nil)
        [dic setObject:mimeType forKey:@"MIMEType"];
    
    if (sourceUri != nil)
        [dic setObject:sourceUri forKey:@"SourceURI"];
    
    if (targetUri != nil)
        [dic setObject:targetUri forKey:@"TargetURI"];
    
    if (data != nil)
    {
        [dic setObject:data forKey:@"Data"];
    }
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"MIMEType"] != nil)
        mimeType = [input objectForKey:@"MIMEType"];
    
    if ([input objectForKey:@"SourceURI"] != nil)
        sourceUri = [input objectForKey:@"SourceURI"];
    
    if ([input objectForKey:@"TargetURI"] != nil)
        targetUri = [input objectForKey:@"TargetURI"];
    
    if ([input objectForKey:@"Data"] != nil)
        data = [input objectForKey:@"Data"];
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Alert ["];
    [string appendFormat:@" mimeType=%@", mimeType];
    [string appendFormat:@" sourceUri=%@", sourceUri];
    [string appendFormat:@" targetUri=%@", targetUri];
    [string appendFormat:@" Data=%@", data];
    [string appendString:@"]"];
    
    return string;
}

@end

@implementation Alerts
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
    
    if (alerts != nil)
        [dic setObject:alerts forKey:@"Items"];
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"Items"] != nil)
        alerts = [input objectForKey:@"Items"];
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Alerts ["];
    [string appendFormat:@"%@", alerts];
    [string appendString:@"]"];
    
    return string;
}

@end
