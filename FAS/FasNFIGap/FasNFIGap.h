//
//  FasNFIGap.h
//
//  Created by fasolution on 11. 1. 4..
//  Copyright 2011 F.A. Solutions. All rights reserved.
//
//  Javascript에서 Native호출 시 처리하는 함수들을 선언
//  모든 내용들이 기본변경사항이다.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "NFIMsg.h"

@interface FasNFIGap : NSObject
{
    UIWebView *mMainWebView;
    UIView    *mMainView;

    UIWebView *mWebView;
    UIView    *mView;
}

- (id)init;
- (void)dealloc;
+ (FasNFIGap*)getSharedInstance;
- (void)setWebView:(UIWebView*)aWebView nativeBridgeForWebView:(NSURLRequest*)request;
- (void)flushCommandQueueFromWebView:(UIWebView*)selWebView;
- (int)getExecuteQueuedCommandsFromWebView:(UIWebView*)selWebView;
//- (NFIMsg*)toNFIMsg:(NSDictionary*)dic;
- (void)processMessage:(UIWebView*)theWebView URLString:(NSString*)aUrl;
- (void)parsingMessage:(UIWebView*)theWebView beforeParsingData:(NSString*)aData;
//- (void)parsingMessage:(UIWebView*)theWebView setNFIMsg:(NFIMsg*)msg;
- (UIWebView*)getWebView;
- (void)setMainWebView:(UIWebView*)aMainWebView;
- (UIWebView*)getMainWebView;
- (void)writeJavascriptFromMainWebView:(NSString*)jsFunc parameter:(NSString*)parameter;
@end
