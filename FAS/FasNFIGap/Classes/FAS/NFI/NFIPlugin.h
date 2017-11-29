//
//  NFIPlugin.h
//  NFITstTestAppIphone
//
//  Created by 원준 김 on 12. 4. 10..
//  Copyright (c) 2012년 kaskaki@chollian.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NFIMsg.h"

@interface NFIPlugin : NSObject
{
	NFIMsg* mMsg;
	UIWindow* mMainView;
	NSString* mReturnMsg;
	NSString* mReturnVal;
	NSDictionary* mReturnArgList;
}

- (id)init;
- (void)dealloc;
//- (void)initNFI:(FASJScript*)fasJScript Msg:(NFIMsg*)aMsg WebView:(UIWebView*)theWebView;
- (void)setMsg:(NFIMsg*)aMsg;
- (void)setReturnVal:(NSString*)sReturnVal;
- (void)setReturnMsg:(NSString*)sReturnMsg;
- (void)addReturnArg:(NSString*)sKey value:(id)sValue;
- (void)execute;
- (void)processCallBack;
- (void)processStaticCallBack;
- (void)webviewJavascriptCallBack;
- (NSMutableDictionary*)getReturnJSONString;
+ (void)setCallerPlugin:(NFIPlugin*)callerPlugin;
+ (NFIPlugin*)getCallerPlugin;

@end
