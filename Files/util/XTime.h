//
//  XTime.h
//  emdm
//
//  Created by jaewon on 13. 10. 15..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTime : NSObject

+(NSString *)getCurrentMonth;
+(NSString *)getCurrDayOfWeek;
+(NSString *)getCurrDay;
+(NSString *)getCurrTimeHM;
+(NSString *)getCurrTimeHMS;
+(long )getCurrMsec;
+(long )getCurrMsec :(long) msec;
+(long )getCurrMsecHM;
+(long )getMsecHM :(NSString *) time;
+(long )getConvertMsecHM :(NSString *) time;
+(NSDate *)getOneHourBefor:(NSDate *) date;
+(NSDate *)getOnedayBefor:(NSDate *) date;
+(NSString *)getCurrTimeMin;
+(BOOL)GetCurrentMonthCheck:(int)day;
+(BOOL)isToday:(int)day;
+(NSString *)getDateFormatChange:(NSString *)dateStr;
+(NSString *)getDateDayFormatChange:(NSString *)dateStr;

@end
