//
//  HttpHelper.h
//  Smart
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Common.h"

#define URL_ACTION_LOGIN            @"URL_ACTION_LOGIN"
#define URL_ACTION_GETNOTICELIST    @"URL_ACTION_GETNOTICELIST"
#define URL_ACTION_NOTICEPAGE       @"URL_ACTION_NOTICEPAGE"
#define URL_ACTION_GETSMARTID       @"URL_ACTION_GETSMARTID"
#define URL_ACTION_CHECKUPDATE      @"URL_ACTION_CHECKUPDATE"
#define URL_ACTION_SENDTOKEN        @"URL_ACTION_SENDTOKEN"
#define URL_ACTION_SHORTCUT         @"URL_ACTION_SHORTCUT"
#define URL_ACTION_MESSAGEPAGE      @"URL_ACTION_MESSAGEPAGE"
#define URL_ACTION_SERVICELIST      @"URL_ACTION_SERVICELIST"
#define URL_ACTION_SENDPUSH         @"URL_ACTION_SENDPUSH"
#define URL_ACTION_PUSHINFO         @"URL_ACTION_PUSHINFO"

@interface HttpHelper : NSObject
{
    NSMutableDictionary *mutableDictionary;
}

@property (nonatomic, retain) NSMutableDictionary *mutableDictionary;
@property (assign, nonatomic) BOOL isIndecator;

- (void)setDelegate:(id)target selector:(SEL)selector;
- (void)setDelegate:(id)target success:(SEL)success fail:(SEL)fail;
- (BOOL)requestUrl:(NSString *)Code :(NSDictionary *)dicParam;
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

+ (NSMutableURLRequest*)requestWithURL:(NSURL *)URL;
+ (NSMutableURLRequest*)requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;

@end
