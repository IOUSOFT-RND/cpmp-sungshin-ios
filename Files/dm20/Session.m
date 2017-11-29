//
//  Session.m
//  emdm
//
//  Created by kdsooi on 13. 8. 2..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Session.h"

@implementation Session
@synthesize sessionId;
@synthesize status;
@synthesize description;

+ (NSString *)generateSessionId
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger flags = NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:flags fromDate:date];
    
    NSString *sessionId = [NSString stringWithFormat:@"%lx%lx", (long)[components minute], (long)[components second]];
    
    NSLog(@"sessionId : %@", sessionId);
    
    return sessionId;
}

@end
