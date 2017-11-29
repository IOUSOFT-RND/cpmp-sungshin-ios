//
//  Json.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Json.h"
#import "JSONKit.h"

@implementation Json

+ (id)encode:(id)aData
{
    NSData *data = [aData JSONData];
    
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[Json]Encode = %@", json);
    
    return data;
}

+ (id)decode:(id)aData
{
//    NSString *ConvertString = [[NSString alloc] initWithData:aData encoding:(0x80000000+kCFStringEncodingEUC_KR)];
//    NSData  *result = [ConvertString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData  *result = [aData dataUsingEncoding:NSUTF8StringEncoding];
    return [result objectFromJSONData];//[decoder mutableObjectWithData:aData];
}


+ (id)decodeHttps:(id)aData
{
    NSString *ConvertString = [[NSString alloc] initWithData:aData encoding:(0x80000000+kCFStringEncodingEUC_KR)];
    NSData  *result = [ConvertString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    return [result objectFromJSONData];//[decoder mutableObjectWithData:aData];
}

@end
