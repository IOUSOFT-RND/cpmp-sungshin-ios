//
//  NotificationHandler.m
//  emdm
//
//  Created by jaewon on 13. 10. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "NotificationHandler.h"
#import "NotificationDb.h"
#import "EnumDef.h"
#import "Profiles.h"
#import "Agent.h"
#import "NotificationName.h"

@implementation NotificationHandler


- (void) initServiceStart
{
    NSLog(@"[NotificationHandler][initServiceStart]");
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(sendMessage:)
                                                 name: MDM_NOTI_HANDELER
                                               object: nil];
    
}

-(void)sendMessage:(NSNotification *)noti
{
    NSLog(@"[NotificationHandler][sendMessage]");
    [self handlerMessage:[[noti userInfo] objectForKey:@"msg"]];
}

- (void)handlerMessage: (id) msg
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       
                       switch ([msg intValue]) {
                           case NOTIFICATION_MSG_DO_ALL:
                               [self doAll];
                               break;
                               
                           case NOTIFICATION_MSG_DO_ONE:
                               [self doOne];
                               break;
                               
                           case NOTIFICATION_MSG_DO_INITIATION:
                               [self doInitiation];
                               break;
                       }
                   });
}


- (void)doInitiation
{
    if(![Profile initiatize])
    {
        NSLog(@"[NotificationHandler][doInitiation]profile initiation faill");
        return;
    }
    
}

- (void)doAll
{
    NSArray *Infos = [NotificationDb getPreDoAll];
    if (![Infos isEqual: nil])
    {
        NSInteger InfosCount = [Infos count];
        
        for (int i = 0; i < InfosCount; i++)
        {
            [NotificationDb setState:[[Infos objectAtIndex:i] sessionId] : DOING];
            NSLog(@"[NotificationHandler][doAll] session id : = %@",[[Infos objectAtIndex:i] sessionId]);
            [[[Agent alloc] initWithData:nil :[Infos objectAtIndex:i]] start];
        }
    
    }
}

- (void)doOne
{
    Notification *Info = [NotificationDb getLastNotificationInfo];
    [NotificationDb setState:[Info sessionId] : DOING];
    NSLog(@"[NotificationHandler][doOne] session id : = %@",[Info sessionId]);
    [[[Agent alloc] initWithData:nil :Info] start];

}




@end
