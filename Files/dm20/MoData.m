//
//  MoData.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DevInfo.h"
#import "MoData.h"
#import "Debug.h"

@implementation MoData
@synthesize devInfo;

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
    
    if (devInfo != nil)
        [dic setObject:[devInfo encode] forKey:@"DevInfo"];
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"DevInfo"] != nil)
    {
        devInfo = [[DevInfo alloc] init];
        [devInfo decode:[input objectForKey:@"DevInfo"]];
    }
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"MoData ["];
    [string appendString:[devInfo toString]];
    [string appendString:@"]"];
    
    return string;
}

@end
