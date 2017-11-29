//
//  APNSParser.m
//  emdm
//
//  Created by jaewon on 13. 8. 7..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Debug.h"
#import "APNSParser.h"
#import "Notification.h"
#import "Session.h"
#import "EnumDef.h"
#import "DeviceDb.h"
#import "XTime.h"
#import "NotificationDb.h"
#import "SessionDb.h"
#import "NotificationName.h"
#import "StringEnumDef.h"

@implementation APNSParser
@synthesize test;

+(void)executeAPNSMessage:(NSDictionary *)message
{
    if(message == nil)
    {
        NSLog(@"APNS Message is null");
        return;
    }
    
    if ([[message objectForKey:@"ServerMessage"]count] > 0)
    {        
        NSDictionary *MessageDictionary = [[message objectForKey:@"ServerMessage"] objectAtIndex:0];
        
        NSString *mAction = (NSString *)[MessageDictionary objectForKey:@"Action"];
        if([mAction length] == 0)
        {
            NSLog(@"Action is empty");
            return;
        }
        
        NSString *mServerId = (NSString *)[MessageDictionary objectForKey:@"ServerID"];
        if([mServerId length] == 0)
        {
            NSLog(@"ServerId is empty");
            return;
        }
        NSString *mType = (NSString *)[MessageDictionary objectForKey:@"Type"];
        if([mType length] == 0)
        {
            NSLog(@"Type is empty");
            return;
        }
        NSString *mSessionId = (NSString *)[MessageDictionary objectForKey:@"SessionID"];
        if([mSessionId length] == 0)
        {
            NSLog(@"SessionId is empty");
            return;
        }
        
        NSString *mDescription = (NSString *)[MessageDictionary objectForKey:@"Description"];
        if([mDescription length] == 0)
        {
            NSLog(@"mDescription is empty");
        }
        
        if([mAction isEqualToString:XXSE_PUSH_EMERGENCY_ACTION])
        {
            //긴급소집
            [[NSUserDefaults standardUserDefaults]setObject:@"Emergency" forKey:PUSH_EMERGENCY];
            if (mDescription != nil)
            {
                [[NSUserDefaults standardUserDefaults]setObject:mDescription forKey:PUSH_EMERGENCY_info];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:PUSH_EMERGENCY_info];
            }
        }
        else if([mAction isEqualToString:XXSE_PUSH_ATTENDANCE_ACTION])
        {
            //출근처리
        }
        else if ([mAction isEqualToString:XXSE_PUSH_LEAVE_ACTION])
        {
            //퇴근처리
        }
        else if([mAction isEqualToString:XXSE_PUSH_NOTICE_ACTION])
        {
            //공지사항
            //PUSH_GET_NOTI
            NSArray *NotiIndex;
            if (mDescription != nil)
            {
                NotiIndex = [mDescription componentsSeparatedByString:@"/"];
                [[NSUserDefaults standardUserDefaults]setObject:NotiIndex forKey:PUSH_GET_NOTI];
            }
        }
        
        NSLog(@"mAction = %@, mServerId = %@, mType = %@, mSessionId = %@",mAction,mServerId,mType,mSessionId);
        
    }
    
    if([[message objectForKey:@"aps"] count] > 0)
    {
        NSLog(@"aps PushMessage");
        
        //defult message action type
        //NSDictionary *apsDictionary = [message objectForKey:@"aps"];
        
    }
    else if([[message objectForKey:@"mdm"] count] > 0)
    {
       //mdm push message
        NSLog(@"mdm PushMessage");
    }
    
    
}

+(NSString *) getValue:(NSString *) text
{
    if ([text isEqualToString:@""])
    {
        NSLog(@"text is Empty");
        return nil;
    }
    
    NSArray *split = [text componentsSeparatedByString:@":"];
    if (split == Nil && [split count] < 2)
    {
        NSLog(@"text is worng");
        return nil;
    }
    
    NSMutableString *value = [[NSMutableString alloc] init];
    
    int SplitCount = (int)[split count];
    for (int index = 1; index < SplitCount; index++)
    {
        if (index >= 2)
        {
            [value stringByAppendingString:@":"];
        }
        [value stringByAppendingString:[split objectAtIndex:index]];
    }
    
    return value;
    
}

@end
