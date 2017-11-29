//
//  LogHelper.m
//  SmartLauncherSharedCode
//
//  Created by kwangsik.shin on 2014. 9. 30..
//  Copyright (c) 2014년 Arewith. All rights reserved.
//

#import "LogHelper.h"
#import "Common.h"
#import "UserData.h"
#import "ServiceInfo.h"
#import "Device.h"
#import "Json.h"
#import "Http.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

@implementation LogHelper

+(NSMutableDictionary*)defaultDic {

    UserData * ud = [UserData sharedUserData];
    NSMutableDictionary * defaultDic = [NSMutableDictionary dictionary];
    [defaultDic setObject:ud.USER_ID    forKey:@"user_id"];
    if (ud.USER_TYPE) {
        [defaultDic setObject:ud.USER_TYPE  forKey:@"user_type"];
    }
    [defaultDic setObject:DEVICE        forKey:@"device"];
    return defaultDic;
}

+(void)loggingForMenuRun:(ServiceInfo *)service
{
    if (service == nil)
        return;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSString *userID =[[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] base64EncodedString];
    NSMutableDictionary *DATA = [[NSMutableDictionary alloc] init];
    
    [dic setObject: userID forKey:@"USERID"];
    [dic setObject: [Device getDeviceHwV] forKey:@"DEVICE"];
    [dic setObject:@"iOS"forKey:@"OS"];
    [dic setObject:@"0"forKey:@"TAG"];
    
    if (service.Id)        [dic setObject:service.Id forKey:@"ID"];
    if (service.type)      [dic setObject:[service.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"TYPE"];
    if (service.name)      [dic setObject:[service.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"NAME"];
    
    
    [DATA setObject:dic forKey:@"DATA"];
    Http *http = [[Http alloc] initWithData:self ];
    [http doSendRequest:[Common addressLoggingWithRunMenu] :[Json encode:DATA] ContentType:@"application/slucore.connectlog+json"];
    
//    [self reqestSending: : ContentType:];
//    [self sendLog:[Common addressLoggingWithRunMenu] parameter:dic  ContentType:@"application/hdu.connectlog+json"];
}

+(void)loggingForWebError:(NSString*)url service:(ServiceInfo*)service message:(NSString*)message{
    
    if (service == nil)
        return;
    
    NSString *userID =[[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] base64EncodedString];
    NSMutableDictionary *DATA = [[NSMutableDictionary alloc] init];

    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setObject: userID forKey:@"USERID"];

    [dic setObject:@"iOS"forKey:@"OS"];
    [dic setObject:[Device getAppVersion] forKey:@"APP_VERSION"];
    if (service.Id)        [dic setObject:service.Id forKey:@"ID"];
    if (service.type)      [dic setObject:[service.type stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"TYPE"];
    if (service.name)      [dic setObject:[service.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"NAME"];
    if (url)               [dic setObject:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ERROR_URL"];
    if (message)           [dic setObject:[message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"ERROR_CONTENT"];
    
    [DATA setObject:dic forKey:@"DATA"];
    Http *http = [[Http alloc] initWithData:self ];
    [http doSendRequest:[Common addressLoggingWithRunMenu] :[Json encode:DATA] ContentType:@"application/slucore.errorlog+json"];
//    [self sendLog:[Common addressLoggingWithErrorWeb] parameter:dic ContentType:@"application/hdu.errorlog+json"];

}

+(void)loggingForTagging:(ServiceInfo *)service tagType:(NSString*)tagType tagUid:(NSString*)tagUid tagId:(NSString*)tagId {
    [self loggingForTagging:service tagType:tagType tagUid:tagUid tagId:tagId latitude:nil longitude:nil];
}

+(void)loggingForTagging:(ServiceInfo *)service tagType:(NSString*)tagType tagUid:(NSString*)tagUid tagId:(NSString*)tagId latitude:(NSString*)latitude longitude:(NSString*)longitude {

    if (service == nil)
        return;
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSString *userID =[[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] base64EncodedString];
    NSMutableDictionary *DATA = [[NSMutableDictionary alloc] init];
    
    [dic setObject: userID forKey:@"USERID"];
    [dic setObject: [Device getDeviceHwV] forKey:@"DEVICE"];
    [dic setObject:@"iOS" forKey:@"OS"];
    if(tagType) [dic setObject:tagType forKey:@"TAGTYPE"];
    if(tagUid)  [dic setObject:tagUid forKey:@"TAGUID"];
    if(tagId)   [dic setObject:tagId forKey:@"TAGINFO"];
    
    if (service.Id)               [dic setObject:service.Id forKey:@"ID"];
    if (service.type)             [dic setObject:service.type  forKey:@"TYPE"];
    if (service.contentType)      [dic setObject:service.contentType  forKey:@"CONTENTTYPE"];
    if (service.name)             [dic setObject:[service.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"NAME"];
//    if (latitude)                 [dic setObject:latitude forKey:@"latitude"];
//    if (longitude)                [dic setObject:longitude forKey:@"longitude"];
    
    [DATA setObject:dic forKey:@"DATA"];
    Http *http = [[Http alloc] initWithData:self];
    [http doSendRequest:[Common addressLoggingWithRunMenu] :[Json encode:DATA] ContentType:@"application/slucore.taglog+json"];
//    [self sendLog:[Common addressLoggingWithTagging] parameter:dic  ContentType:@"application/hdu.connectlog+json"];
}

+(void)sendLog:(NSString*)urlString parameter:(NSDictionary*)parameterDic ContentType:(NSString *)contentType{
    dispatch_queue_t dQueue = dispatch_queue_create("logging",NULL);
    dispatch_async(dQueue, ^{
        NSLog(@"urlString = %@",urlString);
        NSMutableURLRequest *request = nil;
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
        
        if (parameterDic) {
            [request setHTTPMethod:@"POST"];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            NSData * body = [Json encode:parameterDic];
            [request setHTTPBody:body];
        }
        
        NSURLResponse * response;
        NSError * error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    });
}

+(void)sendLog:(NSString*)urlString parameter:(NSDictionary*)parameterDic{
    dispatch_queue_t dQueue = dispatch_queue_create("logging",NULL);
    dispatch_async(dQueue, ^{

        NSMutableURLRequest *request = nil;
        request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];

        if (parameterDic) {
            [request setHTTPMethod:@"POST"];
    
            NSMutableArray *partArray = [NSMutableArray array];
            NSString *part;

            for (NSString * key in parameterDic) {
                part = [NSString stringWithFormat:@"%@=%@",key,[parameterDic objectForKey:key]];
                [partArray addObject:part];
            }
            NSString * parts = [partArray componentsJoinedByString:@"&"];

            NSData * body = [parts dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:body];
            [request setValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
        }
        else {
            [request setHTTPMethod:@"GET"];
        }

        NSURLResponse * response;
        NSError * error;
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    });
}

- (void)Http:(Http *)aHttp didFinish:(NSMutableData *)aData
{

    
}
- (void)Http:(Http *)aHttp didFialWithError:(NSError *)aError
{
    NSLog(@"[Log]Error = %@",aError);
}

@end
