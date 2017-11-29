//
//  FasPushSettings.m
//  FasNFIGap
//
//  Created by etyoul on 2014. 4. 28..
//  Copyright (c) 2014년 fasolution. All rights reserved.
//

#import "FasPushSettings.h"

@implementation FasPushSettings

static FasPushSettings* settings = nil;

- (id) init
{
    self = [super init];
    
    appCode = @"";
    serverUrlSubscribe = @"";
    serverUrlMessage = @"";
    
    return self;
}

- (void) dealloc
{
//    [appCode release];
//    [serverUrlSubscribe release];
//    [serverUrlMessage release];
//    [super dealloc];
}

+(FasPushSettings*) getSharedInstance
{
    if (settings == nil) {
        @synchronized(self)
        {
            settings = [[self alloc] init];
        }
    }
    
    return settings;
}

- (void) setSettings:(NSString*)apDc urlSubscribe:(NSString*)urlSubscribe urlMessage:(NSString*)urlMessage
{
    [self setAppCode:(NSString *)apDc];
    [self setServerUrlSubscribe:(NSString *)urlSubscribe];
    [self setServerUrlMessage:(NSString *)urlMessage];
}

- (void) setAppCode:(NSString*)apDC
{
    appCode = apDC;
}

- (NSString*) getAppCode
{
    return appCode;
}

- (void) setServerUrlSubscribe:(NSString*)urlSubscribe
{
    serverUrlSubscribe = urlSubscribe;
}

- (NSString*) getServerUrlSubscribe
{
    return serverUrlSubscribe;
}


- (void) setServerUrlMessage:(NSString*)urlMessage
{
    serverUrlMessage = urlMessage;
}

- (NSString*) getServerUrlMessage
{
    return serverUrlMessage;
}

@end
