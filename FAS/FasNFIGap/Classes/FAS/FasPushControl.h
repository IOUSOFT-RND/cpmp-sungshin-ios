//
//  FasPushControl.h
//  FasNFIGap
//
//  Created by etyoul on 2014. 4. 28..
//  Copyright (c) 2014년 fasolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FasPushSettings.h"
#import "FasPushCallback.h"
#import "NFIMsg.h"

@interface FasPushControl : NSObject {
    BOOL initialized;
    FasPushCallback* fasPushCallback;
    FasPushSettings* fasPushSettings;
    id target;
    SEL selector;
}

@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL selector;

- (id) init;
- (void) dealloc;
+ (FasPushControl*) getSharedInstance;
- (void)setMainWindow:(UIWindow*)uiWindow;
- (void)setMainView:(UIView*)uiView;
- (void) setCallback:(FasPushCallback*)pushCallback;
- (void) initPush:(NSString*)apdc urlSubscribe:(NSString*)urlSubscribe urlMessage:(NSString*)urlMessage;
- (void) initPush:(NSString*)apdc urlSubscribe:(NSString *)urlSubscribe urlMessage:(NSString *)urlMessage fasPushCallback:(FasPushCallback*)pushCallback;
- (void) setCno:(NSString*)cno;
- (void) setCustId:(NSString*)custId;
- (void) isSubscribe;
- (void)subscribe;
- (void)unSubscribe;
- (void)initMqttClient:(NFIMsg*)msg;
- (void)setMqttClient;
- (NFIMsg*)getNFIMsg;
- (void) openPushBox;
- (void) openSettings;
- (void) openPushBox:(NSString*)page;
- (void)getLastDetail;
- (void)getBadge;
- (void)sendDeviceReceived:(NSString*)msgId;
- (void)didReceiveFinished:(NSString *)result;
- (void)moveToLandingUrl:(NSString*)url;
- (void)moveToAppPage:(NSString*)msgId;
- (BOOL) initCompleted;


@end
