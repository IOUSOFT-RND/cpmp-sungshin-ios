//
//  HttpHelper.m
//  Smart
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//
#import "HttpHelper.h"
#import "Common.h"
#import "SmartDelegate.h"
#import "Base64.h"

@interface HttpHelper ()
{
    NSURLResponse *_response;
    NSMutableData *_responseData;

    id _target;
    SEL _success;
    SEL _fail;

    id<SmartDelegate> appDelegate;
}

@end

@implementation HttpHelper
@synthesize mutableDictionary;
@synthesize isIndecator;

- (id)init
{
    self = [super init];
    if (self) {
        self.isIndecator = YES;
        _responseData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)setDelegate:(id)target selector:(SEL)selector
{
    _target = target;
    _success = selector;
}

- (void)setDelegate:(id)target success:(SEL)success fail:(SEL)fail {

    _target = target;
    _success = success;
    _fail = fail;
}

- (BOOL)requestUrl:(NSString *)Code :(NSDictionary *)dicParam
{
    appDelegate = (id<SmartDelegate>)[[UIApplication sharedApplication] delegate];

    if (self.isIndecator) {
        [appDelegate showIndecator];
    }
    NSString *urlString;
    if([Code  isEqual:URL_ACTION_LOGIN]){
        urlString  = [Common addressLogin];
    }else if([Code  isEqual:URL_ACTION_GETNOTICELIST]){
        urlString  = [Common addressNoticeList];
    }else if([Code  isEqual:URL_ACTION_NOTICEPAGE]){
        urlString  = [Common addressNotice];
    }else if([Code  isEqual:URL_ACTION_GETSMARTID]){
        urlString  = [Common addressSmartId];
    }else if([Code  isEqual:URL_ACTION_CHECKUPDATE]){
        urlString  = [Common addressUpdate];
    }else if([Code  isEqual:URL_ACTION_SENDTOKEN]){
        urlString  = [Common addressSendTocken];
    }else if([Code  isEqual:URL_ACTION_SHORTCUT]){
        urlString  = [Common addressShortCut];
    }else if([Code  isEqual:URL_ACTION_MESSAGEPAGE]){
        urlString  = [NSString stringWithFormat:[Common addressMessage], [[UserData sharedUserData].USER_ID base64EncodedString]];
    }else if([Code  isEqual:URL_ACTION_SERVICELIST]){
        urlString  = [Common addressServiceList];
    }else if([Code  isEqual:URL_ACTION_SENDPUSH]){
        urlString  = [Common addressSendPush];
    }else if([Code  isEqual:URL_ACTION_PUSHINFO]){
        urlString  = [Common addressPushInfo];
    }

    DLog(@"URL : ' %@ ' ", urlString);
    //뒷부분에 파라메터가 추가되어있을때 파라메터 추출(post 일때만)
    NSRange range = [urlString rangeOfString:@"?"];
    NSString *addedParam;
    if (range.length > 0 && dicParam) {
        addedParam = [urlString substringFromIndex:range.location +1];
        urlString = [urlString substringToIndex:range.location];
    }

    NSMutableURLRequest *request = nil;
    request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];

    if (dicParam) {
        [request setHTTPMethod:@"POST"];

        NSMutableArray *partArray = [NSMutableArray array];
        NSString *part;
        
        // 추출한 파라미터 추가 등록
        if (addedParam) {
            [partArray addObject:addedParam];
        }

        for (NSString * key in dicParam) {
            part = [NSString stringWithFormat:@"%@=%@",key,[dicParam objectForKey:key]];
            [partArray addObject:part];
        }
        NSString * parts = [partArray componentsJoinedByString:@"&"];

        DLog(@" parameter : ' %@ ' ", parts);
        NSLog(@"%@?%@", urlString, parts);
        NSData * body = [parts dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)[body length]] forHTTPHeaderField:@"Content-Length"];
    }
    else {
        [request setHTTPMethod:@"GET"];
    }

    NSString* languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    [request setValue:[languageCode uppercaseString] forHTTPHeaderField:@"language"];

    UserData * ud = [UserData sharedUserData];

    NSString *cookie = ud.COOKIE;
    if (cookie && ![cookie isEqualToString:@""]) {
        [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    }

    if ([NSThread isMainThread]) {
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];

        if (connection) {
            [connection start];
            return YES;
        }
        return NO;
    }
    else {
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (error) {
            if(_target && [_target respondsToSelector:_fail]) {
                [_target performSelectorOnMainThread:_fail withObject:nil waitUntilDone:YES];
            }
        }
        else {
            if(_target && [_target respondsToSelector:_success]) {

                NSError *error;
                self.mutableDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                [self removeNullValueFromDictionary:self.mutableDictionary];

                if (self.isIndecator) {
                    [appDelegate hideIndecator];
                }

                if (error) {
                    [appDelegate showAlertWithTitle:@"JSON Error" :[error description] :nil :nil];
                }
                else {
                    if(_target && [_target respondsToSelector:_success]) {
                        [_target performSelectorOnMainThread:_success withObject:self.mutableDictionary waitUntilDone:YES];
                    }
                }            }
        }
        return (error)?NO:YES;
    }
}

-(void) removeNullValueFromDictionary:(NSMutableDictionary *)dic {
//    Class class = [NSNull class];
//    NSArray * keys = [dic allKeys];
//    for (NSString * key  in keys) {
//        NSObject * o = [dic objectForKey:key];
//        if ([o isKindOfClass:class]) {
//            [dic removeObjectForKey:key];
//        }
//    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    DLog(@"ResponseText : %@", [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding]);

    NSError *error;
    self.mutableDictionary = [NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    [self removeNullValueFromDictionary:self.mutableDictionary];

    if (self.isIndecator) {
        [appDelegate hideIndecator];
    }

    if (error) {
        [appDelegate showAlertWithTitle:@"JSON Error" :[error description] :nil :nil];
    }
    else {
        if(_target && [_target respondsToSelector:_success]) {
            [_target performSelectorOnMainThread:_success withObject:self.mutableDictionary waitUntilDone:YES];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.isIndecator) {
        [appDelegate hideIndecator];
    }
    [appDelegate showAlertWithTitle:@"Server Error" :[error description] :nil :nil];

    if(_target && [_target respondsToSelector:_fail])
    {
        [_target performSelectorOnMainThread:_fail withObject:nil waitUntilDone:YES];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_responseData setLength:0];
    _response = response;

    NSHTTPCookie *cookie;
	for (cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
	{
        [UserData sharedUserData].COOKIE = [NSString stringWithFormat:@"%@=%@", [cookie valueForKey:@"name"], [cookie valueForKey:@"value"]];
        //       DLog(@"%@", [cookie description]);
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
        //        if (... user allows connection despite bad certificate ...)
        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

+ (void)setUserAgent:(NSMutableURLRequest*)request {

    NSString * string = [request valueForHTTPHeaderField:@"User-Agent"];

    if (string == nil) {
        string = @"";
    }
    string = [string stringByAppendingString:@"; (ICMP Smart Launcher);"];
    [request setValue:string forHTTPHeaderField:@"User-Agent"];
}

+ (NSMutableURLRequest*)requestWithURL:(NSURL *)URL {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL];

    [self setUserAgent:request];
    return request;
}

+ (NSMutableURLRequest*)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];

    [self setUserAgent:request];
    return request;
}

@end
