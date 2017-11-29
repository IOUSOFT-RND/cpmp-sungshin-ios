//
//  AppProgressCustomize.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//
//  FasNIFGap 1.4.5 에 최적화 되어 있음
//

#import <UIKit/UIKit.h>

@interface AppProgressCustomize : NSObject
{
    BOOL alertStat;
    UIWindow* mainView;
}

- (id)init;
- (void)setMainView:(UIWindow*)uiWindow;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)initPush;
- (void)openPushBox;
- (void)dealloc;
- (NSString *)getCno;

@end