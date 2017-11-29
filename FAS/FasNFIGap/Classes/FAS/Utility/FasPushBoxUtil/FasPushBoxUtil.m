#import "FasPushBoxUtil.h"
#import "FasViewManager.h"

#define PUSHBOX_PREF_MAIN_KEY    @"_PUSHBOX_MAIN_"
#define PUSHBOX_PREF_SYSTEM_KEY  @"_PUSHBOX_SYSTEM_"
#define PUSHBOX_DEVICE_TOKEN_KEY @"_DEVICE_TOKEN_"
#define PUSHBOX_UUID_KEY         @"_PUSHBOX_UUID_"
#define MQTT_PREF_SYSTEM_KEY     @"_MQTT_SYSTEM_"
#define MQTT_CLIENT_ID_KEY       @"_MQTT_CLIENT_ID_"


@implementation FasPushBoxUtil

static BOOL diagStat     = NO;
static BOOL continueDiag = NO;

- (id)init
{
	self = [super init];
	
	return self;
}


/**
 * 디바이스에 설정된 현재앱의 푸쉬설정 상태를 알수 있다.
 * - 참고 : IOS 5 이상에서는 알림센터가 생겨 알림처리 확인 방법이 많아짐
 *   ( 설정 > 알림 > [앱이름] 에 설정된 알림센터, 알림스타일(없음과 배너,알림), 아이콘에 알림표시(뱃지), 사운드(진동)
 *     중 하가지만 설정되어 있어도 알림을 받을수 있는 상태가 됨 )
 */
- (BOOL)isPushState
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.isPushState");
#endif

    BOOL isPushState;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        isPushState =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }else{
        isPushState = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }
#ifdef DEBUG
	NSString *strPushState = isPushState ? @"알림 켜짐":@"알림 꺼짐";
	NSLog(@"@FAS@|알림상태: %@", strPushState);
#endif
	return isPushState;
}


/**
 * 푸쉬설정에 대한 상세 내역을 로그에 보이게 한다.
 */
- (void)checkPushState
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.checkPushState");
#endif
/*
	UIRemoteNotificationType types =[[UIApplication sharedApplication] enabledRemoteNotificationTypes];

	NSLog(@"@FAS@| *** UIRemoteNotificationTypeAlert : %d",UIRemoteNotificationTypeAlert);
	NSLog(@"@FAS@| *** UIRemoteNotificationTypeBadge : %d",UIRemoteNotificationTypeBadge);
	NSLog(@"@FAS@| *** UIRemoteNotificationTypeNewsstandContentAvailability : %d",UIRemoteNotificationTypeNewsstandContentAvailability);
	NSLog(@"@FAS@| *** UIRemoteNotificationTypeNone : %d",UIRemoteNotificationTypeNone);
	NSLog(@"@FAS@| *** UIRemoteNotificationTypeSound : %d",UIRemoteNotificationTypeSound);
	NSLog(@"@FAS@| *** : %d",types);

	if(types == UIRemoteNotificationTypeAlert) {
	    NSLog(@"@FAS@| @@@@ : UIRemoteNotificationTypeAlert");
	}
	else if(types == UIRemoteNotificationTypeBadge) {
	    NSLog(@"@FAS@| @@@@ : UIRemoteNotificationTypeBadge");
	}
	else if(types == UIRemoteNotificationTypeNewsstandContentAvailability) {
	    NSLog(@"@FAS@| @@@@ : UIRemoteNotificationTypeNewsstandContentAvailability");
	}
	else if(types == UIRemoteNotificationTypeNone) {
	    NSLog(@"@FAS@| @@@@ : UIRemoteNotificationTypeNone");
	}
	else if(types == UIRemoteNotificationTypeSound) {
	    NSLog(@"@FAS@| @@@@ : UIRemoteNotificationTypeSound");
	}
	else {
	    NSLog(@"@FAS@| @@@@ : etc");
	}
*/
	// 앱을 실행 시켰을 때 푸시 알람 형태 활성화 설정 - 뱃지, 알림창, 사운드
	NSUInteger rntypes;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        rntypes =  [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }else{
        rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    }

	// 알림스타일 여부 ( 이 값이 0인 경우 알림 메세지가 보이지 않는다. )
	NSString *pushAlert = (rntypes & UIRemoteNotificationTypeAlert) ? @"enabled" : @"disabled";

	// 아이콘에 알림 표시 여부
	NSString *pushBadge = (rntypes & UIRemoteNotificationTypeBadge) ? @"enabled" : @"disabled";

	// 사운드 설정여부
	NSString *pushSound = (rntypes & UIRemoteNotificationTypeSound) ? @"enabled" : @"disabled";

	NSLog(@"@FAS@|pushAlert : %@",pushAlert);
	NSLog(@"@FAS@|pushBadge : %@",pushBadge);
	NSLog(@"@FAS@|pushSound : %@",pushSound);

//	[pushAlert release];
//	[pushBadge release];
//	[pushSound release];
}

/**
 * 동일 메시지 확인 용 체크
 */
- (BOOL)isLastPushMessage:(NSString*)milliSec
{
	if(milliSec != nil) {
		NSLog(@"isLastPushMessage milliSec not null");
		if([self getPushboxPrefSystemData:@"_T"] == nil) [self setPushboxPrefSystemData:@"0" forKey:@"_T"];
		
		NSLog(@"%lld < %lld : ?",[[self getPushboxPrefSystemData:@"_T"] longLongValue],[milliSec longLongValue]);
		
		
		
		if([[self getPushboxPrefSystemData:@"_T"] longLongValue] < [milliSec longLongValue]) {
			[self setPushboxPrefSystemData:milliSec forKey:@"_T"];
			NSLog(@"isLastPushMessage return  [ YES ]");
			return YES;
		}
		else {
			NSLog(@"isLastPushMessage return  [ NO ]");
			return NO;
		}
	}
	NSLog(@"isLastPushMessage milliSec null [ YES ]");
	return YES;
}


/**
 * 앱코드별 동일 메시지 확인 용 체크
 */
- (BOOL)isLastPushMessage:(NSString*)milliSec forAppCode:(NSString*)appCode
{
	if(milliSec != nil) {
		NSLog(@"isLastPushMessageforAppCode milliSec not null");
        NSLog(@"@FAS@|appCode = %@", appCode);
		
		if([self getPushboxPrefData:appCode forKey:@"_T"] == nil) [self setPushboxPrefData:appCode setData:@"0" forKey:@"_T"];
		
		NSLog(@"%lld < %lld : ?",[[self getPushboxPrefData:appCode forKey:@"_T"] longLongValue],[milliSec longLongValue]);

		if([[self getPushboxPrefData:appCode forKey:@"_T"] longLongValue] < [milliSec longLongValue]) {
			[self setPushboxPrefData:appCode setData:milliSec forKey:@"_T"];
			NSLog(@"isLastPushMessageforAppCode return  [ YES ]");
			return YES;
		}
		else {
			NSLog(@"isLastPushMessageforAppCode return  [ NO ]");
			return NO;
		}
	}
	NSLog(@"isLastPushMessageforAppCode milliSec null [ YES ]");
	return YES;
}

/**
 * 푸쉬박스용 디바이스토큰을 디바이스에 세팅한다.
 */
- (void)setDeviceToken:(NSString*)deviceToken appCode:(NSString*)appCode
{
	[self setPushboxPrefData:appCode setData:deviceToken forKey:PUSHBOX_DEVICE_TOKEN_KEY];
}


/**
 * 푸쉬박스용 디바이스토큰을 디바이스에서 가져온다.
 */
- (NSString*)getDeviceToken:(NSString*)appCode
{
    NSLog(@"FasPushBoxUtil - getDeviceToken appCode = %@", appCode);
    
	return (NSString*)[self NilToEmptyString:[self getPushboxPrefData:appCode
													forKey:PUSHBOX_DEVICE_TOKEN_KEY]];
}


/**
 * 푸쉬박스용 시스템데이터를 디바이스에 세팅한다.
 * setPushboxPrefData 이용하여 세팅한다.
 */
- (void)setPushboxPrefSystemData:(NSString*)aData forKey:(NSString*)sysKey
{
	[self setPushboxPrefData:PUSHBOX_PREF_SYSTEM_KEY setData:aData forKey:sysKey];
}


/**
 * 디바이스에서 푸쉬박스용 시스템데이터를 가져온다.
 * getPushboxPrefData 이용하여 세팅한다.
 */
- (NSString*)getPushboxPrefSystemData:(NSString*)sysKey
{
	return [self NilToEmptyString:[self getPushboxPrefData:PUSHBOX_PREF_SYSTEM_KEY
													forKey:sysKey]];
}


/**
 * MQTT용 시스템데이터를 디바이스에 세팅한다.
 * setPushboxPrefData 이용하여 세팅한다.
 */
- (void)setMqttPrefData:(NSString*)aData forKey:(NSString*)sysKey
{
	[self setPushboxPrefData:MQTT_PREF_SYSTEM_KEY setData:aData forKey:sysKey];
}


/**
 * 디바이스에서 MQTT용 시스템데이터를 가져온다.
 * getPushboxPrefData 이용하여 세팅한다.
 */
- (NSString*)getMqttPrefData:(NSString*)sysKey
{
	return [self NilToEmptyString:[self getPushboxPrefData:MQTT_PREF_SYSTEM_KEY
													forKey:sysKey]];
}


/**
 * 디바이스에 데이터를 저장한다.
 * ( 푸쉬박스 전용 )
 */
- (void)setPushboxPrefData:(NSString*)aRootKey setData:(NSString*)aData forKey:(NSString*)aKey
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.setPushboxPrefData");
#endif
	NSMutableDictionary* mapData;
	NSMutableDictionary* mapSubData;
	
	id mapDataTmp = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHBOX_PREF_MAIN_KEY];
	
	if (mapDataTmp == nil)
//		mapData = [[[NSMutableDictionary alloc] init] autorelease];
		mapData = [[NSMutableDictionary alloc] init];
	else
		mapData = [[NSMutableDictionary alloc] initWithDictionary:mapDataTmp];
	
	
	
	id mapSubDataTmp = [mapData objectForKey:aRootKey];
	
	if(mapSubDataTmp == nil)
//		mapSubData = [[[NSMutableDictionary alloc] init] autorelease];
		mapSubData = [[NSMutableDictionary alloc] init];
	else
		mapSubData = [[NSMutableDictionary alloc] initWithDictionary:mapSubDataTmp];
	
	
	[mapSubData setObject:aData
				   forKey:aKey];
	
	[mapData setObject:mapSubData
				forKey:aRootKey];
	
	[[NSUserDefaults standardUserDefaults] setObject:mapData forKey:PUSHBOX_PREF_MAIN_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
	/*
	 [mapData release];
	 [mapSubData release];
	 */
	
	
	
	
	/*
	 NSString *prefId = [NSString stringWithFormat:@"%@_%@", PUSHBOX_PREF_KEY, aAppCode];
	 
	 NSMutableDictionary* mapData;
	 
	 id mapDataTmp = [[NSUserDefaults standardUserDefaults] objectForKey:prefId];
	 
	 if (mapDataTmp == nil)
	 mapData = [[[NSMutableDictionary alloc] init] autorelease];
	 else
	 mapData = [[NSMutableDictionary alloc] initWithDictionary:mapDataTmp];
	 
	 [mapData setObject:aData
	 forKey:aKey];
	 
	 [[NSUserDefaults standardUserDefaults] setObject:mapData forKey:prefId];
	 [[NSUserDefaults standardUserDefaults] synchronize];
	 */
}


/**
 * 디바이스에 저장한 데이터를 가져온다.
 * ( 푸쉬박스 전용 )
 */
- (NSString*)getPushboxPrefData:(NSString*)aRootKey forKey:(NSString*)aKey
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.getPushboxPrefData");
#endif
	
	NSMutableDictionary* mapData;
	NSMutableDictionary* mapSubData;
	
	id mapDataTmp = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHBOX_PREF_MAIN_KEY];
	
	if (mapDataTmp == nil)
//		mapData = [[[NSMutableDictionary alloc] init] autorelease];
		mapData = [[NSMutableDictionary alloc] init];
	else
		mapData = [[NSMutableDictionary alloc] initWithDictionary:mapDataTmp];
	
	id mapSubDataTmp = [mapData objectForKey:aRootKey];
	
	if(mapSubDataTmp == nil)
//		mapSubData = [[[NSMutableDictionary alloc] init] autorelease];
		mapSubData = [[NSMutableDictionary alloc] init];
	else
		mapSubData = [[NSMutableDictionary alloc] initWithDictionary:mapSubDataTmp];
	
	return [mapSubData objectForKey:aKey];
}


/**
 * 디바이스에 저장한 데이터를 가져온다
 * ( 푸쉬박스 전용 )
 */
- (id)getPushBoxPrefAllData
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.logPushBoxPrefData");
#endif
	return [[NSUserDefaults standardUserDefaults] objectForKey:PUSHBOX_PREF_MAIN_KEY];
}


/**
 * 디바이스에 저장한 MQTT용 데이터를 가져온다
 * ( 푸쉬박스 전용 )
 */
- (id)getMqttPrefAllData
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.getMqttPrefAllData");
#endif
	return [[[NSUserDefaults standardUserDefaults] objectForKey:PUSHBOX_PREF_MAIN_KEY] objectForKey:MQTT_PREF_SYSTEM_KEY];
}


/**
 * 디바이스에 저장한 데이터를 로그로 찍는다.
 * ( 푸쉬박스 전용 )
 */
- (void)logPushBoxPrefData
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.logPushBoxPrefData");
#endif
	
#ifdef DEBUG
	
	NSLog(@"@FAS@|----------------------------------------------------------------------------");

	id mapDataTmp = [[NSUserDefaults standardUserDefaults] objectForKey:PUSHBOX_PREF_MAIN_KEY];
	
	NSLog(@"@FAS@|mapDataTmp : %@", mapDataTmp);

	NSLog(@"@FAS@|----------------------------------------------------------------------------");
/*
	NSString* keyTmp;
	NSString* kk;

	NSMutableDictionary* mapData;
	NSMutableDictionary* mapSubData;

	if (mapDataTmp == nil)
	mapData = [[[NSMutableDictionary alloc] init] autorelease];
	else
	mapData = [[NSMutableDictionary alloc] initWithDictionary:mapDataTmp];

	for(keyTmp in mapData) {
	    mapSubData = [mapData objectForKey:keyTmp];

	    if(mapSubData == nil)
	        mapSubData = [[[NSMutableDictionary alloc] init] autorelease];
	    else
	        mapSubData = [[NSMutableDictionary alloc] initWithDictionary:mapSubData];

	    for(kk in mapSubData)
	        NSLog(@"@FAS@|id : %@, key : %@, value : %@", keyTmp, kk, [mapSubData objectForKey:kk]);
	}

	 NSLog(@"@FAS@|----------------------------------------------------------------------------");
*/
#endif
}


/**
 * Device 정보를 추출해서 NSDictionary 저장한다.
 */
- (NSDictionary*)getDeviceInfo
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.getDeviceInfo");
#endif

	NSString *uuid = nil;

	if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
		// This is will run if it is iOS6
		uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
	} else {
		// This is will run before iOS6 and you can use openUDID or other
		// method to generate an identifier
		uuid = [self uniqueAppInstanceIdentifier];
	}
    
    NSString *localizedString = [[NSLocale currentLocale] localeIdentifier];
    NSString *localLang = [[localizedString componentsSeparatedByString:@"_"] objectAtIndex:0];
    if ([localLang rangeOfString:@"-"].location != NSNotFound)
    {
        localLang = [[localLang componentsSeparatedByString:@"-"] objectAtIndex:0];
    }

	
	// Device 정보를 추출해서 NSDictionary 저장한다.
/*
    NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
								   ,[[[UIDevice currentDevice] identifierForVendor] retain]  ,@"identifierForVendor"
								   ,[[[UIDevice currentDevice] systemVersion] retain]        ,@"systemVersion"
								   ,[[[UIDevice currentDevice] model] retain]                ,@"model"
								   ,[[[UIDevice currentDevice] name] retain]                 ,@"name"
								   ,[[[UIDevice currentDevice] systemName] retain]           ,@"systemName"
								   ,uuid                                                     ,@"uuid"
								   , nil];
*/
//	NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
//								   uuid                                                      ,@"uuid"
//								   ,[[[UIDevice currentDevice] systemVersion] retain]        ,@"systemVersion"
//								   ,[[[UIDevice currentDevice] model] retain]                ,@"model"
//								   ,[[[UIDevice currentDevice] name] retain]                 ,@"name"
//								   ,[[[UIDevice currentDevice] systemName] retain]           ,@"systemName"
//								   
//								   , nil];

    NSDictionary *deviceInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:
								   uuid                                                      ,@"uuid"
								   ,[[UIDevice currentDevice] systemVersion]        ,@"systemVersion"
								   ,[[UIDevice currentDevice] model]                ,@"model"
								   ,[[UIDevice currentDevice] name]                 ,@"name"
								   ,[[UIDevice currentDevice] systemName]           ,@"systemName"
								   , localLang                                      ,@"os_locale"
								   , nil];
    
#ifdef DEBUG
	// 디바이스 정보 가져오는 데이터 확인 로그
	NSLog(@"@FAS@|deviceInfoDic : %@",deviceInfoDic);
	//NSLog(@"@FAS@|identifierForVendor : %@",[[[UIDevice currentDevice] identifierForVendor] retain]);
	//NSLog(@"@FAS@|systemVersion : %@"      ,[[[UIDevice currentDevice] systemVersion] retain]);
	//NSLog(@"@FAS@|model : %@"              ,[[[UIDevice currentDevice] model] retain]);
	//NSLog(@"@FAS@|name : %@"               ,[[[UIDevice currentDevice] name] retain]);
	//NSLog(@"@FAS@|systemName : %@"         ,[[[UIDevice currentDevice] systemName] retain]);
#endif
	
	return deviceInfoDic;
}


- (NSString*) uniqueAppInstanceIdentifier
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    //static NSString* UUID_KEY = PUSHBOX_UUID_KEY;

    //NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
	NSString* app_uuid = [userDefaults stringForKey:PUSHBOX_UUID_KEY];
    if (app_uuid == nil)
    {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);

		app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
//        app_uuid = [NSString stringWithString:(NSString*)uuidString];
        [userDefaults setObject:app_uuid forKey:PUSHBOX_UUID_KEY];
        [userDefaults synchronize];

        CFRelease(uuidString);
        CFRelease(uuidRef);
    }

    return app_uuid;
}


- (BOOL)isOpenPushBox
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.isOpenPushBox");
#endif

	if([[FasViewManager getSharedInstance] getSubView] != nil) {
#ifdef DEBUG
		NSLog(@"@FAS@|open PushBox");
#endif
		return YES;
	}
	else
	{
#ifdef DEBUG
		NSLog(@"@FAS@|close PushBox!!");
#endif
		return NO;
	}
}


- (void)closePushBox
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.closePushBox");
#endif
	if([[FasViewManager getSharedInstance] getSubView] != nil)
	{
		[[FasViewManager getSharedInstance] removeSubView];
	}
}


- (void)alertBox:(NSString*)title message:(NSString*)msg buttonTitle:(NSString*)btn
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													 message:msg
													delegate:nil
										   cancelButtonTitle:btn
										   otherButtonTitles:nil];
	[alert show];

	// 버튼 누르기전까지 지연.
	//while (alert.hidden == NO && alert.superview != nil)
	while (alert.hidden == NO && !continueDiag)
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
	
//	[alert release];

    continueDiag = NO;
}


- (BOOL)confirmBox:(NSString*)title message:(NSString*)msg cancelButtonTitle:(NSString*)cancelBtn okButtonTitle:(NSString*)okBtn
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:self
										  cancelButtonTitle:cancelBtn
										  otherButtonTitles:okBtn,nil];
	[alert show];
	
	// 버튼 누르기전까지 지연.
	//while (alert.hidden == NO && alert.superview != nil && !continueConfirm)
	while (alert.hidden == NO && !continueDiag)
		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
	
//	[alert release];

    continueDiag = NO;

	return diagStat;
}


- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0) // 확인 ( 첫번째 버튼 )
	{
		diagStat = YES;
	}
	else // buttonIndex == 1 // 취소 ( 두번째 버튼 )
	{
		diagStat = NO;
	}

    continueDiag = YES;
}


- (NSString*)NilToEmptyString:(NSString*)str
{
	return (str != nil) ? str : @"";
}


- (void)setBadge:(NSInteger)badgeNumber
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.setBadge");
#endif
	[UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
}


- (void)upCountBadge
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.upCountBadge");
#endif
	[UIApplication sharedApplication].applicationIconBadgeNumber++;
}


- (void)downCountBadge
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasPushBoxUtil.downCountBadge");
#endif
	if([UIApplication sharedApplication].applicationIconBadgeNumber > 0) {
		[UIApplication sharedApplication].applicationIconBadgeNumber--;
	}
}


- (void)dealloc
{
//    [super dealloc];
}


@end