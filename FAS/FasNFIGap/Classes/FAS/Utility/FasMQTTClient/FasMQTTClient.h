//
//  FasMQTTClient.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 13. 08. 29..
//  Copyright (c) 2013 F.A. Solutions. All rights reserved.
//

#import "MQTTSession.h"

@interface FasMQTTClient : NSMutableDictionary
{
    MQTTSession *session;
    BOOL      reconnect;
    id        delegate;

    NSMutableArray *mqttHostInfo;
    int            mqttHostSelectedIndex;
    
    NSString *mqttClientId;
    NSString *mqttSelectedHost;
    int       mqttSelectedPort;
    int       mqttKeepAlive;
    BOOL      mqttCleanSession;
    NSString *mqttUserName;
    NSString *mqttPassword;

    BOOL      mqttUseSsl;
    int       mqttQos;
    NSString *mqttLwtTopic;
    NSString *mqttLwtMsg;
    
    int       mqttReconnectSec;

	BOOL      mqttResultSend;
	
    NSMutableDictionary *topicDic;
}

 @property (strong, nonatomic) id delegate;

- (id)init;
- (void)dealloc;
+ (FasMQTTClient*)getSharedInstance;

- (void)setDelegate:(id)aDelegate;
- (void)sendMessage:(id)sender;
- (void)setConnectParameter:(NSDictionary*)mqttDic;
- (void)setTopic:(NSString*)topicName forKey:(NSString*)topicKey;
- (void)connect;
- (void)subscribe;
- (void)unsubscribe;
- (void)publishResultData:(NSString*)data onTopic:(NSString*)topic;

- (NSString*) uniqueClientIDForMQTT;

#pragma mark - MQTT Callback methods
- (void)session:(MQTTSession*)sender handleEvent:(MQTTSessionEvent)eventCode;
- (void)session:(MQTTSession*)sender newMessage:(NSData*)data onTopic:(NSString*)topic;

@end
