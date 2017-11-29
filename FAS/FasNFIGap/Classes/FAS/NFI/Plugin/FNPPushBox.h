//
//  FNPPushBox.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import "NFIPlugin.h"
#import "FasPushBoxController.h"

@interface FNPPushBox : NFIPlugin
{
    id delegate;
	UINavigationController* mNav;
	//UIView *mSubView;
}

- (id)init;
- (id)init:(id)delegate;
- (id)init:(UIWindow*)mainView delegate:(id)callbackDelegate;
- (void)execute;
- (void)startView;
- (void)startView:(NFIMsg*)msg;
- (void)endView;
- (void)startHome;
- (void)show;
- (void)hide;
- (void)sendDataToCallback;
- (void)isSubscribe;
- (void)isSubscribe:(NFIMsg*)msg;
- (void)subscribe;
- (void)subscribe:(NFIMsg*)msg;
- (void)unSubscribe;
- (void)unSubscribe:(NFIMsg*)msg;
- (void)initMqttClient;
- (void)initMqttClient:(NFIMsg*)msg;
- (void)setMqttClient;
- (void)setMqttClient:(NFIMsg*)msg;
- (void)didReceiveFinished:(NSString *)result;
- (void)setUserInfo;
- (void)setUserInfo:(NFIMsg*)msg;
- (void)hasMessage;
- (void)getPreview;
- (void)setPreview;
- (void)getNotify;
- (void)setNotify;
- (void)getPassword;
- (void)setPassword;
- (void)isLocked;
- (void)requestHttp;
- (void)requestHttp:(NFIMsg*)msg;
- (void)requestHttpForLotte;
- (void)requestHttpForLotte:(NFIMsg*)msg;
- (void)setBadge;
- (void)setBadge:(NFIMsg*)msg;
- (void)plusBadge;
- (void)minusBadge;
//- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (void)openPushBox:(NSString *)url;
- (void)moveToLandingUrl;
- (void)moveToLandingUrl:(NFIMsg*)msg;
- (void)moveToAppPage;
- (void)moveToAppPage:(NFIMsg*)msg;


@end
