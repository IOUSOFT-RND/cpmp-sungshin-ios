
//  AppProgressCustomize.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//
//  FasNIFGap 1.4.5 에 최적화 되어 있음
//

#import <CommonCrypto/CommonDigest.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "KeyDefine.h"
#import "ServerIndexEnum.h"
#import "AppProgressCustomize.h"
#import "FasNFIGap.h"
#import "FasPushBoxUtil.h"
#import "FasMQTTClient.h"
#import "MQTTAppDelegate.h"
#import "FasPushSettings.h"
#import "FasPushControl.h"
#import "FasViewManager.h"
#import "FNPPushBox.h"

/**
 * 프로젝트 마다 환경 설정에 따라 수정한다.
 */
// @@FAS@@ - 앱 설정 시작
#define ALERT_TITLE         @"나사렛 대학교"
#define ALERT_MSG           @"메세지가 도착했습니다."
#define ALERT_BUTTON1       @"확인"
#define ALERT_BUTTON2       @"취소"
#define JS_FUNC_HASPUSH     @"hasPush"

#define APPCODE         @"99" // 앱 코드
//#define MQTT_SERVER       @"http://116.68.32.26:/knu/queryClient.do"

// @@FAS@@ - 앱 설정 끝

static FasPushControl* fasPushControl = nil;

@implementation AppProgressCustomize


- (id)init
{
    self = [super init];
    
    alertStat = NO;
    
    fasPushControl = [FasPushControl getSharedInstance];
    [[NSUserDefaults standardUserDefaults] setObject:APPCODE forKey:@"appcode"];
    [[NSUserDefaults standardUserDefaults] setObject:SERVER_QueryClient forKey:@"url_subscribe"];
    [[NSUserDefaults standardUserDefaults] setObject:SERVER_QueryClientBox forKey:@"url_message"];
    
    mainView = nil;
    
    return self;
}

- (void)setMainView:(UIWindow*)uiWindow
{
    [fasPushControl setMainView:uiWindow];
    
}

-(void)MQTTInfoSetting
{
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setMqttPrefData:@"true" forKey:@"enabled"];
    [fpbu setMqttPrefData:@"mdm.sekorea.kr" forKey:@"host"];
    [fpbu setMqttPrefData:@"1883" forKey:@"port"];
    [fpbu setMqttPrefData:@"" forKey:@"username"];
    [fpbu setMqttPrefData:@"" forKey:@"password"];
    [fpbu setMqttPrefData:@"false" forKey:@"clean_session"];
    [fpbu setMqttPrefData:@"false" forKey:@"use_ssl"];
    [fpbu setMqttPrefData:@"" forKey:@"lwt_topic"];
    [fpbu setMqttPrefData:@"" forKey:@"lwt_msg"];
    [fpbu setMqttPrefData:@"2" forKey:@"qos"];
    [fpbu release];

}

- (void)vibrate
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback  error:&err];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

/**
 * 앱 실행 중 백그라운드 모드에 들어갈때 실행되는 부분
 * 메인 델리게이터에서 사용하는 이름과 똑같은 이름을 사용함
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.applicationDidEnterBackground");
#endif
    // 앱이 백그라운드 모드에서 돌아올때 문제가 발생할 데이터를 백그라운드 모드로 들어갈때 초기화한다. ( 푸쉬보관함 확인용 데이터 )
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setPushboxPrefSystemData:@"" forKey:@"_H"];
    [fpbu release];
}


/**
 * 앱 실행 중 백그라운드 모드에서 다시 실행될때 실행되는 부분
 * 메인 델리게이터에서 사용하는 이름과 똑같은 이름을 사용함
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.applicationWillEnterForeground");
#endif
    // 앱이 백그라운드 모드에서 돌아오면 푸쉬 보관함 확인용 데이터를 초기화한다. ( 푸쉬보관함 확인용 데이터 )
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setPushboxPrefSystemData:@"" forKey:@"_H"];
    [fpbu setBadge:0];   // 아이콘 뱃지의 카운트를 0으로 리셋
    [fpbu release];
    
}


/**
 * Local Push를 받을 떄 호출되는 메소드
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.didReceiveLocalNotification");
#endif
}


/**
 * APNS 에서 메세지를 받으면 호출 - 앱이 종료 상태에 있는데 알림이 왔을 경우 아래 메소드에서 launchOptions 값이 유무를 가지고 처리
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.didFinishLaunchingWithOptions");
#endif
    
    //    [fasPushControl openPushBox];
    // 앱이 시작 될때가 발생할 데이터를 초기화한다. ( 푸쉬보관함 확인용 데이터 )
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setPushboxPrefSystemData:@"" forKey:@"_H"];

    // MQTT delegate 설정
//    [[FasMQTTClient getSharedInstance] setDelegate:[[MQTTAppDelegate alloc] init]];
//    [self MQTTInfoSetting];
//    [[FasMQTTClient getSharedInstance] subscribe];
//    [[FasMQTTClient getSharedInstance] connect];
    
    // 아이콘 뱃지의 카운트를 0으로 리셋
    //application.applicationIconBadgeNumber = 0;
    
    // 알림을 받고 앱이 실행되었을때 launchOptions 파라메터에 메세지 정보가 넘어 온다.
    NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    NSLog(@"@FAS@|pushInfo = %@", pushInfo);
    NSLog(@"@FAS@|userInfo = %@", pushInfo);
    
    
    if(pushInfo != nil)
    {
        
        [self initPush];
        
        // 결과를 보낸다! ( 결과처리 3개중 첫번째 - APNS 받은 결과 전송 )
        [[FasMQTTClient getSharedInstance] publishResultData:[NSString stringWithFormat:@"%@|%@", @"APNS", [pushInfo objectForKey:@"_T"]]
                                                     onTopic:[fpbu getPushboxPrefData:APPCODE forKey:@"MqttResultTopic"]];
        
        // launchOptions값이 있으면 푸시로 앱이 실행된 경우 이기 때문에 별도 처리 메소드에 값을 넘겨줌.
        //[self application:application didReceiveRemoteNotification:pushInfo];
        [fpbu downCountBadge];
        [self application:application procNotification:pushInfo];

    }
    [fpbu setBadge:0];
    [fpbu release];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //이 메소드를 호출 하는 메소드에서 다음 화면으로 넘어 가지 않을 경우 아래 메소드를 넣어 준다. ( 이 라이브러리에서는 주석을 풀면 안됨 참고용임 )
    //BOOL bReturn = [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    if (![fasPushControl initCompleted])
    {
        [self initPush];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [fasPushControl subscribe];
        });
        
    }
}

/**
 * APP이 종료 될 당시 호출되는 메소드 - 종료되기전 초기화 및 정리 작업
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_logOut object:nil];
}


/**
 * APNS 에서 메세지를 받으면 호출 - 앱이 실행 중에 알림이 왔을 경우 아래 메소드가 실행됨
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.didReceiveRemoteNotification");
#endif
    
    //[UIApplication sharedApplication].applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1;
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:APNS_SETTING_Vibrate] != nil)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:APNS_SETTING_Vibrate] boolValue])
        {
             [self vibrate];
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:APNS_SETTING_Rington] != nil)
    {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:APNS_SETTING_Vibrate] boolValue])
        {
            AudioServicesPlaySystemSound (1322);
        }
    }
    
    
    // 앱 실행중이라 얼럿창 띄워준다.
    NSDictionary    *apsDic   = [userInfo objectForKey:@"aps"];
    NSString        *strMsg   = (NSString *)[apsDic objectForKey:@"alert"];
    //NSString        *strBadge = [apsDic objectForKey:@"badge"];
    
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setBadge:0];
    //[fpbu setBadge:[strBadge intValue]];
    

    
    // 결과를 보낸다! ( 결과처리 3개중 두번째 - APNS 받은 결과 전송 )
    [[FasMQTTClient getSharedInstance] publishResultData:[NSString stringWithFormat:@"%@|%@", @"APNS", [userInfo objectForKey:@"_T"]]
                                                 onTopic:[fpbu getPushboxPrefData:APPCODE forKey:@"MqttResultTopic"]];
    [fpbu isLastPushMessage:[userInfo objectForKey:@"_T"] forAppCode:APPCODE];
    
    
    BOOL confirm = [fpbu confirmBox:ALERT_TITLE message:strMsg cancelButtonTitle:ALERT_BUTTON1 okButtonTitle:ALERT_BUTTON2];
    if(confirm)
        [self application:application procNotification:userInfo];
    
//    if( application.applicationState == UIApplicationStateActive)
//    {
//        // app was already in the foreground
//
//    }
//    else
//    {
//        // app was just brought from background to foreground
//        //if(![fpbu isOpenPushBox]) {
//        [self application:application procNotification:userInfo];
//        //}
//    }
    
    [fpbu release];
}


- (void)application:(UIApplication *)application procNotification:(NSDictionary *)userInfo
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.procNotification");
#endif
    
    // 푸쉬로 날아온 데이터 중 _H(Hidden Data)를 추출한다.
    NSString *hiddenData = [userInfo objectForKey:@"_H"];
    NSString *milliSec   = [userInfo objectForKey:@"_T"];
    
    NSLog(@"@FAS@|AppProgressCustomize.procNotification hiddenData : %@",hiddenData);
    NSLog(@"@FAS@|AppProgressCustomize.procNotification milliSec : %@",milliSec);
    
    // WebView에서 Fpns.FasGap.hasMessage를 호출 하기전에 데이터를 세팅한다.
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setPushboxPrefSystemData:hiddenData forKey:@"_H"];
    [fasPushControl getLastDetail];
    
    [fpbu release];
}


/**
 * APNS 토큰 값 받을시 호출
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.didRegisterForRemoteNotificationsWithDeviceToken");
#endif
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    // UDID 32자리
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    //self.strMyToken = deviceId;
    
    NSLog(@"@FAS@|Device Token : %@", deviceId);
    
    // 디바이스 토큰을 디바이스에 세팅한다!
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setDeviceToken:deviceId appCode:APPCODE];
    [fpbu release];
}


/**
 * APNS 토큰 값 못 받을시 호출
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
#ifdef DEBUG
    NSLog(@"@FAS@|AppProgressCustomize.didFailToRegisterForRemoteNotificationsWithError");
#endif
    NSLog(@"@FAS@|Could not register for remote notifications: %@", error);
}

- (void)initPush
{
    [self initPush:[self getCno]];
}


- (NSString *)getCno
{
    UIDevice *device = [UIDevice currentDevice];
    NSUUID *uuid = device.identifierForVendor;
    
    const char *s=[uuid.UUIDString cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    NSLog(@"cno len = %d",[hash length]);
    //    NSString *hash = @"01038169496";
    
    NSLog(@"Cno = %@",hash);
    return hash;
}

- (void)initPush:(NSString*)cno
{
    if (fasPushControl == nil)
        fasPushControl = [FasPushControl getSharedInstance];
    
    [fasPushControl initPush:APPCODE urlSubscribe:SERVER_QueryClient urlMessage:SERVER_QueryClientBox fasPushCallback:[[FasPushCallback alloc]init]];
}

- (void)openPushBox
{
}

- (void)dealloc
{
    [super dealloc];
}


@end