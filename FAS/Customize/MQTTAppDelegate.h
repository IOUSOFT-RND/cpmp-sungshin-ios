//
//  MQTTAppDelegate.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 13. 9. 1..
//  Copyright (c) 2013 F.A. Solutions. All rights reserved.
//
//  FasNIFGap 1.4.5 에 최적화 되어 있음
//

#import <Foundation/Foundation.h>
#import "FasMQTTClient.h"

@interface MQTTAppDelegate : NSObject
{
}

- (id)init;
- (void)dealloc;
- (void)mqttHandleEvent:(MQTTSessionEvent)eventCode;
- (void)mqttNewMessage:(NSData*)data onTopic:(NSString*)topic;
- (void)mqttNewMessage:(NSData*)data onTopic:(NSString*)topic convertJSONDataToDic:(NSDictionary*)dataDic;

@end

