//
//  Cred.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Cred.h"
#import "Debug.h"

@implementation Cred
@synthesize type;
@synthesize salt;
@synthesize data;

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (type != nil)
        [dic setObject:type forKey:@"Type"];
    
    if (salt != nil)
        [dic setObject:salt forKey:@"Salt"];
    
    if (data != nil)
        [dic setObject:data forKey:@"Data"];
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"Type"] != nil)
        type = [input objectForKey:@"Type"];
    
    if ([input objectForKey:@"Salt"] != nil)
        salt = [input objectForKey:@"Salt"];
    
    if ([input objectForKey:@"Data"] != nil)
        data = [input objectForKey:@"Data"];
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Cred ["];
    [string appendFormat:@"Type=%@", type];
    [string appendFormat:@" Salt=%@", salt];
    [string appendFormat:@" Data=%@", data];
    [string appendString:@"]"];
    
    return string;
}

@end
