//
//  Profiles.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Profiles.h"
#import "ProfileDb.h"
#import "NotificationDb.h"
#import "EnumDef.h"
#import "Notification.h"
#import "Session.h"
#import "Json.h"
#import "Debug.h"

@implementation Profile
@synthesize name;
@synthesize serverId;
@synthesize serverUrl;
@synthesize enabled;
@synthesize priority;
@synthesize initiated;


+ (BOOL) initiatize
{
    
    NSString *where =[[NSString alloc] initWithFormat:@"%@ =? AND %@ =? AND %@ =?",COLUMN_ENABLED,COLUMN_INITIATED,COLUMN_PRIORITY];
    NSMutableArray *selectionArgs = [[NSMutableArray alloc]init];
    [selectionArgs addObject:[[NSNumber alloc] initWithBool:true]];
    [selectionArgs addObject:[[NSNumber alloc] initWithBool:false]];
    [selectionArgs addObject:@"default"];
    
    NSArray *Profiles = [ProfileDb SelectQuery:where :selectionArgs];
    Notification *notiInfo = [[Notification alloc]init];
    BOOL result = false;
    
    if([Profiles count] > 0)
    {
        [notiInfo setActionType:INITIATION];
        [notiInfo setType:BY_DEVICE];
        [notiInfo setServerId:[[Profiles objectAtIndex:0] serverId]];
        [notiInfo setSessionId:[Session generateSessionId]];
        [notiInfo setServiceType:DM];
        [notiInfo setState:PREDO];
        [ProfileDb setInitiated:[(Profile *)[Profiles objectAtIndex:0] priority] :true];
        result = true;
    }
    
    return result;
}

+ (BOOL) reInitiatize
{
 
    NSString *where =[[NSString alloc] initWithFormat:@"%@ =? AND %@ =?",COLUMN_ENABLED,COLUMN_PRIORITY];
    NSMutableArray *selectionArgs = [[NSMutableArray alloc]init];
    [selectionArgs addObject:[[NSNumber alloc] initWithBool:true]];
    [selectionArgs addObject:@"default"];
    
    NSArray *Profiles = [ProfileDb SelectQuery:where :selectionArgs];
    Notification *notiInfo = [[Notification alloc]init];
    BOOL result = false;
    
    if([Profiles count] > 0)
    {
        [notiInfo setActionType:INITIATION];
        [notiInfo setType:BY_DEVICE];
        [notiInfo setServerId:[[Profiles objectAtIndex:0] serverId]];
        [notiInfo setSessionId:[Session generateSessionId]];
        [notiInfo setServiceType:DM];
        [notiInfo setState:PREDO];
        
        NSLog(@"Profile initiatize %@",[[Profiles objectAtIndex:0] toString]);
        result = [NotificationDb Transaction:[[NSArray alloc] initWithObjects:notiInfo, nil] ];
    }
    
    return result;

}

-(BOOL)load
{
    Profiles *Infos = [[Profiles alloc]init];
    NSArray *List = [Infos ResouceProfileLoad];
    
    if([List isEqual:nil])
    {
        NSLog(@"[Profile][load]Profiles is Empty");
        return false;
    }
    
    NSInteger Listcount = [List count];
    
    for (int i = 0; i < Listcount; i++)
    {
        Profile *info = [[Profile alloc] init];
        [info decode:[List objectAtIndex:i]];
        [ProfileDb put:info :(i+1)];
    }
    
    return true;
}

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (name != nil)
        [dic setObject:name forKey:@"Name"];
    
    if (serverId != nil)
        [dic setObject:serverId forKey:@"ServerId"];
    
    if (serverUrl != nil)
        [dic setObject:serverUrl forKey:@"ServerUrl"];
    
    if (enabled != nil)
        [dic setObject:enabled forKey:@"IsEnabled"];
    
    if (priority != nil)
        [dic setObject:priority forKey:@"Priority"];
    
    if (initiated != nil)
        [dic setObject:initiated forKey:@"IsInitiated"];
    
    return dic;
}

- (void)decode:(id)input
{
    if (input == nil)
    {
        LOG(INFO, "input == nil");
        return;
    }
    
    if ([input objectForKey:@"Name"] != nil)
        name = [input objectForKey:@"Name"];
    
    if ([input objectForKey:@"ServerId"] != nil)
        serverId = [input objectForKey:@"ServerId"];
    
    if ([input objectForKey:@"ServerUrl"] != nil)
        serverUrl = [input objectForKey:@"ServerUrl"];
    
    if ([input objectForKey:@"IsEnabled"] != nil)
        enabled = [input objectForKey:@"IsEnabled"];
    
    if ([input objectForKey:@"Priority"] != nil)
        priority = [input objectForKey:@"Priority"];
    
    if ([input objectForKey:@"IsInitiated"] != nil)
        initiated = [input objectForKey:@"IsInitiated"];
    
    NSLog(@"name = %@",name);
    NSLog(@"serverId = %@",serverId);
    NSLog(@"serverUrl = %@",serverUrl);
    NSLog(@"enabled = %@",enabled);
    NSLog(@"priority = %@",priority);
    NSLog(@"initiated = %@",initiated);

}


- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Profile ["];
    [string appendFormat:@"name=%@", name];
    [string appendFormat:@" serverId=%@", serverId];
    [string appendFormat:@" serverUrl=%@", serverUrl];
    [string appendFormat:@" enabled=%@", enabled];
    [string appendFormat:@" priority=%@", priority];
    [string appendFormat:@" initiated=%@", initiated];
    [string appendString:@"]"];
        
    return string;
}

@end

@implementation Profiles
@synthesize profiles;

- (id)encode
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (profiles != nil)
        [dic setObject:profiles forKey:@"Profile"];
    
    return dic;
}

- (void)decode:(id)dic
{
    if (dic == nil)
    {
        LOG(INFO, "dic == nil");
        return;
    }
    
    if ([dic objectForKey:@"Profile"] != nil)
        profiles = [dic objectForKey:@"Profile"];
}

- (NSArray *)ResouceProfileLoad
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"profile" ofType:@"txt" ];
    if([manger fileExistsAtPath:filePath])
    {
        NSData *fileDate = [manger contentsAtPath:filePath];
        NSLog(@"file Data = %@",[[NSString alloc]initWithData:fileDate encoding:NSUTF8StringEncoding]);
        [self decode:[Json decode:fileDate]];
    }
    NSLog(@"count %lu",(unsigned long)[profiles count]);
    
    return self.profiles;
}

- (NSString *)toString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    
    [string appendString:@"Profiles ["];

    [string appendString:@"]"];
    
    return string;
}


@end
