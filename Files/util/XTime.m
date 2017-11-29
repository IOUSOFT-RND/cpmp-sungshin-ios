//
//  XTime.m
//  emdm
//
//  Created by jaewon on 13. 10. 15..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "XTime.h"

#define MAX_DAY 31
#define MIN_DAY 1

@implementation XTime

+(NSString *)getCurrDayOfWeek
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"EEE"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    return [dateFomat stringFromDate:date];
}

+(NSString *)getCurrDay
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"dd"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    return [dateFomat stringFromDate:date];
}

+(NSString *)getCurrentMonth
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"YYYY년 MM월"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    return [dateFomat stringFromDate:date];
}

+(NSString *)getCurrTimeHM
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"HH:mm"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    return [dateFomat stringFromDate:date];
}

+(NSString *)getCurrTimeHMS
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"HH:mm:ss"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    
    return [dateFomat stringFromDate:date];
}

+(long )getCurrMsec
{
    NSDate *date = [NSDate date];
    
    
    return [date timeIntervalSinceReferenceDate];
}

+(long )getCurrMsec :(long) msec
{
    NSCalendar *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSDateComponents *compoents = [calender components: NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                   
                                              fromDate:date];
    [compoents setHour:0];
    [compoents setMinute:0];
    [compoents setSecond:0];
    [compoents setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    
    return [[calender dateFromComponents:compoents]timeIntervalSinceReferenceDate]+msec;
}


+(long )getCurrMsecHM
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *compoents = [calender components: NSCalendarUnitHour
                                   | NSCalendarUnitMinute
                                   | NSCalendarUnitSecond
                                              fromDate:date];
    
    NSLog(@"Time %d", (int)compoents.hour *60*60*1000+ (int)compoents.minute*60*1000);
    
    
    return ((compoents.hour *60)+compoents.minute)*60*1000;
}

+(long )getMsecHM :(NSString *) time
{
    if([time length] <= 0)
    {
        NSLog(@"time is Empty");
        return 0;
    
    }
    
    NSArray *split = [time componentsSeparatedByString:@":"];
    if ([split isEqual:nil])
    {
        NSLog(@"splite == nil");
    }
    
    if ([split count] != 2)
    {
        NSLog(@"splite count !=2 ");
        return 0;
    }
    
    return (([[split objectAtIndex:0] intValue] *60)+[[split objectAtIndex:1] intValue])*60*1000;
}


+(long )getConvertMsecHM :(NSString *) time
{
    if([time length] <= 0)
    {
        NSLog(@"time is Empty");
        return 0;
        
    }
    
    return ([time intValue])*60*1000;
}

+(NSDate *)getOneHourBefor:(NSDate *) date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *component = [calender components:   NSCalendarUnitYear  |
                                                          NSCalendarUnitMonth  |
                                                          NSCalendarUnitDay    |
                                                          NSCalendarUnitHour   |
                                                          NSCalendarUnitMinute
                                              fromDate:date];
    [component setHour:[component hour]-1];
    return [calender dateFromComponents:component];
}

+(NSDate *)getOnedayBefor:(NSDate *) date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *component = [calender components:   NSCalendarUnitYear  |
                                                          NSCalendarUnitMonth  |
                                                          NSCalendarUnitDay    |
                                                          NSCalendarUnitHour   |
                                                          NSCalendarUnitMinute
                                              fromDate:date];
    [component setDay:[component day]-1];
    return [calender dateFromComponents:component];
}

+(NSString *)getCurrTimeMin
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"mm"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    NSDate *date = [NSDate date];
    
    return [dateFomat stringFromDate:date];
}

+(NSString *)getDateFormatChange:(NSString *)dateStr
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"YYYYMMddHHmmss"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ko_kr"]];
    NSDate *date = [dateFomat dateFromString:dateStr];
    
    NSDateFormatter *dateFomat1=[[NSDateFormatter alloc]init];
    [dateFomat1 setDateFormat:@"YYYY.MM.dd HH:mm"];
    [dateFomat1 setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ko_kr"]];
    
    return [dateFomat1 stringFromDate:date];
}

+(NSString *)getDateDayFormatChange:(NSString *)dateStr
{
    NSDateFormatter *dateFomat=[[NSDateFormatter alloc]init];
    [dateFomat setDateFormat:@"YYYYMMddHHmmss"];
    [dateFomat setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ko_kr"]];
    NSDate *date = [dateFomat dateFromString:dateStr];
    
    NSDateFormatter *dateFomat1=[[NSDateFormatter alloc]init];
    [dateFomat1 setDateFormat:@"YYYY.MM.dd"];
    [dateFomat1 setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ko_kr"]];
    
    return [dateFomat1 stringFromDate:date];
}

+(BOOL)GetCurrentMonthCheck:(int)day
{
    int Currentday = [[self getCurrDay] intValue];
   
    if (Currentday >= 24 && MAX_DAY- day > 8)
    {
        return false;
    }
    else if(Currentday < 7 && day >= 7)
    {
        return false;
    }
    
    return true;
}

+(BOOL)isToday:(int)day
{
    int Currentday = [[self getCurrDay] intValue];
    
    if (day != Currentday)
    {
        return false;
    }
    return true;
}

@end
