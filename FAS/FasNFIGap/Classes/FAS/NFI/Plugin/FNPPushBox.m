
//
//  FNPPushBox.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FNPPushBox.h"
#import "NFIParamPlugin.h"
#import "FasPushBoxController.h"
#import "FasMQTTClient.h"
#import "FasHTTPRequest.h"
#import "FasPushBoxUtil.h"
#import "FasJSON.h"
#import "FasViewManager.h"

@implementation FNPPushBox
/*
static UIView *mSubView = nil;

static id target;
static SEL selector;
*/

- (void)execute
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.execute");
#endif
	NSAssert(NO, @"NEVER CALLED THIS!!! MUST BE IMPLEMENTED!!!");
//	[self autorelease];
}

- (id)init
{
    self = [super init];
    
    if (delegate == nil) {
        delegate = self;
    }
    return self;
}

- (id)init:(id)callbackDelegate
{
    delegate = callbackDelegate;
    return [self init];
}

- (id)init:(UIWindow*)mainView delegate:(id)callbackDelegate
{
    self = [self init:callbackDelegate];
    mMainView = mainView;
    
    return self;
}


- (void)startView
{
    [self startView:mMsg];
}

- (void)startView:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.startView");
    NSLog(@"@FAS@|mMainView = %@", mMainView);
#endif
	
	// startView 할때 뷰가 열려 있을 경우 닫고 새로 시작한다
	[self endView];

	// 푸쉬박스에서 데이터를 메인뷰로 보낼 딜리게이터를 설정한다.
	// TODO : 추후 뷰 메니져를 만들어서 관리하게 한다. ( 하이브리드앱, 네이티브앱에서의 뷰관리 )
/*
	[self setDelegate:delegate selector:@selector(callbackMainView:)];
*/
    
    if (delegate == nil) {
        delegate = self;
    }
    
	[[FasViewManager getSharedInstance] setDelegate:delegate
										   selector:@selector(callbackMainView:)];

	[self openPushBox:[NSString stringWithFormat:@"%@/%@",[msg getCustArg:@"fileWWWPath"],[msg getArg:@"url"]]];
	//[self autorelease];
}


- (void)endView
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.endView");
#endif

	UIView *subView = [[FasViewManager getSharedInstance] getSubView];
	if(subView != nil) {
/*
		[subView removeFromSuperview];
		[subView release];
		subView = nil;
*/
		[[FasViewManager getSharedInstance] removeSubView];
	}
/*
	[mSubView removeFromSuperview];
*/
    
    [self getBadge];
}

- (void)startHome
{
    
}

- (void)show
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.show");
#endif
	
	UIView *subView = [[FasViewManager getSharedInstance] getSubView];
	if(subView != nil) {
		[subView setHidden:NO];
	}
/*
	[mSubView removeFromSuperview];
	[mSubView setHidden:NO];
*/
}


- (void)hide
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.hide");
#endif
	
	UIView *subView = [[FasViewManager getSharedInstance] getSubView];
	if(subView != nil) {
		[subView setHidden:YES];
	}
/*
	[mSubView removeFromSuperview];
	[mSubView setHidden:YES];
*/
}


- (void)sendDataToCallback
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.sendDataToCallback");
#endif
   
	
	NSDictionary *reqParam = [mMsg getArgList];
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif

	FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
	
	FasViewManager *aFasViewManager = [FasViewManager getSharedInstance];

	if([aFasViewManager isAvailableDelegate])
	{
		[[aFasViewManager getTargetDelegate] performSelector:[aFasViewManager getTargetSelector]
												  withObject:[jsonParser stringWithObject:reqParam]];
	}
/*
    if(target)
    {
        [target performSelector:selector withObject:[jsonParser stringWithObject:reqParam]];

    }
*/
//	[jsonParser release];
}

- (void)isSubscribe
{
    [self isSubscribe:mMsg];
}

- (void)isSubscribe:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.isSubscribed");
#endif
    
    NSLog(@"=================== isSubscribe ==================");

    // HTTP Request 인스턴스 생성
    FasHTTPRequest *httpRequest = [[FasHTTPRequest alloc] init];
	
    // POST로 전송할 데이터 설정
//	NSMutableDictionary *bodyObject = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableDictionary *bodyObject = [[NSMutableDictionary alloc] init];

	// request parameter를 보내기 위한 준비
	NSString *url;
	NSString *keyTmp;
	NSDictionary *reqParam = [msg getArgList];
	
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	
	// 실행 커맨드를 설정
	[bodyObject setValue:@"isSubscribe" forKey:@"CMD"]; //subscribe:등록 ,unsubscribe:등록해지 ,isSubscribe:등록확인

#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif

	for(keyTmp in reqParam)
	{
		if([keyTmp isEqualToString:@"url"])
		{
			// 받은 데이터 중 url이 있을 경우 는 포함하지 않음
			url = [reqParam objectForKey:keyTmp];
		}
		else
		{
			[bodyObject setValue:[reqParam objectForKey:keyTmp] forKey:keyTmp];
			
			// 받은 데이터 중 app_code가 있을 경우 디바이스에 저장된 추가 데이터를 꺼내와 보낼 파라메터에 설정
			if([keyTmp isEqualToString:@"app_code"])
			{
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"cno"]]
							  forKey:@"cno"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"user_id"]]
							  forKey:@"user_id"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getDeviceToken:[reqParam objectForKey:keyTmp]]]
							  forKey:@"push_token"];
			}
		}
	}

	NSDictionary *deviceInfo = [fpbu getDeviceInfo];

	// 보낼 파라메터에 추가 설정 ( 디바이스 정보 및 서버에 저장할 정보 )
	//[bodyObject setValue:[deviceInfo objectForKey:@"identifierForVendor"] forKey:@"device_id"];
        [bodyObject setValue:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]forKey:@"cno"]        forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"model"]            forKey:@"model"];
	[bodyObject setValue:[deviceInfo objectForKey:@"systemName"]       forKey:@"os_name"];
	[bodyObject setValue:[deviceInfo objectForKey:@"systemVersion"]    forKey:@"os_version"];
	//[bodyObject setValue:@"-"    forKey:@"phone_num"];
	[bodyObject setValue:@"0"    forKey:@"agency_code"];  // 0:알수없음 ,1:skt ,2:kt, 3:LGT
	[bodyObject setValue:@"APNS" forKey:@"token_issuer"];

//	[fpbu release];

#ifdef DEBUG
	NSLog(@"@FAS@|===========================================================");
	
	NSLog(@"@FAS@|>> url : %@", url);
	for(keyTmp in bodyObject) {
		NSLog(@"@FAS@|%@ : %@", keyTmp, [bodyObject objectForKey:keyTmp]);
	}
	NSLog(@"@FAS@|===========================================================");
#endif

	// 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:delegate selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
}

- (void)subscribe
{
    [self subscribe:mMsg];
}

- (void)subscribe:(NFIMsg*)msg
{
    NSLog(@"@FAS@|FNPPushBox.subscribe");


	// HTTP Request 인스턴스 생성
    FasHTTPRequest *httpRequest = [[FasHTTPRequest alloc] init];
	
    // POST로 전송할 데이터 설정
	NSMutableDictionary *bodyObject = [[NSMutableDictionary alloc] init];
	
	// request parameter를 보내기 위한 준비
	NSString *url;
	NSString *keyTmp;
	NSDictionary *reqParam = [msg getArgList];
	
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	
	// 실행 커맨드를 설정
	[bodyObject setValue:@"subscribe" forKey:@"CMD"]; //subscribe:등록 ,unsubscribe:등록해지 ,isSubscribe:등록확인
	
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif
    NSLog(@"@FAS@|-----------------------------------------------------------");
    NSLog(@"@FAS@|reqParam : %@", reqParam);
    NSLog(@"@FAS@|-----------------------------------------------------------");
	
	for(keyTmp in reqParam)
	{
		if([keyTmp isEqualToString:@"url"])
		{
			// 받은 데이터 중 url이 있을 경우 는 포함하지 않음
			url = [reqParam objectForKey:keyTmp];
		}
		else
		{
			[bodyObject setValue:[reqParam objectForKey:keyTmp] forKey:keyTmp];
			
			// 받은 데이터 중 app_code가 있을 경우 디바이스에 저장된 추가 데이터를 꺼내와 보낼 파라메터에 설정
			if([keyTmp isEqualToString:@"app_code"])
			{
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"cno"]]
							  forKey:@"cno"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"user_id"]]
							  forKey:@"user_id"];
                [bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
                                                                              forKey:@"user_id"]]
                              forKey:@"custId"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getDeviceToken:[reqParam objectForKey:keyTmp]]]
							  forKey:@"push_token"];
			}
		}
	}
	
	NSDictionary *deviceInfo = [fpbu getDeviceInfo];
    NSDictionary *appPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appPlist objectForKey:@"app_version"];
    
	// 보낼 파라메터에 추가 설정 ( 디바이스 정보 및 서버에 저장할 정보 )
	//[bodyObject setValue:[deviceInfo objectForKey:@"identifierForVendor"] forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"uuid"]             forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"model"]            forKey:@"model"];
	[bodyObject setValue:[deviceInfo objectForKey:@"systemName"]       forKey:@"os_name"];
    [bodyObject setValue:[deviceInfo objectForKey:@"os_locale"]        forKey:@"os_locale"];
	//[bodyObject setValue:@"-"    forKey:@"phone_num"];
	[bodyObject setValue:@"0"    forKey:@"agency_code"];  // 0:알수없음 ,1:skt ,2:kt, 3:LGT
	[bodyObject setValue:@"APNS" forKey:@"token_issuer"];
    [bodyObject setValue:[deviceInfo objectForKey:@"systemVersion"]    forKey:@"os_version"];
    [bodyObject setValue:appVersion    forKey:@"app_version"];
	
//	[fpbu release];
	
    NSLog(@"@FAS@|===========================================================");
    
    NSLog(@"@FAS@|>> url : %@", url);
    for(keyTmp in bodyObject) {
        NSLog(@"@FAS@|%@ : %@", keyTmp, [bodyObject objectForKey:keyTmp]);
    }
    NSLog(@"@FAS@|===========================================================");
    
	
	// 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:delegate selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
	
}

- (void)unSubscribe
{
    [self unSubscribe:mMsg];
}

- (void)unSubscribe:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.unSubscribe");
#endif
/*
	[[UIApplication sharedApplication] unregisterForRemoteNotifications];
*/
	// HTTP Request 인스턴스 생성
    FasHTTPRequest *httpRequest = [[FasHTTPRequest alloc] init];
	
    // POST로 전송할 데이터 설정
//	NSMutableDictionary *bodyObject = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableDictionary *bodyObject = [[NSMutableDictionary alloc] init];
	
	// request parameter를 보내기 위한 준비
	NSString *url;
	NSString *keyTmp;
	NSDictionary *reqParam = [msg getArgList];
	
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	
	// 실행 커맨드를 설정
	[bodyObject setValue:@"unsubscribe" forKey:@"CMD"]; //subscribe:등록 ,unsubscribe:등록해지 ,isSubscribe:등록확인
	
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif
	
	for(keyTmp in reqParam)
	{
		if([keyTmp isEqualToString:@"url"])
		{
			// 받은 데이터 중 url이 있을 경우 는 포함하지 않음
			url = [reqParam objectForKey:keyTmp];
		}
		else
		{
			[bodyObject setValue:[reqParam objectForKey:keyTmp] forKey:keyTmp];
			
			// 받은 데이터 중 app_code가 있을 경우 디바이스에 저장된 추가 데이터를 꺼내와 보낼 파라메터에 설정
			if([keyTmp isEqualToString:@"app_code"])
			{
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"cno"]]
							  forKey:@"cno"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"user_id"]]
							  forKey:@"user_id"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getDeviceToken:[reqParam objectForKey:keyTmp]]]
							  forKey:@"push_token"];
			}
		}
	}
	
	NSDictionary *deviceInfo = [fpbu getDeviceInfo];
	
	// 보낼 파라메터에 추가 설정 ( 디바이스 정보 및 서버에 저장할 정보 )
	//[bodyObject setValue:[deviceInfo objectForKey:@"identifierForVendor"] forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"uuid"]             forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"model"]            forKey:@"model"];
	[bodyObject setValue:[deviceInfo objectForKey:@"systemName"]       forKey:@"os_name"];
	[bodyObject setValue:[deviceInfo objectForKey:@"systemVersion"]    forKey:@"os_version"];
	//[bodyObject setValue:@"-"    forKey:@"phone_num"];
	[bodyObject setValue:@"0"    forKey:@"agency_code"];  // 0:알수없음 ,1:skt ,2:kt, 3:LGT
	[bodyObject setValue:@"APNS" forKey:@"token_issuer"];
	
//	[fpbu release];
	
#ifdef DEBUG
	NSLog(@"@FAS@|===========================================================");
	
	NSLog(@"@FAS@|>> url : %@", url);
	for(keyTmp in bodyObject) {
		NSLog(@"@FAS@|%@ : %@", keyTmp, [bodyObject objectForKey:keyTmp]);
	}
	NSLog(@"@FAS@|===========================================================");
#endif
	
	// 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:delegate selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
}

- (void)initMqttClient
{
    [self initMqttClient:mMsg];
}

- (void)initMqttClient:(NFIMsg*)msg
{
#ifdef DEBUG
    NSLog(@"@FAS@|FNPPushBox.initMqttClient");
#endif
	NSDictionary *reqParam = [msg getArgList];
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];

	[fpbu setMqttPrefData:[msg getArg:@"enabled"]        forKey:@"enabled"];
	[fpbu setMqttPrefData:[msg getArg:@"host"]           forKey:@"host"];
	[fpbu setMqttPrefData:[msg getArg:@"port"]           forKey:@"port"];
	if([msg getArg:@"keepalive"] == nil) [msg setArg:@"keepalive" value:@"60"];
	[fpbu setMqttPrefData:[msg getArg:@"keepalive"]      forKey:@"keepalive"];
	[fpbu setMqttPrefData:[msg getArg:@"clean_session"]  forKey:@"clean_session"];
	[fpbu setMqttPrefData:[msg getArg:@"username"]       forKey:@"username"];
	[fpbu setMqttPrefData:[msg getArg:@"password"]       forKey:@"password"];
	[fpbu setMqttPrefData:[msg getArg:@"use_ssl"]        forKey:@"use_ssl"];
	[fpbu setMqttPrefData:[msg getArg:@"qos"]            forKey:@"qos"];
	[fpbu setMqttPrefData:[msg getArg:@"lwt_topic"]      forKey:@"lwt_topic"];
	[fpbu setMqttPrefData:[msg getArg:@"lwt_msg"]        forKey:@"lwt_msg"];
	[fpbu setMqttPrefData:[msg getArg:@"result_send"]    forKey:@"result_send"];

	if([[fpbu getMqttPrefData:@"enabled"] isEqualToString:@"true"]) {
		NSLog(@"@FAS@|enableMQTT true!");
		//[[FasMQTTClient getSharedInstance] setConnectParameter:reqParam];

		// 파라메터 세팅
		[[FasMQTTClient getSharedInstance] setConnectParameter:[fpbu getMqttPrefAllData]];

		// app_code 에 설정되어 있는 topic 정보를 확인해 subscribe 하기 위해 정보를 세팅해 놓는다.
		id mapTmp = [fpbu getPushBoxPrefAllData];
		id key;
		id value;

		for(key in mapTmp) {
			value = [[mapTmp objectForKey:key] objectForKey:@"MqttTopic"];

			if(value != nil)
				[[FasMQTTClient getSharedInstance] setTopic:value forKey:key];
		}

		// MQTT Brocker 연결 실행 ( 실행 후 세팅된 subcribe 정보를 기준으로 subcribe 까지 진행 )
		[[FasMQTTClient getSharedInstance] connect];
	}
	else {
		NSLog(@"@FAS@|enableMQTT false!");
	}
	
	
#ifdef DEBUG
	[fpbu logPushBoxPrefData]; // 로그를 찍는다.
#endif
//	[fpbu release];

	[self setReturnVal:@"succ"];
	[self processCallBack];
}

- (void)setMqttClient
{
    [self setMqttClient:mMsg];
}

- (void)setMqttClient:(NFIMsg*)msg
{
#ifdef DEBUG
    NSLog(@"@FAS@|FNPPushBox.setMqttClient");
#endif
	NSDictionary *reqParam = [msg getArgList];
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif
	
	NSString* app_code = [msg getArg:@"app_code"];
#ifdef DEBUG
	NSLog(@"@FAS@|app_code : %@",app_code);
#endif

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];

	if([[fpbu getMqttPrefData:@"enabled"] isEqualToString:@"true"]) {

		NSDictionary *deviceInfo = [fpbu getDeviceInfo];

		// 기본 토픽 구성사항
		NSString* mqttTopic = [NSString stringWithFormat:@"/%@/%@/%@/%@/"
							   ,app_code
							   ,[fpbu getPushboxPrefData:app_code forKey:@"cno"]
							   ,[deviceInfo objectForKey:@"uuid"]
							   ,@"msg"];

		NSLog(@"@FAS@|setMqttClient topic : %@",mqttTopic);

		[fpbu setPushboxPrefData:app_code setData:mqttTopic forKey:@"MqttTopic"];

		// 결과 토픽 구성사항
		NSString* mqttResultTopic = [NSString stringWithFormat:@"/%@/%@/%@/%@"
									 ,app_code
									 ,[fpbu getPushboxPrefData:app_code forKey:@"cno"]
									 ,[deviceInfo objectForKey:@"uuid"]
									 ,@"clientPub"];
		
		NSLog(@"@FAS@|setMqttResult topic : %@",mqttResultTopic);
		
		[fpbu setPushboxPrefData:app_code setData:mqttResultTopic forKey:@"MqttResultTopic"];

		[[FasMQTTClient getSharedInstance] unsubscribe];
		[[FasMQTTClient getSharedInstance] setTopic:mqttTopic forKey:app_code];
		[[FasMQTTClient getSharedInstance] subscribe];
	}
#ifdef DEBUG
	[fpbu logPushBoxPrefData]; // 로그를 찍는다.
#endif
//	[fpbu release];

	[self setReturnVal:@"succ"];
	[self processCallBack];
}


- (void)didReceiveFinished:(NSString *)result
{
#ifdef DEBUG

#endif
    NSLog(@"@FAS@|FNPPushBox.didReceiveFinished");
    NSLog(@"@FAS@|Received data:\n%@", result);
    
/*
	// NFI 방식으로 변경할시 처리 방법
	[self setReturnVal:@"succ"];                // 결과코드 : succ, fail
	[self setReturnMsg:@"error msg"];           // 결과메시지 : fail 일때 메시지를 넣는다
	[self addReturnArg:@"key1" value:@"data1"]; // 파라메터에 리턴 데이터를 넣는다.
	[self addReturnArg:@"key2" value:@"data2"]; // 파라메터에 리턴 데이터를 넣는다.
	 
	{
	  "id":"FPNS"
	  ,"returnVal":"succ"
	  ,"cmd":"command"
	  ,"param":{
	             "key1":"data1"
	            ,"key2":"data2"
	  }
	}
*/
/*
	[self setReturnVal:@"succ"];
	[self setReturnMsg:@""];
	[self addReturnArg:@"data" value:result];
*/
	[self setReturnVal:result];
	[self processCallBack];
    
    
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    id resultObj = [jsonParser objectWithString:result];
    
    NSString* command = [resultObj valueForKey:@"CMD"];
    
#ifdef DEBUG
    
#endif
    NSLog(@"FNPPushBox.didReceiveFinished : command = %@", command);
    
    if ([command isEqualToString:@"getBadge"]) {
        
        NSObject* data = [resultObj objectForKey:@"DATA"];
        NSString* badge = [data valueForKey:@"badge"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BadgeCountNotification" object:badge];
        
    }

}


- (void)setUserInfo
{
    [self setUserInfo:mMsg];
}

- (void)setUserInfo:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setUserInfo");
#endif

	NSString* app_code = [msg getArg:@"app_code"];
	NSString* cno      = [msg getArg:@"cno"];
	NSString* url      = [msg getArg:@"url"];
	NSString* user_id  = [msg getArg:@"user_id"];
#ifdef DEBUG
	NSLog(@"@FAS@|app_code : %@",app_code);
	NSLog(@"@FAS@|cno : %@",cno);
	NSLog(@"@FAS@|url : %@",url);
	NSLog(@"@FAS@|user_id : %@",user_id);
#endif

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
	
	[fpbu setPushboxPrefData:app_code setData:cno forKey:@"cno"];
	[fpbu setPushboxPrefData:app_code setData:[fpbu NilToEmptyString:user_id] forKey:@"user_id"];
#ifdef DEBUG
	[fpbu logPushBoxPrefData]; // 로그를 찍는다.
#endif
//	[fpbu release];

//	[app_code release];
//	[cno release];
//	[url release];
//	[user_id release];
}

- (void)hasMessage
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.hasMessage");
#endif

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
	
	NSString *hiddenData = [fpbu getPushboxPrefSystemData:@"_H"];

//	[fpbu release];
	
	[self setReturnVal:hiddenData];
	[self processCallBack];
}


- (void)getPreview
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.getPreview");
#endif
}


- (void)setPreview
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setPreview");
#endif
}


- (void)getNotify
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.getNotify - mMsg callback : %@", [mMsg getCallBack]);
#endif

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];

	NSString *result = [fpbu isPushState] ? @"true" : @"false";

//	[fpbu release];
	
	[self setReturnVal:result];
	[self processCallBack];
}


- (void)setNotify
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setNotify");
#endif
}


- (void)getPassword
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.getPassword");
#endif
}


- (void)setPassword
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setPassword");
#endif
}


- (void)isLocked
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.isLocked");
#endif
}


//- (void)requestHttp
//{
//    [self requestHttp:mMsg];
//}
//
//- (void)requestHttp:(NFIMsg*)msg
//{
//#ifdef DEBUG
//	NSLog(@"@FAS@|FNPPushBox.requestHttp");
//#endif
//	
//	// HTTP Request 인스턴스 생성
//    FasHTTPRequest *httpRequest = [[FasHTTPRequest alloc] init];
//	
//    // POST로 전송할 데이터 설정
//	NSMutableDictionary *bodyObject = [[[NSMutableDictionary alloc] init] autorelease];
//	
//	// request parameter를 보내기 위한 준비
//	NSString *url;
//	NSString *keyTmp;
//	NSDictionary *reqParam = [msg getArgList];
//	
//	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
//	
//#ifdef DEBUG
//	NSLog(@"@FAS@|-----------------------------------------------------------");
//	NSLog(@"@FAS@|reqParam : %@", reqParam);
//	NSLog(@"@FAS@|-----------------------------------------------------------");
//#endif
//	
//	for(keyTmp in reqParam)
//	{
//		if([keyTmp isEqualToString:@"url"])
//		{
//			// 받은 데이터 중 url이 있을 경우 는 포함하지 않음
//			url = [reqParam objectForKey:keyTmp];
//		}
//		else
//		{
//			[bodyObject setValue:[reqParam objectForKey:keyTmp] forKey:keyTmp];
//		}
//	}
//
//	[fpbu release];
//	
//#ifdef DEBUG
//	NSLog(@"@FAS@|===========================================================");
//	
//	NSLog(@"@FAS@|>> url : %@", url);
//	for(keyTmp in bodyObject) {
//		NSLog(@"@FAS@|%@ : %@", keyTmp, [bodyObject objectForKey:keyTmp]);
//	}
//	NSLog(@"@FAS@|===========================================================");
//#endif
//	
//	// 통신 완료 후 호출할 델리게이트 셀렉터 설정
//    [httpRequest setDelegate:delegate selector:@selector(didReceiveFinished:)];
//    
//    // 페이지 호출
//    [httpRequest requestUrl:url bodyObject:bodyObject];
//}

- (void)requestHttp
{
    [self requestHttpForLotte];
}

- (void)requestHttp:(NFIMsg *)msg
{
    [self requestHttpForLotte:msg];
}

- (void)requestHttpForLotte
{
    [self requestHttpForLotte:mMsg];
}

- (void)requestHttpForLotte:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.requestHttpForLotte");
#endif
	
	// HTTP Request 인스턴스 생성
    FasHTTPRequest *httpRequest = [[FasHTTPRequest alloc] init];
	
    // POST로 전송할 데이터 설정
//	NSMutableDictionary *bodyObject = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableDictionary *bodyObject = [[NSMutableDictionary alloc] init];
	
	// request parameter를 보내기 위한 준비
	NSString *url;
	NSString *keyTmp;
	NSDictionary *reqParam = [msg getArgList];
    
    NSString* cmd = [msg getCommand];
    if (cmd != nil) {
        	[bodyObject setValue:cmd forKey:@"CMD"];
    }
	
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	
#ifdef DEBUG
	NSLog(@"@FAS@|-----------------------------------------------------------");
	NSLog(@"@FAS@|reqParam : %@", reqParam);
	NSLog(@"@FAS@|-----------------------------------------------------------");
#endif
	
	for(keyTmp in reqParam)
	{
		if([keyTmp isEqualToString:@"url"])
		{
			// 받은 데이터 중 url이 있을 경우 는 포함하지 않음
			url = [reqParam objectForKey:keyTmp];
		}
		else
		{
			[bodyObject setValue:[reqParam objectForKey:keyTmp] forKey:keyTmp];
			
			// 받은 데이터 중 app_code가 있을 경우 디바이스에 저장된 추가 데이터를 꺼내와 보낼 파라메터에 설정
			if([keyTmp isEqualToString:@"app_code"])
			{
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"cno"]]
							  forKey:@"cno"];
				/*
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getPushboxPrefData:[reqParam objectForKey:keyTmp]
																			  forKey:@"user_id"]]
							  forKey:@"user_id"];
				[bodyObject setValue:[fpbu NilToEmptyString:[fpbu getDeviceToken]]
							  forKey:@"push_token"];
				*/
			}
		}
	}
	
	NSDictionary *deviceInfo = [fpbu getDeviceInfo];
	
	// 보낼 파라메터에 추가 설정 ( 디바이스 정보 및 서버에 저장할 정보 )
	//[bodyObject setValue:[deviceInfo objectForKey:@"identifierForVendor"] forKey:@"device_id"];
	[bodyObject setValue:[deviceInfo objectForKey:@"uuid"] forKey:@"device_id"];

//	[fpbu release];
	
#ifdef DEBUG
	NSLog(@"@FAS@|===========================================================");
	
	NSLog(@"@FAS@|>> url : %@", url);
	for(keyTmp in bodyObject) {
		NSLog(@"@FAS@|%@ : %@", keyTmp, [bodyObject objectForKey:keyTmp]);
	}
	NSLog(@"@FAS@|===========================================================");
#endif
	
	// 통신 완료 후 호출할 델리게이트 셀렉터 설정
    [httpRequest setDelegate:delegate selector:@selector(didReceiveFinished:)];
    
    // 페이지 호출
    [httpRequest requestUrl:url bodyObject:bodyObject];
}

- (void)setBadge
{
    [self setBadge:mMsg];
}

- (void)setBadge:(NFIMsg*)msg
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setBadge");
#endif
	NSString* badge = [msg getArg:@"badge"];
	NSLog(@"@FAS@|badge : %@",badge);

	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	[fpbu setBadge:[badge intValue]];
//	[fpbu release];
}


- (void)plusBadge
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.plusBadge");
#endif
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	[fpbu upCountBadge];
//	[fpbu release];
}


- (void)minusBadge
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.minusBadge");
#endif
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
	[fpbu downCountBadge];
//	[fpbu release];
}


- (void)getNotificationSetting
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.getNotificationSetting - mMsg callback : %@", [mMsg getCallBack]);
#endif

	NSUInteger rntypes;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        rntypes =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }else{
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
    
    
    NSString* currVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    
    
    NSString* newVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"appversion"];
    
	// 알림스타일 여부 ( 이 값이 0인 경우 알림 메세지가 보이지 않는다. )
	NSString *result = (rntypes & UIRemoteNotificationTypeAlert) ? @"true" : @"false";
    NSMutableDictionary* obj = [[NSMutableDictionary alloc] init];
    [obj setValue:result forKey:@"alertEnabled"];
    [obj setValue:currVersion forKey:@"currentVersion"];
    [obj setValue:newVersion forKey:@"newVersion"];
    
	FasSBJSON *jsonParser = [[FasSBJSON alloc] init];

	[self setReturnVal:[jsonParser stringWithObject:obj]];
	[self processCallBack];
//	[fpbu release];
}

/*
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.setDelegate");
#endif
	target = aTarget;
	selector = aSelector;
}
*/

- (void)callbackMainView:(NSString*)result
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPPushBox.callbackMain");
#endif
	
	NSString *cbFunc = [mMsg getCustArg:@"callbackFunctionName"];

	NSString* sUrl = [NSString stringWithFormat:@"%@(%@)", cbFunc, result];
	
    NSLog(@"@FAS@|CallBack String %@", sUrl);
	
    // Native로 구현 @etyoul
//    [mWebView stringByEvaluatingJavaScriptFromString:sUrl];
    
    
    
/*
	
	NSLog(@"@FAS@|@@@@@@@@@@@@ cbFunc : %@",cbFunc);
	//[mWebView stringByEvaluatingJavaScriptFromString:@"testCallBack()" ];
	
	NSString* sUrl = [NSString stringWithFormat:@"%@()", cbFunc];
	
    NSLog(@"@FAS@|CallBack String %@", sUrl);
	
    [mWebView stringByEvaluatingJavaScriptFromString:sUrl];
*/	
	
}


- (void)openPushBox:(NSString *)url
{
	CGRect rt = mMainView.bounds;
	CGRect webFrame = CGRectMake(rt.origin.x, rt.origin.y, rt.size.width, rt.size.height);
	//CGRect webFrame = CGRectMake(rt.origin.x, rt.origin.y - rt.size.height, rt.size.width, rt.size.height - rt.size.height);
	
	FasPushBoxController* __strong navitemp = [[FasPushBoxController alloc] init];
	mNav = [[UINavigationController alloc] initWithRootViewController:navitemp];

	[navitemp setBound:rt];				//theWebView의 좌표정보 전달
	[navitemp setUrlLink:url];			//공통으로 사용하는 url링크 정보
	
	//mSubView = [[UIView alloc] initWithFrame:webFrame];
	UIView* mSubView = [[UIView alloc] initWithFrame:webFrame];
	
	mSubView.autoresizesSubviews = YES;
	mSubView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
	
	//[mSubView setBackgroundColor:[UIColor whiteColor]];
	//mSubView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

	[mSubView addSubview:mNav.view];
	[mMainView addSubview:mSubView];
    
//    [mNav setView:[navitemp view]];

	// UI 변환 Animation
/*
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	//[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:mWebView cache:YES];
	//mSubView.frame = CGRectMake(0,0,280,227);
	mSubView.frame = CGRectMake(rt.origin.x, rt.origin.y, rt.size.width, rt.size.height);
	[UIView commitAnimations];
*/
	
	[navitemp setParentView:mSubView];		//navibar에서 제어 가능하도록 생성된 webView정보 전달
	
	[[FasViewManager getSharedInstance] setSubView:mSubView];
	
//	[mSubView release];
}

- (void)moveToLandingUrl
{
    [self moveToLandingUrl:mMsg];
}

- (void)moveToLandingUrl:(NFIMsg*)msg
{
#ifdef DEBUG
    NSLog(@"@@FAS@@|moveToLandingUrl - url : %@", [msg getArg:@"url"]);
#endif
    
    NSString* url = [msg getArg:@"url"];
    if (![url isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebViewNotification" object:url];
        [self endView];
    }
}
- (void)moveToAppPage
{
    [self moveToAppPage:mMsg];
}

- (void)moveToAppPage:(NFIMsg*)msg
{
    
#ifdef DEBUG
    NSLog(@"@@FAS@@|moveToAppPage - msgId : %@", [msg getArg:@"msgId"]);
#endif
    
    NSString* msgId = [msg getArg:@"msgId"];
    if (![msgId isEqualToString:@""]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppPageByNotification" object:msgId];
        [self endView];
    }

    
}


- (void)getBadge
{
#ifdef DEBUG
    NSLog(@"FNPPushBox.getBadge");
#endif
        
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    
    NSString* appCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"appcode" ];
    NSString* url = [[NSUserDefaults standardUserDefaults] valueForKey:@"url_message" ];
    
    NSString* cno = [fpbu getPushboxPrefData:appCode forKey:@"cno"];
    NFIMsg* msg = [[NFIMsg alloc]init];
    
    [msg setArg:@"app_code" value:appCode];
    [msg setCommand:@"getBadge"];
    [msg setArg:@"url" value:url];
    [msg setArg:@"cno" value:cno];
    
    FNPPushBox* pushBox = [[FNPPushBox alloc] init:self];
    
    [pushBox requestHttp:msg];
    //        [pushBox autorelease];
}


@end
