//
//  DbObserver.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DbObserver.h"
#import "DeviceDb.h"
#import "NotificationDb.h"
#import "ProfileDb.h"
#import "SessionDb.h"
#import "EnumDef.h"

@implementation DbObserver
@synthesize observerQueue;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    self.observerQueue = [[VDKQueue alloc] init];
    [self.observerQueue setDelegate:self];
    
    return self;
}

- (void)addPath:(NSString *)aPath
{
    [observerQueue addPath:aPath notifyingAbout:VDKQueueNotifyDefault];
}

- (void)VDKQueue:(VDKQueue *)queue receivedNotification:(NSString *)noteName forPath:(NSString *)fpath
{
    NSString *dbName = [fpath lastPathComponent];
    NSLog(@"db name : %@", dbName);
    
    if ([[NotificationDb DbName] isEqualToString:dbName])
    {
        
        Notification *noti = [NotificationDb getLastNotificationInfo];
        
        if (noti.state == PREDO)
        {
            NSNumber *NotiType = [[NSNumber alloc] initWithInt:NOTIFICATION_MSG_DO_ONE];
            NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys: NotiType, @"msg",nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotiHandlerMsg"
                                                                object:self
                                                              userInfo:info ];
        }
       
       
    }
}

@end
