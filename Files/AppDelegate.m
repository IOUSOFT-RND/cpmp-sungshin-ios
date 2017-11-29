//
//  AppDelegate.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 20..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "LUKeychainAccess.h"
#import "AppDelegate.h"
#import "StringEnumDef.h"
#import "FasPushBoxUtil.h"
#import "UISidebarViewController.h"
#import "SimpleLoginViewController.h"
#import "CustomActionSheetViewController.h"
#import "MessageBordViewController.h"
#import "WebViewController.h"
#import "HomeViewController.h"
#import "db/DbProvider.h"
#import "ServiceDb.h"
#import "LogInViewController.h"

#import "FasPushControl.h"
#import "FasPushCallback.h"

#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "ServerIndexEnum.h"
#import "Json.h"
#import "EnumDef.h"
#import "StringEnumDef.h"
#import "AESHelper.h"

@interface AppDelegate ()
{
    BOOL apnsPopupNon;
    UIViewController *siderbarCtl;
    UINavigationController *navVC;
    NSString *SideBarType;
}

@end

@implementation AppDelegate
@synthesize misLogin,sidebarVC,webViewCtl,customViewCtl,MessageCtl,mSimpleLogin,wbCtl,misSubScribe,userType;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    misSubScribe =false;
    
    NSDictionary *appPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *changeCount = [appPlist objectForKey:@"DbChangeCount"];
    if ([self DatabaseChangeCountCheck:changeCount])
    {
        [ DbProvider AllDeleteDb];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:SERVER_QueryClientBox forKey:@"url_message"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddMessageViewFormWindowRootView) name:@"MessageViewAdd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewChange) name:@"LoginViewChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddSubcriveViewErrorPopUpFormWindowRootView) name:@"SubcreiveConnectError" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLastMessage:) name:@"GetLastDetail" object:nil];
    
    [DbProvider createDb];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
    {
        self.misLogin = YES;
    }
    else
    {
        self.misLogin = NO;
    }
    
    //Push
    // APNS에 디바이스를 등록한다.
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"apns_setting"] == nil ||
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_setting"] isEqualToString:@"true"])
    {
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIUserNotificationSettings *settings;
            settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |
                                                                     UIUserNotificationTypeAlert |
                                                                     UIUserNotificationTypeBadge ) categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |  UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound ];
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIUserNotificationSettings *settings;
            settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeNone categories:nil];
            
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeNone];
        
    }
    
    //push로 실행
    NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (pushInfo) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
        {
            apnsPopupNon = true;
            FasPushControl *fasCtl = [FasPushControl getSharedInstance];
            [fasCtl initPush:APPCODE urlSubscribe:SERVER_QueryClient urlMessage:SERVER_QueryClientBox fasPushCallback:[[FasPushCallback alloc]init]];
            [fasCtl getLastDetail];
        }
        
        // UIApplicationLaunchOptionsURLKey
        // 이키는 앱이 꺼져있다가 켜도 바로 url 로 인식하여 들어감.
    }
    
    application.applicationIconBadgeNumber = 0;

    iphone = [UIStoryboard storyboardWithName:@"Storyboard-common" bundle:nil];
//    iphone = [UIStoryboard storyboardWithName:@"Storyboard3.5Inch" bundle:nil];
//    iphone4Inch = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    iphone4_7Inch = [UIStoryboard storyboardWithName:@"Storyboard4.7Inch" bundle:nil];
//    iphone5_5Inch = [UIStoryboard storyboardWithName:@"Storyboard5.5Inch" bundle:nil];
    //    UIStoryboard *iPad = [UIStoryboard storyboardWithName:@"iPadStoryboard" bundle:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if([[UIScreen mainScreen] bounds].size.height <= 600.0)
        {
           //iphone = [UIStoryboard storyboardWithName:@"Storyboard-small" bundle:nil];
        }
//        if ([[UIScreen mainScreen] bounds].size.height == 568.0)
//        {
//            self.window.rootViewController = [iphone4Inch instantiateInitialViewController];
//            customViewCtl = [iphone4Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//            MessageCtl = [iphone4Inch instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
//            wbCtl = [iphone4Inch instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
//        }
//        else if([[UIScreen mainScreen] bounds].size.height == 480.0)
//        {
//            self.window.rootViewController = [iphone instantiateInitialViewController];
//            customViewCtl = [iphone instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//            MessageCtl = [iphone instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
//            wbCtl = [iphone instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
//        }
//        else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
//        {
//            self.window.rootViewController = [iphone4_7Inch instantiateInitialViewController];
//            customViewCtl = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//            MessageCtl = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
//            wbCtl = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
//        }
//        else
//        {
//            self.window.rootViewController = [iphone5_5Inch instantiateInitialViewController];
//            customViewCtl = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//            MessageCtl = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
//            wbCtl = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
//        }
        
        self.window.rootViewController = [iphone instantiateInitialViewController];
        customViewCtl = [iphone instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
        MessageCtl = [iphone instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
        wbCtl = [iphone instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
    }

    
    return YES;
}

//- (void)savePushData:(NSDictionary *)dictionary application:(UIApplication *)application
//{
//    DLog(@"dictionary description : %@", [dictionary description]);
//    application.applicationIconBadgeNumber = 0;
//    
//    if(dictionary && [[UserData sharedUserData] LOGON]){
//        // 1초후 실행
//        [self performSelector:@selector(goPushPage:) withObject:dictionary afterDelay:1.0];
//    }
//}

-(void)LoginViewChange
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *LoginView;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
//                if ([[UIScreen mainScreen] bounds].size.height == 568.0)
//                {
//                    LoginView = [iphone4Inch instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                }
//                else if([[UIScreen mainScreen] bounds].size.height == 480.0)
//                {
//                    LoginView = [iphone instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                }
//                else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
//                {
//                    LoginView = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                }
//                else
//                {
//                    LoginView = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"LogInViewController"];
//                }
                LoginView = [iphone instantiateViewControllerWithIdentifier:@"LogInViewController"];
            }
    
            [(LogInViewController *)LoginView setMIsOverwrite:true];
            self.window.rootViewController = LoginView;
        });
    });
}


-(void)windowRootViewChange
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"SideMenuTemplet"] == nil ||
               [[[NSUserDefaults standardUserDefaults] objectForKey:@"SideMenuTemplet"] isEqualToString:@"1"])
                SideBarType = @"SideMenuTableCtl";
            else
                SideBarType = @"SideMenuCollectionCtl";
            
            UIViewController *naviRoot;
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
//                if ([[UIScreen mainScreen] bounds].size.height == 568.0)
//                {
//                    navVC = [iphone4Inch instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
//                    siderbarCtl = [iphone4Inch instantiateViewControllerWithIdentifier:SideBarType];
//                    [siderbarCtl.view setFrame:CGRectMake(0, 0, 270, 568)];
//                    [siderbarCtl.view setBounds:CGRectMake(0, 0, 270, 568)];
//                }
//                else if([[UIScreen mainScreen] bounds].size.height == 480.0)
//                {
//                    naviRoot = [iphone instantiateViewControllerWithIdentifier:@"HomeViewController"];
//
//                    navVC = [iphone instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
//                    [navVC setViewControllers:[[NSArray alloc] initWithObjects:naviRoot, nil]];
//
//                    siderbarCtl = [iphone instantiateViewControllerWithIdentifier:SideBarType];
//                    [siderbarCtl.view setFrame:CGRectMake(0, 0, 270, 480)];
//                    [siderbarCtl.view setBounds:CGRectMake(0, 0, 270, 480)];
//                }
//                else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
//                {
//                    navVC = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
//                    siderbarCtl = [iphone4_7Inch instantiateViewControllerWithIdentifier:SideBarType];
//                    [siderbarCtl.view setFrame:CGRectMake(0, 0, 324, 667)];
//                    [siderbarCtl.view setBounds:CGRectMake(0, 0, 324, 667)];
//                }
//                else
//                {
//                    navVC = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
//                    siderbarCtl = [iphone5_5Inch instantiateViewControllerWithIdentifier:SideBarType];
//                    [siderbarCtl.view setFrame:CGRectMake(0, 0, 330, 736)];
//                    [siderbarCtl.view setBounds:CGRectMake(0, 0, 330, 736)];
//                }
                
                
                navVC = [iphone instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
                siderbarCtl = [iphone instantiateViewControllerWithIdentifier:SideBarType];
                [siderbarCtl.view setFrame:CGRectMake(0, 0, 270, 480)];
                [siderbarCtl.view setBounds:CGRectMake(0, 0, 270, 480)];
            }
            //            else
            //            {
            //                navVC = [iPad instantiateViewControllerWithIdentifier:@"HomeNaviCtl"];
            //                siderbarCtl = [iPad instantiateViewControllerWithIdentifier:SideBarType];
            //                [siderbarCtl.view setFrame:CGRectMake(0, 0, 438, 1024)];
            //                [siderbarCtl.view setBounds:CGRectMake(0, 0, 438, 1024)];
            //            }
            
            if(sidebarVC == nil)
                sidebarVC = [[UISidebarViewController alloc] initWithCenterViewController:navVC andSidebarViewController:siderbarCtl];
            
            self.window.rootViewController = sidebarVC;
        });
    });
    
}


-(CustomActionSheetViewController *)customViewCtlCreate
{
    CustomActionSheetViewController *Ctl;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
//        if ([[UIScreen mainScreen] bounds].size.height == 568.0)
//        {
//            Ctl = [iphone4Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//        }
//        else if([[UIScreen mainScreen] bounds].size.height == 480.0)
//        {
//            Ctl = [iphone instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//        }
//        else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
//        {
//            Ctl = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//        }
//        else
//        {
//            Ctl = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//        }
        Ctl = [iphone instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
    }
    
    return Ctl;
}

-(void)SideVcAddViewServerSyncFailAlert
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            customViewCtl = [self customViewCtlCreate];
            customViewCtl.TitleLabel = @"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요.";
            customViewCtl.confirmLabel = @"확인";
            [sidebarVC.view addSubview:customViewCtl.view];
        });
    });
}

-(void)SideVcAddViewPopup
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            customViewCtl = [self customViewCtlCreate];
            customViewCtl.TitleLabel = Double_Login_Title;
            customViewCtl.mtype = Login_Page_move;
            customViewCtl.confirmLabel = @"확인";
            customViewCtl.cancelLabel = @"취소";
            [sidebarVC.view addSubview:customViewCtl.view];
        });
    });
}

-(void)SideVcLossAddViewPopup
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            customViewCtl = [self customViewCtlCreate];
            customViewCtl.TitleLabel = Loss_Login_Title;
            customViewCtl.mtype = Login_Page_move;
            customViewCtl.confirmLabel = @"확인";
            [sidebarVC.view addSubview:customViewCtl.view];
        });
    });
}

-(void)SideVcAddViewPopupIdentificationFail
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            customViewCtl = [self customViewCtlCreate];
            customViewCtl.TitleLabel = @"플라스틱카드 사용에서는 이용 하실수 없습니다.";
            customViewCtl.mtype = Login_defualt;
            customViewCtl.confirmLabel = @"닫기";
            [sidebarVC.view addSubview:customViewCtl.view];
        });
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoteNotiStateCheck" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"applicationWillTerminate");

    if ( misLogin && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"]) {
        [self LogOutAction];
    }
}

- (void)LogOutAction
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    
    
    plainID  = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    base64ID = [plainID base64EncodedString];
    
    plainPW  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
    base64PW =[plainPW base64EncodedString];
    
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    
    [param setObject:[self getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:@"Logout" forKey:@"CMD"];
    
    NSMutableString *ParamString = [[NSMutableString alloc] init];
    NSArray *keys = [param allKeys];
    for (int i = 0; i<[keys count];i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *tempString;
        if (![[param objectForKey:key] isKindOfClass:[NSString class]])
        {
            tempString = [NSString stringWithFormat:@"%d",[[param objectForKey:key] intValue]];
        }
        else
            tempString = [param objectForKey:key];
        
        [ParamString appendString:[NSString stringWithFormat:@"%@=%@",key,[tempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if ([keys count]-1 != i)
        {
            [ParamString appendString:@"&"];
        }
        
    }
    [self reqestSending:SERVER_QueryClientBox :[ParamString dataUsingEncoding:NSUTF8StringEncoding]];
}


-(void)reqestSending:(NSString *)urlString :(NSData *)bodyData
{
    
    NSURL           *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest     *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    
    NSURLSession            *session = [NSURLSession sharedSession];
    NSURLSessionDataTask  *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200)
            {
                [self processResponse:data];
            }
            else
            {
                
                NSLog(@"result = %@", [httpResponse description]);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Communication Error"
                                                                    message:@"We received error from server."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Not Connectable"
                                                                message:@"We do not connect to the server."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    [uploadTask resume];
}

- (void)processResponse:(NSData *)aData
{
    NSLog(@"processResponse ");
    if (!misLogin)
    {
        return;
    }
    
    if (aData != nil)
    {
        NSString *ConvertString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
        if (ConvertString == nil) {
            ConvertString = [[NSString alloc] initWithData:aData encoding:(0x80000000+kCFStringEncodingEUC_KR)];
        }
        
        NSDictionary *reponseData = [Json decode:ConvertString];
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"Logout"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
  
            }
        }
    }
    
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
    // 디바이스 토큰을 디바이스에 세팅한다!
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [fpbu setDeviceToken:deviceId appCode:APPCODE];
    [[[NSUserDefaults standardUserDefaults] objectForKey:@"apns_setting"] isEqualToString:@"true"];
    
    if (misSubScribe)
    {
        FasPushControl *fasCtl = [FasPushControl getSharedInstance];
        [fasCtl initPush:APPCODE urlSubscribe:SERVER_QueryClient urlMessage:SERVER_QueryClientBox fasPushCallback:[[FasPushCallback alloc]init]];
        [fasCtl setCno:[self getCno]];
        [fasCtl setCustId:[self getCno]];

        // 기기 아이디 생성해서 키체인에 저장

        
        [fasCtl subscribe];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 앱 실행중이라 얼럿창 띄워준다.
    NSLog(@"apns Info = %@",[userInfo description]);
    
    application.applicationIconBadgeNumber--;
    
    if(self.misLogin)
    {
        FasPushControl *fasCtl = [FasPushControl getSharedInstance];
        [fasCtl initPush:APPCODE urlSubscribe:SERVER_QueryClient urlMessage:SERVER_QueryClientBox fasPushCallback:[[FasPushCallback alloc]init]];
        [fasCtl getLastDetail];
        //        [self AddPopUpViewFormWindowRootView:strMsg];
    }
    
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
    {
        NSArray * addonArray = [ServiceDb getAll];
        _simpleAddon = nil;
        
        NSArray * schemaArray = [[url absoluteString] componentsSeparatedByString:@"sso?schemas="];
        if ([schemaArray count] > 1)
        {
            schemaArray = [[schemaArray objectAtIndex:1] componentsSeparatedByString:@","];
            for (NSString * schema in schemaArray)
            {
                for (ServiceInfo * a in addonArray)
                {
                    if ([a.contentUrl isEqualToString:schema])
                    {
                        _simpleAddon = a;
                        break;
                    }
                    else if ([a.webContentUrl isEqualToString:schema])
                    {
                        _simpleAddon = a;
                        break;
                    }
                    else if ([a.browserContentUrl isEqualToString:schema])
                    {
                        _simpleAddon = a;
                        break;
                    }
                }
                if (_simpleAddon)
                {
                    break;
                }
            }
            if (_simpleAddon == nil)
            {
                _simpleAddon = [[ServiceInfo alloc] init];
                [_simpleAddon setName:[schemaArray firstObject]];
                [_simpleAddon setContentUrl:[schemaArray firstObject]];
            }
        }
        
        if (_simpleAddon == nil) {
            // 나중에 이 이하값은 제거해야함. 현재는 다른 앱들이 어떻게 쓰는지 몰라서 넣어둔 값들임.
            NSArray * array = [[url absoluteString] componentsSeparatedByString:@":"];
            if ([array count] > 1)
            {
                if ([[array objectAtIndex:0] length]> 3)
                {
                    for (ServiceInfo * a in addonArray)
                    {
                        if ([a.contentUrl isEqualToString:sourceApplication]) {
                            _simpleAddon = a;
                            break;
                        }
                        else if ([a.webContentUrl isEqualToString:sourceApplication])
                        {
                            _simpleAddon = a;
                            break;
                        }
                        else if ([a.browserContentUrl isEqualToString:sourceApplication])
                        {
                            _simpleAddon = a;
                            break;
                        }
                        
                    }
                    
                    if (_simpleAddon == nil) {
                        sourceApplication = [[sourceApplication componentsSeparatedByString:@"."] lastObject];
                        for (ServiceInfo * a in addonArray) {
                            if ([a.contentUrl isEqualToString:sourceApplication])
                            {
                                _simpleAddon = a;
                                break;
                            }
                            else if ([a.webContentUrl isEqualToString:sourceApplication])
                            {
                                _simpleAddon = a;
                                break;
                            }
                            else if ([a.browserContentUrl isEqualToString:sourceApplication])
                            {
                                _simpleAddon = a;
                                break;
                            }
                        }
                    }
                }
            }
        }
        if (_simpleAddon) {
            [self openSimpleLoginViewController];
        }
    } else {
        // pass
//        [self showAlertWithTitle:@"알림" :@"앱을 로그인한후 사용하여주시기 바랍니다." :nil :nil];
        [[[UIAlertView alloc] initWithTitle:@"알림"
                                   message:@"앱을 로그인한 후 사용하여주시기 바랍니다."
                                  delegate:self
                         cancelButtonTitle:@"확인"
                         otherButtonTitles: nil] show];
        [self LoginViewChange];
    }
    return YES;
}

- (void) openSimpleLoginViewController
{
    
    SimpleLoginViewController *Simplelogin;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
//        if ([[UIScreen mainScreen] bounds].size.height == 568.0)
//        {
//            Simplelogin = [iphone4Inch instantiateViewControllerWithIdentifier:@"M_sso_login"];
//        }
//        else if([[UIScreen mainScreen] bounds].size.height == 480.0)
//        {
//            Simplelogin = [iphone instantiateViewControllerWithIdentifier:@"M_sso_login"];
//        }
//        else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
//        {
//            Simplelogin = [iphone4_7Inch instantiateViewControllerWithIdentifier:@"M_sso_login"];
//        }
//        else
//        {
//            Simplelogin = [iphone5_5Inch instantiateViewControllerWithIdentifier:@"M_sso_login"];
//        }
        Simplelogin = [iphone instantiateViewControllerWithIdentifier:@"M_sso_login"];
    }

    
    Simplelogin.addon = _simpleAddon;
    self.window.rootViewController = Simplelogin;
    _simpleAddon = nil;
}


- (NSString *)getCno
{
    NSString *result_uuid = [[LUKeychainAccess standardKeychainAccess] stringForKey:@"uuid"];
    
    if(result_uuid == nil)
    {
        NSString *uuid;
        NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"6.0" options: NSNumericSearch];
        if (order == NSOrderedSame || order == NSOrderedDescending) {
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        } else {
            uuid = [[NSUUID UUID] UUIDString];
        }
        [[LUKeychainAccess standardKeychainAccess] setString:uuid forKey:@"uuid"];
        result_uuid = [[LUKeychainAccess standardKeychainAccess] stringForKey:@"uuid"];
    }
    
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:result_uuid ];
    
    const char *s=[uuid.UUIDString cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    

    
    return hash;
}

-(NSString *)localOSlang
{
    NSString *localizedString = [[NSLocale currentLocale] localeIdentifier];
    NSString *localLang = [[localizedString componentsSeparatedByString:@"_"] objectAtIndex:0];
    if ([localLang rangeOfString:@"-"].location != NSNotFound)
    {
        localLang = [[localLang componentsSeparatedByString:@"-"] objectAtIndex:0];
    }
    
    return localLang;
}

- (void)AddSubcriveViewErrorPopUpFormWindowRootView
{
    customViewCtl = [self customViewCtlCreate];
    [customViewCtl setTitleLabel:@"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요." ];
    [customViewCtl setMtype:0];
    [customViewCtl setConfirmLabel:@"확인"];
    if (self.window.rootViewController.presentedViewController != nil)
    {
        [self.window.rootViewController.presentedViewController.view performSelectorOnMainThread:@selector(addSubview:) withObject:customViewCtl.view waitUntilDone:YES];
        [self.window.rootViewController.presentedViewController.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:customViewCtl.view waitUntilDone:YES];
    }
    else
    {
        [self.window.rootViewController.view performSelectorOnMainThread:@selector(addSubview:) withObject:customViewCtl.view waitUntilDone:YES];
        [self.window.rootViewController.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:customViewCtl.view waitUntilDone:YES];
    }
    
}


- (void)getLastMessage:(NSNotification *)noti
{
    if (apnsPopupNon)
    {
        apnsPopupNon = false;
        return;
    }
    
    customViewCtl = [self customViewCtlCreate];
    
//    NSDictionary *ComemdInfo;
    
    NSString* msgDv = [[noti object] objectForKey:@"MSG_DV"];
    NSString* title = [[noti object] objectForKey:@"TITLE_CN"];
//    NSString* mId = @"";
    if ([msgDv isEqualToString:@"1"])
    {
        [customViewCtl setTitleLabel:title];
        [customViewCtl setMtype:Nomal_Noti];
        [customViewCtl setConfirmLabel:@"확인"];
        [customViewCtl setCancelLabel:@"취소"];
    }
    else if([msgDv isEqualToString:@"3"])
    {
//        [customViewCtl setTitleLabel:title];
//        [customViewCtl setMtype:Minwon_Noti];
//        [customViewCtl setConfirmLabel:@"확인"];
//        [customViewCtl setCancelLabel:@"취소"];
//        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"id"] != nil)
//        {
//            mId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
//        }
//        NSString *ServeyAddress = [NSString stringWithFormat:@"http://mobile.kornu.ac.kr/knuweb/mobileMinwon.do?id=%@",[AESHelper aes128EncryptString:mId]];
//        
//        ComemdInfo = [[NSDictionary alloc] initWithObjectsAndKeys:ServeyAddress,@"page",nil];
//        [customViewCtl setAlertInfo:ComemdInfo];
    }
    
    [customViewCtl ViewReLoad];
    
    if (self.window.rootViewController.presentedViewController != nil)
    {
        if ([[self.window.rootViewController.presentedViewController class] isEqual:[MessageCtl class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationEnter" object:nil];
        }
        
        [customViewCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        [self.window.rootViewController.presentedViewController.view performSelectorOnMainThread:@selector(addSubview:) withObject:customViewCtl.view waitUntilDone:YES];
        [self.window.rootViewController.presentedViewController.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:customViewCtl.view waitUntilDone:YES];
    }
    else
    {
        if ([[self.window.rootViewController class] isEqual:[MessageCtl class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationEnter" object:nil];
        }
        
        [customViewCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        [self.window.rootViewController.view performSelectorOnMainThread:@selector(addSubview:) withObject:customViewCtl.view waitUntilDone:YES];
        [self.window.rootViewController.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:customViewCtl.view waitUntilDone:YES];
        [self.window.rootViewController.view performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
    }
    
}

- (void)AddMessageViewFormWindowRootView
{
    if (self.window.rootViewController.presentedViewController != nil)
    {
        if ([[self.window.rootViewController.presentedViewController class] isEqual:[MessageCtl class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationEnter" object:nil];
        }
        else
        {
            [self.window.rootViewController.presentedViewController presentViewController:MessageCtl animated:YES completion:nil];
        }
        
    }
    else
    {
        if ([[self.window.rootViewController class] isEqual:[MessageCtl class]])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationEnter" object:nil];
        }
        else
        {
            [self.window.rootViewController presentViewController:MessageCtl animated:YES completion:nil];
        }
    }

}

-(BOOL)DatabaseChangeCountCheck:(NSString *)Count
{
    NSString *LocalCount;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DBLocalCount"]!= nil)
        LocalCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"DBLocalCount"];
    else
        LocalCount = @"0";
    
    if ([Count intValue] > [LocalCount intValue])
    {
        [[NSUserDefaults standardUserDefaults] setValue:Count forKey:@"DBLocalCount"];
        return YES;
    }
    
    return NO;
    
}

@end
