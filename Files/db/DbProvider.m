//
//  DbProvider.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DbProvider.h"

#import "DeviceDb.h"
#import "NotificationDb.h"
#import "ProfileDb.h"
#import "SessionDb.h"
#import "DbObserver.h"
#import "ServiceDb.h"
#import "ServiceBookmark.h"


@implementation DbProvider

+ (void)createDb
{
    [DeviceDb Create];
    [NotificationDb Create];
    [ProfileDb Create];
    [SessionDb Create];
    [ServiceDb Create];
    [ServiceBookmark Create];
}

+ (void)AllDeleteDb
{
    NSError *error;
    
    [ProfileDb setInitiated:@"default" :false];
    [DeviceDb setDeviceRegistered:false];
    
    [[NSFileManager defaultManager] removeItemAtPath:[DeviceDb Path] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[NotificationDb Path] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[SessionDb Path] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[ServiceDb Path] error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:[ServiceBookmark Path] error:&error];
}

+(void)addDbObserver:(DbObserver *)mdbobserver
{
    [mdbobserver addPath:[DeviceDb Path]];
    [mdbobserver addPath:[ProfileDb Path]];
    [mdbobserver addPath:[SessionDb Path]];
}

@end
