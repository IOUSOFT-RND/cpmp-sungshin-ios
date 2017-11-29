//
//  FasPushSettings.h
//  FasNFIGap
//
//  Created by etyoul on 2014. 4. 28..
//  Copyright (c) 2014년 fasolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FasPushSettings : NSObject
{
    NSString    *appCode;
    NSString    *serverUrlSubscribe;
    NSString    *serverUrlMessage;
}

- (id) init;
- (void) dealloc;
+(FasPushSettings*) getSharedInstance;
- (void) setSettings:(NSString*)apDc urlSubscribe:(NSString*)urlSubscribe urlMessage:(NSString*)urlMessage;
- (void) setAppCode:(NSString*)apDC;
- (NSString*) getAppCode;
- (void) setServerUrlSubscribe:(NSString*)urlSubscribe;
- (NSString*) getServerUrlSubscribe;
- (void) setServerUrlMessage:(NSString*)urlMessage;
- (NSString*) getServerUrlMessage;

@end
