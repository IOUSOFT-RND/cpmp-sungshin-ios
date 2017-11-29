//
//  FasMQTTClient.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 13. 08. 29..
//  Copyright (c) 2013 F.A. Solutions. All rights reserved.
//
#import "FasMQTTClient.h"
#import "FasJSON.h"
#import "FasPushBoxUtil.h"

#define MQTT_CLIENT_ID_KEY    @"_MQTT_CLIENT_ID_"

@implementation FasMQTTClient 

@synthesize delegate;

static FasMQTTClient *g_FasMQTTClient = nil;


- (id)init
{
    self = [super init];

    mqttHostSelectedIndex = 0;
    reconnect = NO;

    return self;
}


- (void)dealloc
{
   [super dealloc];
}


+ (FasMQTTClient*)getSharedInstance
{
    if (g_FasMQTTClient == nil)
    {
        @synchronized(self)
        {
            g_FasMQTTClient = [[self alloc] init];
        }
    }
    return g_FasMQTTClient;
}


- (void)setDelegate:(id)aDelegate {
    delegate = aDelegate;
}


- (void)sendMessage:(id)sender {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.sendMessage");
#endif
/*
    [_textMessage resignFirstResponder];
    NSString * string = _textMessage.text;

    NSData* pubData=[string dataUsingEncoding:NSUTF8StringEncoding];
    [session publishData:pubData onTopic:topicName.text];
*/
}


- (void)setConnectParameter:(NSDictionary*)mqttDic {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.setConnectParameter");
#endif

    mqttHostInfo     =  [mqttDic objectForKey:@"hostinfo"];

    if (mqttHostInfo == nil) {
        mqttHostInfo = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *tmpHostInfo = [[NSMutableDictionary alloc] init];
        [tmpHostInfo setValue:[mqttDic objectForKey:@"host"] forKey:@"host"];
        [tmpHostInfo setValue:[mqttDic objectForKey:@"port"] forKey:@"port"];
        
        [mqttHostInfo addObject:tmpHostInfo];
        
    }

    // host 목록을 검색한다.
    NSDictionary *hostInfo = [mqttHostInfo objectAtIndex:mqttHostSelectedIndex];
    
    mqttSelectedHost = [hostInfo objectForKey:@"host"];
    mqttSelectedPort = [[hostInfo objectForKey:@"port"] intValue];
    
    // 다음 호스트 정보처리를 위한 데이터
    mqttHostSelectedIndex++;
    if([hostInfo count] <= mqttHostSelectedIndex + 1) {
        mqttHostSelectedIndex = 0;
    }

    mqttClientId     = [self uniqueClientIDForMQTT];
    //mqttHost         =  [mqttDic objectForKey:@"host"];
    //mqttPort         = [[mqttDic objectForKey:@"port"] intValue];
    mqttKeepAlive    = [[mqttDic objectForKey:@"keepalive"] intValue];
    mqttCleanSession = [[mqttDic objectForKey:@"clean_session"] isEqualToString:@"true"];
    mqttUserName     =  [mqttDic objectForKey:@"username"];
    mqttPassword     =  [mqttDic objectForKey:@"password"];
    mqttUseSsl       = [[mqttDic objectForKey:@"use_ssl"] isEqualToString:@"true"];
    mqttQos          = [[mqttDic objectForKey:@"qos"] intValue];
    mqttLwtTopic     =  [mqttDic objectForKey:@"lwt_topic"];
    mqttLwtMsg       =  [mqttDic objectForKey:@"lwt_msg"];
    
    mqttReconnectSec = [[mqttDic objectForKey:@"reconnect"] intValue];

	mqttResultSend   = [[mqttDic objectForKey:@"result_send"] isEqualToString:@"true"];
}


- (void)setTopic:(NSString*)topicName forKey:(NSString*)topicKey {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.setTopic");
    NSLog(@"@FAS@|topicKey : %@",topicKey);
    NSLog(@"@FAS@|topicName : %@",topicName);
#endif
    if(topicDic == nil) topicDic = [[NSMutableDictionary alloc] init];
    
    [topicDic setValue:topicName forKey:topicKey];
}


- (void)connect {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.connect");
#endif
    FasPushBoxUtil *fpbu = [[FasPushBoxUtil alloc] init];
    [[FasMQTTClient getSharedInstance] setConnectParameter:[fpbu getMqttPrefAllData]]; // 파라메터 세팅
#ifdef DEBUG
    NSLog(@"@FAS@|mqttHostInfo : %@",mqttHostInfo);
    NSLog(@"@FAS@|mqttClientId : %@",mqttClientId);
    NSLog(@"@FAS@|mqttSelectedHost : %@",mqttSelectedHost);
    NSLog(@"@FAS@|mqttSelectedPort : %d",mqttSelectedPort);
    NSLog(@"@FAS@|mqttKeepAlive : %d",mqttKeepAlive);
    NSLog(@"@FAS@|mqttCleanSession : %d",mqttCleanSession);
    NSLog(@"@FAS@|mqttUserName : %@",mqttUserName);
    NSLog(@"@FAS@|mqttPassword : %@",mqttPassword);
    NSLog(@"@FAS@|mqttUseSsl : %d",mqttUseSsl);
    NSLog(@"@FAS@|mqttQos : %d",mqttQos);
    NSLog(@"@FAS@|mqttLwtTopic : %@",mqttLwtTopic);
    NSLog(@"@FAS@|mqttLwtMsg : %@",mqttLwtMsg);
    NSLog(@"@FAS@|mqttReconnectSec : %d",mqttReconnectSec);
    NSLog(@"@FAS@|mqttResultSend : %d",mqttResultSend);

#endif

    if(session != nil) {
        reconnect = YES;
        [session close];
    }
    else {
        session = [[MQTTSession alloc] initWithClientId:mqttClientId
                                               userName:mqttUserName
                                               password:mqttPassword
                                              keepAlive:mqttKeepAlive
                                           cleanSession:mqttCleanSession];

        [session connectToHost:mqttSelectedHost port:mqttSelectedPort usingSSL:mqttUseSsl];
        [session setDelegate:self];
    }

//    [fpbu release];
}


- (void)subscribe {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.subscribe");
#endif
    if(session == nil) {
        NSLog(@"@FAS@|MQTT Session null!");
        [self connect];
    }
    else {
        NSLog(@"@FAS@|MQTT subscribe start!");
        
        if(topicDic != nil) {
            id key;
            id value;
            
            for(key in topicDic)
            {
                value = [topicDic objectForKey:key];
/*
                 part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                 [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
*/
#ifdef DEBUG
                NSLog(@"@FAS@|topicDic key : %@, value : %@" ,key ,value);
#endif
                [session subscribeToTopic:value atLevel:mqttQos];
            }
        }
        else {
            NSLog(@"@FAS@|empty topics!");
        }
    }
}


- (void)unsubscribe {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.unsubscribe");
#endif
    if(session == nil) {
        NSLog(@"@FAS@|MQTT Session null!");
        [self connect];
    }
    else {
        NSLog(@"@FAS@|MQTT unsubscribe start!");
        
        if(topicDic != nil) {
            id key;
            id value;
            
            for(key in topicDic)
            {
                value = [topicDic objectForKey:key];
/*
                part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
*/
#ifdef DEBUG
                NSLog(@"@FAS@|topicDic key : %@, value : %@" ,key ,value);
#endif
                [session unsubscribeTopic:value];
            }
        }
        else {
            NSLog(@"@FAS@|empty topics!");
        }
    }
}


- (void)publishResultData:(NSString*)data onTopic:(NSString*)topic {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.publishResultData");
#endif
	if(mqttResultSend) {
		if(session == nil) {
			NSLog(@"@FAS@|MQTT Session null!");
			[self connect];
		}
		else {
			NSLog(@"@FAS@|MQTT publishResultData start!");
			NSLog(@"@FAS@|MQTT topic : %@, data : %@", topic, data);
			//NSData *pubData = [NSData dataWithBytes:data.UTF8String length:strlen(data.UTF8String)];
			NSData* pubData=[data dataUsingEncoding:NSUTF8StringEncoding];
			[session publishData:pubData onTopic:topic];
		}
	}
	else {
		NSLog(@"@FAS@|MQTT Result don't Send!");
	}
}


- (NSString*) uniqueClientIDForMQTT {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.uniqueClientIDForMQTT");
#endif
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* clientId = [userDefaults stringForKey:MQTT_CLIENT_ID_KEY];
    if (clientId == nil)
    {
        NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
        //NSMutableString *randomClientId = [NSMutableString stringWithCapacity:5];
        //for (NSUInteger i = 0; i < 5; i++) {
        NSMutableString *randomClientId = [NSMutableString stringWithCapacity:3];
        for (NSUInteger i = 0; i < 3; i++) {
            u_int32_t r = arc4random() % [alphabet length];
            unichar c = [alphabet characterAtIndex:r];
            [randomClientId appendFormat:@"%C", c];
        }
        
        time_t unixTime = (time_t)[[NSDate date]timeIntervalSince1970];

        clientId = [NSString stringWithFormat:@"%@.%@.%ld.%@"
                    ,@"fPNS"
                    ,@"ios"
                    ,unixTime
                    ,randomClientId];

        [userDefaults setObject:clientId forKey:MQTT_CLIENT_ID_KEY];
        [userDefaults synchronize];
    }
    
    NSLog(@"@FAS@|uniqueClientIDForMQTT -> clientId : %@",clientId);
    
    return clientId;
}


#pragma mark - MQtt Callback methods

- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode {
#ifdef DEBUG
    NSLog(@"@FAS@|FasMQTTClient.handleEvent - MQtt Callback!");
#endif
    
    
//    if ([delegate respondsToSelector:@selector(mqttHandleEvent:)]) {
//        NSLog(@"@FAS@|call mqttHandleEvent!!!!!!");
//        [delegate mqttHandleEvent:eventCode];
//    }
    
//    
//    NSMutableDictionary* eventDic = [[NSMutableDictionary alloc] init];
//    [eventDic setValue:eventCode forKey:@"eventCode"];
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"MQTTHandleNotification" object:@"" userInfo:eventDic];
//    
    switch (eventCode) {
        case MQTTSessionEventConnected:
             NSLog(@"connected [ HOST : %@ , PORT : %d ]",mqttSelectedHost ,mqttSelectedPort);
            [self subscribe];
            break;
        case MQTTSessionEventConnectionRefused:
            NSLog(@"connection refused [ HOST : %@ , PORT : %d ]",mqttSelectedHost ,mqttSelectedPort);
            break;
        case MQTTSessionEventConnectionClosed:
            NSLog(@"connection closed");
            if(reconnect) {

                NSLog(@"reconnect before sleep %d sec..",mqttReconnectSec);

                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:mqttReconnectSec]];

                NSLog(@"reconnecting...[reconnect:YES][ HOST : %@ , PORT : %d ]",mqttSelectedHost ,mqttSelectedPort);
                if(session != nil) {
//                    [session release];
                    session = nil;
                }
                reconnect = NO;
                [self connect];
            }
            break;
        case MQTTSessionEventConnectionError:
            NSLog(@"connection error [ HOST : %@ , PORT : %d ]",mqttSelectedHost ,mqttSelectedPort);
            NSLog(@"reconnecting...[ HOST : %@ , PORT : %d ]",mqttSelectedHost ,mqttSelectedPort);
            // Forcing reconnection
            [self connect];
            break;
        case MQTTSessionEventProtocolError:
            NSLog(@"protocol error");
            break;
    }
}


- (void)session:(MQTTSession*)sender
     newMessage:(NSData*)data
        onTopic:(NSString*)topic {
    
//    if ([delegate respondsToSelector:@selector(mqttNewMessage:onTopic:)]) {
//        NSLog(@"@FAS@|call mqttNewMessage!!!!!!");
//        [delegate mqttNewMessage:data onTopic:topic];
//    }
    
//    if ([delegate respondsToSelector:@selector(mqttNewMessage:onTopic:convertJSONDataToDic:)]) {
//        NSLog(@"@FAS@|call mqttNewMessage!!!!!! convert JSONData To NSDictionary");
//        
//        NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
//        NSDictionary *dic =(NSDictionary*)[jsonParser objectWithString:payloadString error:NULL];
//#ifdef DEBUG
//        NSLog(@"convert NSDictionary : %@",dic);
//#endif
//        [delegate mqttNewMessage:data onTopic:topic convertJSONDataToDic:dic];
//        
//        [jsonParser release];
//    }
    
    NSLog(@"@FAS@|call mqttNewMessage!!!!!! convert JSONData To NSDictionary");
    
    NSString *payloadString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    NSDictionary *dic =(NSDictionary*)[jsonParser objectWithString:payloadString error:NULL];
    
    NSLog(@"convert NSDictionary : %@",dic);
    
    NSMutableDictionary* eventDic = [[NSMutableDictionary alloc] init];
    [eventDic setValue:data forKey:@"data"];
    [eventDic setValue:topic forKey:@"topic"];
    [eventDic setValue:dic forKey:@"dataDic"];
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MQTTNewMsgNotification" object:eventDic];
}


@end

