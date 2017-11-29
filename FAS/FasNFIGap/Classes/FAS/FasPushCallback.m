//
//  FasPushCallback.m
//  FasNFIGap
//
//  Created by etyoul on 2014. 4. 28..
//  Copyright (c) 2014년 fasolution. All rights reserved.
//

#import "FasPushCallback.h"
#import "FasPushControl.h"
#import "FasSBJSON.h"

@implementation FasPushCallback


- (void)didReceiveFinished:(NSString *)result
{
#ifdef DEBUG

#endif
    NSLog(@"@FAS@|FNPPushBox.didReceiveFinished");
    NSLog(@"@FAS@|Received data:\n%@", result);
    if ([result isEqualToString:@"con_err"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SubcreiveConnectError" object:nil];
    }
    
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    id resultObj = [jsonParser objectWithString:result];
    NSString* command = [resultObj objectForKey:@"CMD"];
    NSString* ResultCode = [resultObj objectForKey:@"RESULT_CODE"];
    NSString* message = @"";
    if([resultObj objectForKey:@"MESSAGE"] != nil)
    {
        message = [resultObj objectForKey:@"MESSAGE"];
    }
    
    if([command isEqualToString:@"subscribe"] && [ResultCode  isEqualToString:@"0000"])
    {
        [[NSUserDefaults standardUserDefaults]setObject:[resultObj objectForKey:@"VERSION"] forKey:@"Server-VERSION"];
        [[NSUserDefaults standardUserDefaults]setObject:message forKey:@"Login-MESSAGE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"subscribeComplete"
                                                            object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:[resultObj objectForKey:@"TEMPLATE_TYPE"],@"TEMPLATE_TYPE", nil]];
        
    }
    else if([command isEqualToString:@"subscribe"] && [ResultCode  isEqualToString:@"9101"])
    {
        FasPushControl *fasCtl = [FasPushControl getSharedInstance];
        [fasCtl subscribe];
    }
    /*
     // NFI 방식으로 변경할시 처리 방법
     [self setReturnVal:@"succ"];                // 결과코드 : succ, fail
     [self setReturnMsg:@"error msg"];           // 결과메시지 : fail 일때 메시지를 넣는다
     [self addReturnArg:@"key1" value:@"data1"]; // 파라메터에 리턴 데이터를 넣는다.
     [self addReturnArg:@"key2" value:@"data2"]; // 파라메터에 리턴 데이터를 넣는다.
	 
     {
     "id":"FPNS"
     ,"returnVal":"succ"
     ,"cmd":"command"
     ,"param":{
     "key1":"data1"
     ,"key2":"data2"
     }
     }
     */
    /*
     [self setReturnVal:@"succ"];
     [self setReturnMsg:@""];
     [self addReturnArg:@"data" value:result];
     */
}


@end
