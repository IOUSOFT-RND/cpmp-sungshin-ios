//
//  Action+Type.m
//  emdm
//
//  Created by kdsooi on 13. 7. 23..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Action+Type.h"

@implementation Action (Type)

+ (NSString *)getActoinString:(ActionType)aAction
{
    NSString *string;
    
    switch (aAction)
    {
        case INITIATION:
            string = @"application/das.initiation+json";
            break;
            
        case LODING:
            string = @"application/das.loading+json";
            break;
            
        case AUTH:
            string = @"application/das.auth+json";
            break;
        
        case ATTENDANCE:
            string = @"application/das.attendance+json";
            break;
        
        case HARDWARE:
            string = @"application/das.hardware+json";
            break;
            
        case POSITION:
            string = @"application/das.position+json";
            break;
            
        default:
            break;
    }
    
    return string;
}

@end
