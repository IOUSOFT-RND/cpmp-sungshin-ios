//
//  DeviceDb.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DeviceDb.h"
#import "FMDatabase.h"
#import "Device.h"

#define DB_NAME @"device.db"
#define TABLE_NAME @"device_info"

#define COLUMN_ADMINISTRATED @"administrated"
#define COLUMN_REGISTERED @"registered"
#define COLUMN_APNS_REGISTERED @"apns_registered"
#define COLUMN_APNS_ID @"apns_id"
#define COLUMN_PROFILE_LOADED @"profile_loaded"
#define COLUMN_CONTROLLING @"controlling"
#define COLUMN_ADMINISTRAT_PASSWORD @"administart_password"
#define COLUMN_APP_VERSION @"app_version"

@implementation DeviceDb

#pragma mark db protocol
+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_ADMINISTRATED];
    [sql appendString:@" BOOL, "];
    [sql appendString:COLUMN_REGISTERED];
    [sql appendString:@" BOOL, "];
    [sql appendString:COLUMN_APNS_REGISTERED];
    [sql appendString:@" BOOL, "];
    [sql appendString:COLUMN_APNS_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_PROFILE_LOADED];
    [sql appendString:@" BOOL, "];
    [sql appendString:COLUMN_CONTROLLING];
    [sql appendString:@" BOOL,"];
    [sql appendString:COLUMN_ADMINISTRAT_PASSWORD];
    [sql appendString:@" TEXT,"];
    [sql appendString:COLUMN_APP_VERSION];
    [sql appendString:@" TEXT"];
    [sql appendString:@");"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql];
    [db close];
    
    return isOK;
}

+ (BOOL)Insert:(id)aInfo
{
    if (!aInfo)
    {
        NSLog(@"aInfo == nil");
        return NO;
    }
    
    Device *info = (Device *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@",
     COLUMN_ADMINISTRATED, COLUMN_REGISTERED, COLUMN_APNS_REGISTERED, COLUMN_APNS_ID, COLUMN_PROFILE_LOADED, COLUMN_CONTROLLING];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[NSNumber alloc] initWithBool:info.administrated]];
    [values addObject:[[NSNumber alloc] initWithBool:info.registered]];
    [values addObject:[[NSNumber alloc] initWithBool:info.apnsRegistered]];
    [values addObject:info.apnsId];
    [values addObject:[[NSNumber alloc] initWithBool:info.profileLoaded]];
    [values addObject:[[NSNumber alloc] initWithBool:info.controlling]];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    return isOK;
}

+ (BOOL)Transaction:(NSArray *)aInfoArray
{
    if ((!aInfoArray) || ([aInfoArray count] <= 0))
    {
        NSLog(@"aInfoArray == nil");
        return NO;
    }
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@",
     COLUMN_ADMINISTRATED, COLUMN_REGISTERED, COLUMN_APNS_REGISTERED, COLUMN_APNS_ID, COLUMN_PROFILE_LOADED, COLUMN_CONTROLLING];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    [db beginTransaction];
    
    for (Device *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:[[NSNumber alloc] initWithBool:info.administrated]];
        [values addObject:[[NSNumber alloc] initWithBool:info.registered]];
        [values addObject:[[NSNumber alloc] initWithBool:info.apnsRegistered]];
        [values addObject:info.apnsId];
        [values addObject:[[NSNumber alloc] initWithBool:info.profileLoaded]];
        [values addObject:[[NSNumber alloc] initWithBool:info.controlling]];
        
        isOK = [db executeUpdate:sql withArgumentsInArray:values];
        if (!isOK)
        {
            break;
        }
    }
    
    if (isOK)
    {
        [db commit];
    }
    else
    {
        [db rollback];
    }
    
    [db close];
    
    return isOK;
}

+ (BOOL)Update:(NSString *)aValue :(NSString *)aWhere
{
    if (!aValue)
    {
        NSLog(@"aValue == nil");
        return NO;
    }
    
    //UPDATE tablename SET a = 100, c = 200 WHERE b = 100
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"UPDATE "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" SET "];
    [sql appendString:aValue];
    
    if (aWhere)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:aWhere];
    }
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql];
    [db close];
    
    return isOK;
}

+ (BOOL)Delete
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"DELETE FROM "];
    [sql appendString:TABLE_NAME];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql];
    [db close];
    
    return isOK;
}

+ (id)Query:(NSString *)aWhere :(NSString *)aOrder
{
    //SELECT * FROM tablename WHERE v > 100 AND t = test ORDER BY column ASC DESC
    //SELECT id, name FROM users
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT * FROM "];
    [sql appendString:TABLE_NAME];
    
    if (aWhere)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:aWhere];
    }
    
    if (aOrder)
    {
        [sql appendString:@" ORDER BY "];
        [sql appendString:aOrder];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    if (!resultSet)
    {
        NSLog(@"resultSet == nil");
        return nil;
    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    while ([resultSet next])
    {
        Device *info = [[Device alloc] init];
        
        info.administrated = [resultSet boolForColumn:COLUMN_ADMINISTRATED];
        info.registered = [resultSet boolForColumn:COLUMN_REGISTERED];
        info.apnsRegistered = [resultSet boolForColumn:COLUMN_APNS_REGISTERED];
        info.apnsId = [resultSet stringForColumn:COLUMN_APNS_ID];
        info.profileLoaded = [resultSet boolForColumn:COLUMN_PROFILE_LOADED];
        info.controlling = [resultSet boolForColumn:COLUMN_CONTROLLING];
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+ (NSString *)Path
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:DB_NAME];
}

+ (NSString *)DbName
{
    return DB_NAME;
}

+ (BOOL)eachInsert:(NSString *)mColunmName :(id)aInfo
{
    if (!aInfo)
    {
        NSLog(@"aInfo == nil");
        return NO;
    }
    
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@",mColunmName];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?"];
    [sql appendString:@")"];
    
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:aInfo];
   
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    return isOK;
}

+ (BOOL)eachUpdate:(NSString *)mColunmName :(id)mValue
{
    if (mValue == nil)
    {
        NSLog(@"aValue == nil");
        return NO;
    }
    
    //UPDATE tablename SET a = 100, c = 200 WHERE b = 100
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"UPDATE "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" SET "];
    [sql appendString:[NSString stringWithFormat:@"%@=?",mColunmName]];
   
    NSMutableArray *values = [[NSMutableArray alloc]init];
    [values addObject:mValue];

    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    
    if([[self Query:nil :nil] count] > 0)
    {
        NSLog(@"DeviceDB eachUpdate");
        [db open];
        isOK = [db executeUpdate:sql withArgumentsInArray:values];
        [db close];
    }
    else
    {
        NSLog(@"DeviceDB eachInsert");
        isOK =[self eachInsert:mColunmName :mValue];
    }
    
    
    return isOK;
}

+(Device *)getDevice
{
    NSArray *result = [self Query:nil :nil];
    if([result count] > 0)
    {
        return [result objectAtIndex:0];
    }
    else
        NSLog(@"[DeviceDb][getDevice]DeviceInfo is Empty");
    
    return nil;
}

+(void)putDevice:(Device *)info
{
    if([info isKindOfClass:nil])
    {
        NSLog(@"[DeviceDb][putDevice] info is Empty");
        return;
    }
    
    [self Delete];
    [self Insert:info];
}

+(BOOL)isDeviceProfileLoaded
{
    BOOL value = false;
    NSArray *DeviceInfos = [self Query:nil :nil];
    if ([DeviceInfos count] > 0)
    {
        value = [[DeviceInfos objectAtIndex:0] profileLoaded];
    }
    
    return value;
}

+(void)setDeviceProfileLoaded:(BOOL) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_PROFILE_LOADED :[[NSNumber alloc] initWithBool:value]];
}

+(BOOL)isDeviceAdminstrated
{
    BOOL value = false;
    NSArray *DeviceInfos =  [self Query:nil :nil];
    if ([DeviceInfos count] > 0)
    {
        value = [[DeviceInfos objectAtIndex:0] administrated];
    }
    
    return value;
}

+(void)setDeviceAdminstrated:(BOOL) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_ADMINISTRATED :[[NSNumber alloc] initWithBool:value]];
}

+(NSString *)getDeviceAdminstratedPassword
{
    
    NSString *value = nil;
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT * FROM "];
    [sql appendString:TABLE_NAME];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    if (!resultSet)
    {
        NSLog(@"resultSet == nil");
        return nil;
    }
    
    
    while ([resultSet next])
    {
        value = [resultSet stringForColumn:COLUMN_ADMINISTRAT_PASSWORD];
    }
    
    [db close];
    
    return value;
}

+(void)setDeviceAdminstratedPassword:(NSString *) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_ADMINISTRAT_PASSWORD :value];
}

+(BOOL)isDeviceRegistered
{
    BOOL value = false;
    NSArray *DeviceInfos = [[NSArray alloc]initWithArray: [self Query:nil :nil]];
    if ([DeviceInfos count] > 0)
    {
        value = [[DeviceInfos objectAtIndex:0] registered];
    }
    
    return value;
}

+(void)setDeviceRegistered:(BOOL) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_REGISTERED :[[NSNumber alloc] initWithBool:value]];
}

+(BOOL)isDeviceApnsRegistered
{
    BOOL value = false;
    NSArray *DeviceInfos = [[NSArray alloc]initWithArray: [self Query:nil :nil]];
    if ([DeviceInfos count] > 0)
    {
        value = [[DeviceInfos objectAtIndex:0] apnsRegistered];
    }
    
    return value;
}

+(void)setDeviceApnsRegistered:(BOOL) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_APNS_REGISTERED :[[NSNumber alloc] initWithBool:value]];
}

+(NSString *)getDeviceApnsId
{
    
    NSString *value = nil;
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT * FROM "];
    [sql appendString:TABLE_NAME];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    if (!resultSet)
    {
        NSLog(@"resultSet == nil");
        return nil;
    }
    
    
    while ([resultSet next])
    {
        value = [resultSet stringForColumn:COLUMN_APNS_ID];
    }
    
    [db close];
    
    return value;
}

+(void)setDeviceApnsId:(NSString *) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_APNS_ID :value];
}

+(BOOL)isDeviceControl
{
    BOOL value = false;
    NSArray *DeviceInfos = [self Query:nil :nil];
    if ([DeviceInfos count] > 0)
    {
        value = [[DeviceInfos objectAtIndex:0] controlling];
    }
    
    return value;
}

+(void)setDeviceApnsControl:(BOOL) value
{
    NSLog(@"DeviceDB setDeviceProfileLoaded");
    [self eachUpdate:COLUMN_CONTROLLING :[[NSNumber alloc] initWithBool:value]];
}

+(void) setAppVersion :(NSString *) value
{
    NSLog(@"DeviceDB setAppVersion");
    [self eachUpdate:COLUMN_APP_VERSION :value];
}

+(NSString *)getAppVersion
{
    NSString *value = @"";
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT * FROM "];
    [sql appendString:TABLE_NAME];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    if (!resultSet)
    {
        NSLog(@"resultSet == nil");
        return nil;
    }
    
    
    while ([resultSet next])
    {
        value = [resultSet stringForColumn:COLUMN_APP_VERSION];
    }
    
    NSLog(@"value %@",value);
    
    if ([value isEqualToString:@""]|| value == nil)
    {
        value = [Device getAppVersion];
        [self setAppVersion:value];
    }
    
    [db close];
    
    return value;

}


@end
