//
//  FasPushControl.m
//  FasNFIGap
//
//  Created by etyoul on 2014. 4. 28..
//  Copyright (c) 2014년 fasolution. All rights reserved.
//

#import "FasPushControl.h"
#import "NFIMsg.h"
#import "FNPPushBox.h"
#import "FasPushBoxUtil.h"
#import "FasPushBoxController.h"
#import "FasSBJSON.h"

@implementation FasPushControl

@synthesize target;
@synthesize selector;

static FasPushControl* fasPushControl = nil;
UIWebView *pushWebView = nil;
UIWindow* mainWindow = nil;
UIView* mainView = nil;

- (id) init
{
    self = [super init];
    
    fasPushCallback = nil;
    initialized = false;
    fasPushSettings = nil;
    
    return self;
}

// ARC 사용하는 경우 dealloc 사용 안함
- (void) dealloc
{
//    [fasPushCallback dealloc];
//    [fasPushSettings dealloc];
//    
//    [super dealloc];
}

// for Sington
+ (FasPushControl*) getSharedInstance
{
    if (fasPushControl == nil) {
        @synchronized(self)
        {
            fasPushControl = [[FasPushControl alloc] init];
        }
    }
    
    return fasPushControl;
}

// 데이터 전달을 위한 메인 윈도우 등록
- (void)setMainWindow:(UIWindow*)uiWindow {
    mainWindow = uiWindow;
}

// 데이터 전달을 위한 메인 뷰 등록
- (void)setMainView:(UIView*)uiView {
    mainView = uiView;
}

- (void) setCallback:(FasPushCallback*)pushCallback
{
    fasPushCallback = pushCallback;
}

// 라이브러리 초기화
// 파라미터 : 앱코드, 기기등록 URL, 메시지 URL
- (void) initPush:(NSString*)apdc urlSubscribe:(NSString*)urlSubscribe urlMessage:(NSString*)urlMessage
{
        NSLog(@"@FAS@|Push Setting Data is APPCODE : %@, URL_SUBSCRIBE : %@, URL_MESSAGE : %@", apdc, urlSubscribe, urlMessage);
    if ([apdc isEqualToString:@""] || [urlSubscribe isEqualToString:@""] || [urlMessage isEqualToString:@""]) {
        NSLog(@"@FAS@|Push Setting Data must be set!");
        return;
    }
    
    fasPushSettings = [FasPushSettings getSharedInstance];
    [fasPushSettings setSettings:apdc urlSubscribe:urlSubscribe urlMessage:urlMessage];
    
    initialized = true;
}

// 라이브러리 초기화
// 파라미터 : 앱코드, 기기등록 URL, 메시지 URL, callback
- (void) initPush:(NSString*)apdc urlSubscribe:(NSString *)urlSubscribe urlMessage:(NSString *)urlMessage fasPushCallback:(FasPushCallback*)pushCallback
{
    NSLog(@"@FAS@|Push Setting Data is APPCODE : %@, URL_SUBSCRIBE : %@, URL_MESSAGE : %@", apdc, urlSubscribe, urlMessage);
    [self initPush:apdc urlSubscribe:urlSubscribe urlMessage:urlMessage];
    [self setCallback:pushCallback];
}


// 고객번호 등록
- (void) setCno:(NSString*)cno
{
    [self setUserInfo:cno custId:@""];
}

// 고객 ID 등록
- (void) setCustId:(NSString*)custId
{
	FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc]init];
    NSString* cno = [fpbu getPushboxPrefData:[fasPushSettings getAppCode] forKey:@"cno"];
    
    [self setUserInfo:cno custId:custId];
}

// 고객번호, 고객ID 등록
- (void) setUserInfo:(NSString*)cno custId:(NSString*)custId
{
    
    if (initialized) {
        NFIMsg* msg = [self getNFIMsg];
        
        NSLog(@"@FAS@|APPCODE in NFIMsg : %@", [msg getArg:@"app_code"]);
    
        [msg setArg:@"cno" value:cno];
        [msg setArg:@"user_id" value:custId];
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        [pushBox setUserInfo:msg];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// 기기등록여부 확인
- (void) isSubscribe
{
    if (initialized) {
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        [pushBox isSubscribe:[self getNFIMsg]];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// 기기등록
- (void)subscribe
{
    if (initialized) {
        
        NFIMsg* msg = [self getNFIMsg];
        [msg setArg:@"overwrite_user" value:@"true"];
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        
        [pushBox subscribe:msg];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
    
}

// 수신거부
- (void)unSubscribe
{
    
    if (initialized) {
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        [pushBox unSubscribe:[self getNFIMsg]];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
    
}

// MQTT 초기화
- (void)initMqttClient:(NFIMsg*)msg
{
    
    if (initialized) {
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        [pushBox initMqttClient:msg];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// MQTT 접속 및 topic 등록
- (void)setMqttClient
{
    
    if (initialized) {
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
        [pushBox setMqttClient:[self getNFIMsg]];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// 기본 NFI 메시지 생성 (Native 또는 서버 통신을 사용하는 메시지)
- (NFIMsg*)getNFIMsg
{
    NFIMsg* msg = [[NFIMsg alloc] init];

    [msg setArg:@"app_code" value:[fasPushSettings getAppCode]];
    [msg setArg:@"url" value:[fasPushSettings getServerUrlSubscribe]];
//    [msg autorelease];
    
    return msg;
}

/**
 * 보관함 열기
 */
- (void) openPushBox
{
    [self openPushBox:@"pushbox.html"];
}

- (void) openSettings
{
    [self openPushBox:@"setting.html"];
}

- (void) openPushBox:(NSString*)page
{
    if (mainWindow == nil)
        mainWindow = [[[UIApplication sharedApplication]windows]lastObject];
//    mainWindow = [[[UIApplication sharedApplication] delegate] window];
    
    if ([page isEqualToString:@""]) page = @"pushbox.html";
    
    
    NFIMsg* msg = [self getNFIMsg];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *pushboxPath = [NSString stringWithFormat:@"%@/www/push/html", [mainBundle bundlePath]];
    NSString *pushboxPath = [mainBundle pathForResource:@"www/push/html" ofType:@""];
    
    [msg setCustArg:@"fileWWWPath" value:pushboxPath];
    [msg setArg:@"url" value:page];
    
//    FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback ];
    FNPPushBox* pushBox = [[FNPPushBox alloc] init:mainWindow delegate:fasPushCallback];

    [pushBox startView:msg];
//    [pushBox show];
//    [pushBox autorelease];

//    
//    
//    CGRect bounds = [mainView bounds];
//    CGRect webFrame = CGRectMake(bounds.origin.x, bounds.origin.y+20, bounds.size.width, bounds.size.height-20);
//
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *pushboxPath = [mainBundle pathForResource: @"www/push/html/pushbox" ofType: @"html"];
//    
//    
//    FNPPushBox* pushBox = [[FNPPushBox alloc] init:fasPushCallback];
//    [pushBox openPushBox:pushboxPath];
//
    
    
//    FasPushBoxController* fasPushBoxController = [[FasPushBoxController alloc]initWithNibName:@"FasPushBoxController" bundle:nil];
//    [fasPushBoxController setBound:webFrame];
//    [fasPushBoxController setUrlLink:pushboxPath];
//    [fasPushBoxController setParentView:mainView];
//    [fasPushBoxController loadView];
//
//    mainView.window.rootViewController = fasPushBoxController;
    
//    // 푸시보관함용 웹뷰를 메인뷰에 추가
//    CGRect bounds = [[UIScreen mainScreen] bounds];
//    CGRect webFrame = CGRectMake(bounds.origin.x, bounds.origin.y+20, bounds.size.width, bounds.size.height-20);
//	
//    pushWebView = [[UIWebView alloc] initWithFrame:webFrame];
//    
//	pushWebView.autoresizesSubviews = YES;
//	pushWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
//	
//    //    [pushWebView setHidden:true];
//    
//    NSBundle *mainBundle = [NSBundle mainBundle];
//    NSString *pushboxPath = [mainBundle pathForResource: @"www/push/html/pushbox" ofType: @"html"];
//    //    NSString *pushboxPath = [mainBundle pathForResource: @"pushbox" ofType:@"html"];
//    
//    NSLog(@"========================================");
//    NSLog(@"pushbox path = %@", pushboxPath);
//    NSLog(@"========================================");
//    
//    
//    NSURL *url = [NSURL fileURLWithPath:pushboxPath];
//    
//    
//    //    [pushWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pushboxPath]]];
//    
//    [pushWebView loadRequest:[NSURLRequest requestWithURL:url]];
//    //    [pushWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]]];
//    [pushWebView setHidden:NO];
//    pushWebView.scalesPageToFit = YES;
//    
//    pushWebView.autoresizesSubviews = YES;
//    pushWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);;
//    
//    [mainView addSubview:pushWebView];
    
}

// iOS는 푸시 payload가 256byte로 제한되어 MSGID를 담을 수 없음
// 따라서 푸시 수신 후 해당 메시지의 추가정보를 가져오기 위해 해당 앱으로 전송된 마지막 메시지를 가져옴
- (void)getLastDetail
{
#ifdef DEBUG
    NSLog(@"FasPushControl.getLastDetail");
#endif
    if (initialized) {
 
        FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
        
        NSString* appCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"appcode" ];
        NSString* url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url_message" ];
        
        NSString* cno = [fpbu getPushboxPrefData:appCode forKey:@"cno"];
        NFIMsg* msg = [self getNFIMsg];
        [msg setCommand:@"getLastDetail"];
        [msg setArg:@"url" value:url];
        [msg setArg:@"cno" value:cno];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"id"])
        {
            [msg setArg:@"id" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"base64id"]];
            [msg setArg:@"pw" value:[[NSUserDefaults standardUserDefaults] objectForKey:@"base64pw"]];
        }

        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:self];

        [pushBox requestHttp:msg];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// 뱃지 카운트 조회
- (void)getBadge
{
#ifdef DEBUG
    NSLog(@"FasPushControl.getBadge");
#endif
    if (initialized) {
        
        FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
        
        NSString* appCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"appcode" ];
        NSString* url = [[NSUserDefaults standardUserDefaults] valueForKey:@"url_message" ];
        
        NSString* cno = [fpbu getPushboxPrefData:appCode forKey:@"cno"];
        NFIMsg* msg = [self getNFIMsg];
        [msg setCommand:@"getBadge"];
        [msg setArg:@"url" value:url];
        [msg setArg:@"cno" value:cno];
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"id"])
        {
            [msg setArg:@"id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"base64id"]];
            [msg setArg:@"pw" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"base64pw"]];
        }

        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:self];
        
        [pushBox requestHttp:msg];
        //        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }
}

// 푸시 수신 여부를 서버로 전송
- (void)sendDeviceReceived:(NSString*)msgId
{
    if (initialized) {
        
        NFIMsg* msg = [self getNFIMsg];

        [msg setCommand:@"receiveDevice"];
        [msg setArg:@"msg_id" value:msgId];
        [msg setArg:@"retry_cnt" value:@"1"];
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"id"])
        {
            [msg setArg:@"id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"base64id"]];
            [msg setArg:@"pw" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"base64pw"]];
        }
        
        FNPPushBox* pushBox = [[FNPPushBox alloc] init:self];
        
        [pushBox requestHttp:msg];
//        [pushBox autorelease];
    } else {
        NSLog(@"fPMS is not initialized!");
    }

    
}

// Native 또는 서버로부터 결과 수신 후 처리
- (void)didReceiveFinished:(NSString *)result
{
    NSLog(@"didReceiveFinished =%@",result);
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    id resultObj = [jsonParser objectWithString:result];
    
    NSString* command = [resultObj valueForKey:@"CMD"];

    if ([command isEqualToString:@"getLastDetail"]) {
        
        NSObject* data = [resultObj objectForKey:@"DATA"];
        
        NSString* msgId = [data valueForKey:@"MSG_ID"];
        
        if ([[data valueForKey:@"MSG_ID"] length] == 0) {
            NSLog(@"FasPushControl.didReceiveFinished : msgId nil");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GetLastDetail" object:data];
        
        [self sendDeviceReceived:msgId];
        
        
    } else if ([command isEqualToString:@"getBadge"]) {

        NSLog(@"FasPushControl.didReceiveFinished : command =  getBadge Enter");

        NSObject* data = [resultObj objectForKey:@"DATA"];
        NSString* badge = [data valueForKey:@"badge"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BadgeCountNotification" object:badge];
        
    } else if ([command isEqualToString:@"receiveDevice"]) {

    }




}

// URL타입의 푸시메시지 확인버튼 터치시 해당 URL 전달
// NSNotificationCenter를 이용
- (void)moveToLandingUrl:(NSString*)url
{
#ifdef DEBUG
    NSLog(@"moveToLandingUrl : url = %@", url);
#endif
    
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    FNPPushBox* pushBox = [[FNPPushBox alloc] init:mainWindow delegate:fasPushCallback];
    [pushBox endView];
    
//    NSURL *urls = [NSURL URLWithString:url];
//    NSURLRequest* requestObj = [NSURLRequest requestWithURL:urls];
//    [(UIWebView*)mainView loadRequest:requestObj];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WebViewNotification" object:url];
    
}

// 앱의 특정 페이지로 이동
- (void)moveToAppPage:(NSString*)msgId
{
    
#ifdef DEBUG
    NSLog(@"moveToAppPage : msgId = %@", msgId);
#endif
    
    msgId = [msgId stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    FNPPushBox* pushBox = [[FNPPushBox alloc] init:mainWindow delegate:fasPushCallback];
    [pushBox endView];
    
    //    NSURL *urls = [NSURL URLWithString:url];
    //    NSURLRequest* requestObj = [NSURLRequest requestWithURL:urls];
    //    [(UIWebView*)mainView loadRequest:requestObj];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppPageByNotification" object:msgId];
    
}


// 라이브러리 초기화 여부
- (BOOL)initCompleted
{
    return initialized;
}



@end
