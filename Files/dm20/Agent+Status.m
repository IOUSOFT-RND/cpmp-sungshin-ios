//
//  Agent+Status.m
//  emdm
//
//  Created by kdsooi on 13. 7. 31..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Agent+Status.h"

@implementation Agent (Status)

+ (NSString *)getStatusString:(AgentStatus)aStatus
{
    NSString *string;
    
    switch (aStatus)
    {
        case OK:
            string = @"200";
            break;
            
        case DEVICE_PHONENUMBER_NOT_FOUND:
            string = @"436";
            break;
        
        default:
            break;
    }
    
    return string;
}

+ (NSString *)getStatusDescription:(AgentStatus)aStatus
{
    NSString *string;
    
    switch (aStatus)
    {
        case OK:
            string = @"OK";
            break;
        case DEVICE_PHONENUMBER_NOT_FOUND:
            string = @"DEVICE_PHONENUMBER_NOT_FOUND";
            break;
            
        default:
            break;
    }
    
    return string;
}

@end
