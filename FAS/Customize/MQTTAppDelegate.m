//
//  MQTTAppDelegate.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 13. 9. 1..
//  Copyright (c) 2013 F.A. Solutions. All rights reserved.
//
//  FasNIFGap 1.4.5 에 최적화 되어 있음
//

#import "MQTTAppDelegate.h"
#import "FasNFIGap.h"
#import "FasPushBoxUtil.h"

/**
 * 프로젝트 마다 환경 설정에 따라 수정한다.
 */
#define ALERT_TITLE         @"나사렛대학교"
#define ALERT_MSG           @"메세지가 도착했습니다."
#define ALERT_BUTTON1       @"확인"
#define ALERT_BUTTON2       @"취소"
#define JS_FUNC_HASPUSH     @"hasPush"

@implementation MQTTAppDelegate


- (id)init
{
    self = [super init];

    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark - MQtt Callback methods

- (void)mqttHandleEvent:(MQTTSessionEvent)eventCode {
#ifdef DEBUG
    NSLog(@"@FAS@|MQTTAppDelegate.mqttHandleEvent");
#endif
    switch (eventCode) {
        case MQTTSessionEventConnected:
            NSLog(@"-- connected");
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"-- connection refused");
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"-- connection closed");
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"-- connection error");
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"-- protocol error");
            break;
    }
}


- (void)mqttNewMessage:(NSData*)data onTopic:(NSString*)topic
{
#ifdef DEBUG
    NSLog(@"@FAS@|MQTTAppDelegate.mqttNewMessage");
#endif
    NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"new message, %d bytes, topic=%@", [data length], topic);
    NSLog(@"data: %@ %@", payloadString,data);
#endif
}


- (void)mqttNewMessage:(NSData*)data onTopic:(NSString*)topic convertJSONDataToDic:(NSDictionary*)dataDic
    {
#ifdef DEBUG
    NSLog(@"@FAS@|MQTTAppDelegate.mqttNewMessage.convertJSONDataToDic");
#endif
    NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"new message, %d bytes, topic=%@", [data length], topic);
    NSLog(@"data: %@ %@", payloadString,data);
#endif

    NSString *appCode    = [dataDic objectForKey:@"BIZ_DC"];
    NSString *hiddenData = [dataDic objectForKey:@"_H"];
    NSString *milliSec   = [dataDic objectForKey:@"_T"];
    NSString *alert      = [dataDic objectForKey:@"ALERT"];
#ifdef DEBUG
    NSLog(@"new message appCode : %@",appCode);
    NSLog(@"new message hiddenData : %@",hiddenData);
    NSLog(@"new message milliSec : %@",milliSec);
    NSLog(@"new message alert : %@",alert);
#endif

    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];

    // 결과를 보낸다! ( 결과처리 3개중 세번째 - MQTT 받은 결과 전송 )
    [[FasMQTTClient getSharedInstance] publishResultData:[NSString stringWithFormat:@"%@|%@", @"IOSMQ", milliSec]
                                                 onTopic:[fpbu getPushboxPrefData:appCode forKey:@"MqttResultTopic"]];

    if([fpbu isLastPushMessage:milliSec forAppCode:appCode]) {

        if([fpbu isOpenPushBox])
        {
            //[fpbu alertBox:ALERT_TITLE message:strMsg buttonTitle:@"닫기"];
            BOOL confirm = [fpbu confirmBox:ALERT_TITLE message:alert cancelButtonTitle:ALERT_BUTTON1 okButtonTitle:ALERT_BUTTON2];
            if(confirm) {
                [fpbu setPushboxPrefSystemData:hiddenData forKey:@"_H"];

                [[FasNFIGap getSharedInstance] writeJavascriptFromMainWebView:JS_FUNC_HASPUSH parameter:@""];

            }
        }
        else
        {
            BOOL confirm = [fpbu confirmBox:ALERT_TITLE message:alert cancelButtonTitle:ALERT_BUTTON1 okButtonTitle:ALERT_BUTTON2];
            if(confirm) {
                [fpbu setPushboxPrefSystemData:hiddenData forKey:@"_H"];

                [[FasNFIGap getSharedInstance] writeJavascriptFromMainWebView:JS_FUNC_HASPUSH parameter:@""];
            }
        }
    }

    [fpbu release];
}


@end
