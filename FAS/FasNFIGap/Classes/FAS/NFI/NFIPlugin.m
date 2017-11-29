//
//  NFIPlugin.m
//  NFITstTestAppIphone
//
//  Created by 원준 김 on 12. 4. 10..
//  Copyright (c) 2012년 kaskaki@chollian.net. All rights reserved.
//

#import "NFIPlugin.h"
#import "FasJSON.h"
#import "FasNFIGap.h"

@implementation NFIPlugin

NFIPlugin* gCallerPlugin = nil;


- (id)init
{
	self = [super init];

	mMsg = nil;
	mMainView = nil;
	mReturnArgList = nil;
	mMainView = [[FasNFIGap getSharedInstance] getWebView];
	
	return self;
}


- (void)dealloc
{
//	if (mReturnArgList != nil)
//		[mReturnArgList release];
//	if (mMsg != nil)
//		[mMsg release];
//	
//	[super dealloc];
}

/*
- (void)initNFI:(FASJScript*)fasJScript Msg:(NFIMsg*)aMsg WebView:(UIWebView*)theWebView
{
	mFASJScript = fasJScript;
	mMsg = [aMsg retain];
	mWebView = theWebView;
}
*/

- (void)setMsg:(NFIMsg*)aMsg
{
//	mMsg = [aMsg retain];
	mMsg = aMsg;
}


- (void)setReturnVal:(NSString*)sReturnVal
{
	mReturnVal = sReturnVal;
}


- (void)setReturnMsg:(NSString*)sReturnMsg
{
	mReturnMsg = sReturnMsg;
}


- (void)addReturnArg:(NSString*)sKey value:(NSString*)sValue
{
	if (mReturnArgList == nil)
		mReturnArgList = [[NSMutableDictionary alloc] init];

	// mReturnArgList에 add되는 데이터가 JSON String일 경우 같이 파싱되게 변경 - ckchoi
	//[mReturnArgList setValue:sValue forKey:sKey];

	FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
	id parsingReturnArgVal = [jsonParser objectWithString:sValue];
	
	if([parsingReturnArgVal isKindOfClass:[NSDictionary class]])
	{
		NSLog(@"@FAS@|parsingReturnVal : NSDictionary!!");
		[mReturnArgList setValue:(NSDictionary*)parsingReturnArgVal forKey:sKey];
	} else {
		NSLog(@"@FAS@|parsingReturnVal : NSString!!");
		[mReturnArgList setValue:sValue forKey:sKey];
	}
	
//	[jsonParser release];
}


- (void)execute
{
	NSAssert(NO, @"NEVER CALLED THIS!!! MUST BE IMPLEMENTED!!!");
}


- (void)processCallBack
{
    [self webviewJavascriptCallBack];
//	[self autorelease];
}


- (void)processStaticCallBack
{
    [self webviewJavascriptCallBack];
}


- (void)webviewJavascriptCallBack
{
    if (mMainView == nil)
        return;

    if (mMsg == nil)
        return;

    if ([[mMsg getCallBack] length] == 0)
        return;

    NSString* sUrl = [NSString stringWithFormat:@"%@('%@')", [mMsg getCallBack], [self getReturnJSONString]];

    NSLog(@"@FAS@|CallBack String %@", sUrl);

    [(UIWebView*)mMainView stringByEvaluatingJavaScriptFromString:sUrl];
}


- (NSString*)getReturnJSONString
{
	NSLog(@"@FAS@|mReturnVal : %@", mReturnVal);
	
	FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
	NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
	[dic setValue:[mMsg getId] forKey:@"id"];
	[dic setValue:[mMsg getCommand] forKey:@"cmd"];
	
	// mReturnVal가 JSON String일 경우 같이 파싱되게 변경 - ckchoi
	//[dic setValue:mReturnVal forKey:@"returnVal"];
	id parsingReturnVal = [jsonParser objectWithString:mReturnVal];

	if([parsingReturnVal isKindOfClass:[NSDictionary class]])
	{
		//NSLog(@"@FAS@|parsingReturnVal : NSDictionary!!");
		[dic setValue:(NSDictionary*)parsingReturnVal forKey:@"returnVal"];
	} else {
		//NSLog(@"@FAS@|parsingReturnVal : NSString!!");
		[dic setValue:mReturnVal forKey:@"returnVal"];
	}

	if (mReturnArgList != nil)
		[dic setValue:mReturnArgList forKey:@"param"];

	NSString* sRet = [NSString stringWithFormat:@"%@", [jsonParser stringWithObject:dic error:nil]];
	
//	[dic release];
//	[jsonParser release];
	
	NSLog(@"@FAS@|sRet : %@",sRet);
	
	return sRet;
}


+ (void)setCallerPlugin:(NFIPlugin*)callerPlugin
{
	gCallerPlugin = callerPlugin;
}


+ (NFIPlugin*)getCallerPlugin
{
	return gCallerPlugin;
}


@end
