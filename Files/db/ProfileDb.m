//
//  ProfileDb.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "ProfileDb.h"
#import "FMDatabase.h"
#import "Profiles.h"



@implementation ProfileDb

#pragma mark db protocol
+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_NAME];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_SERVER_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_SERVER_URL];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_ENABLED];
    [sql appendString:@" BOOL, "];
    [sql appendString:COLUMN_PRIORITY];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_INITIATED];
    [sql appendString:@" BOOL"];
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
    if ([aInfo isEqual:nil])
    {
        NSLog(@"aInfo == nil");
        return NO;
    }
    
    Profile *info = (Profile *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@",
     COLUMN_NAME, COLUMN_SERVER_ID, COLUMN_SERVER_URL, COLUMN_ENABLED, COLUMN_PRIORITY, COLUMN_INITIATED];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:info.name];
    [values addObject:info.serverId];
    [values addObject:info.serverUrl];
    [values addObject:[[NSNumber alloc] initWithBool:[info.enabled boolValue]]];
    [values addObject:info.priority];
    [values addObject:[[NSNumber alloc] initWithBool:[info.initiated boolValue]]];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    NSLog(@"Insert OK");
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
     COLUMN_NAME, COLUMN_SERVER_ID, COLUMN_SERVER_URL, COLUMN_ENABLED, COLUMN_PRIORITY, COLUMN_INITIATED];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    [db beginTransaction];
    
    for (Profile *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:info.name];
        [values addObject:info.serverId];
        [values addObject:info.serverUrl];
        [values addObject:[[NSNumber alloc] initWithBool:[info.enabled boolValue]]];
        [values addObject:info.priority];
        [values addObject:[[NSNumber alloc] initWithBool:[info.initiated boolValue]]];
        
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

+ (BOOL)Delete :(NSString *) serverId
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"DELETE FROM "];
    [sql appendString:TABLE_NAME];
    [sql appendFormat:@"WHERE %@ =?",COLUMN_SERVER_ID];
    
    NSArray *values = [NSArray arrayWithObjects:serverId, nil];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
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
        Profile *info = [[Profile alloc] init];
        
        info.name = [resultSet stringForColumn:COLUMN_NAME];
        info.serverId = [resultSet stringForColumn:COLUMN_SERVER_ID];
        info.serverUrl = [resultSet stringForColumn:COLUMN_SERVER_URL];
        info.enabled = [resultSet boolForColumn:COLUMN_ENABLED] ? @"YES" : @"NO";
        info.priority = [resultSet stringForColumn:COLUMN_PRIORITY];
        info.initiated = [resultSet boolForColumn:COLUMN_INITIATED] ? @"YES" : @"NO";
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+ (BOOL)UpdateInfo:(Profile *)aValue :(NSString *)aWhere
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
    [sql appendFormat:@"%@=?,%@=?,%@=?,",COLUMN_NAME,COLUMN_SERVER_ID,COLUMN_SERVER_URL];
    [sql appendFormat:@"%@=?,%@=?,%@=?",COLUMN_ENABLED,COLUMN_PRIORITY,COLUMN_INITIATED];
    
    if (aWhere)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:aWhere];
    }
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:aValue.name];
    [values addObject:aValue.serverId];
    [values addObject:aValue.serverUrl];
    [values addObject:[[NSNumber alloc] initWithBool:[aValue.enabled boolValue]]];
    [values addObject:aValue.priority];
    [values addObject:[[NSNumber alloc] initWithBool:[aValue.initiated boolValue]]];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    return isOK;
}

+ (id)SelectQuery:(NSString *)where :(NSArray *)Args
{
    //SELECT * FROM tablename WHERE v > 100 AND t = test ORDER BY column ASC DESC
    //SELECT id, name FROM users
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"SELECT * FROM "];
    [sql appendString:TABLE_NAME];
    
    if (where)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:where];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:Args];
    if (!resultSet)
    {
        NSLog(@"resultSet == nil");
        return nil;
    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    while ([resultSet next])
    {
        Profile *info = [[Profile alloc] init];
        
        info.name = [resultSet stringForColumn:COLUMN_NAME];
        info.serverId = [resultSet stringForColumn:COLUMN_SERVER_ID];
        info.serverUrl = [resultSet stringForColumn:COLUMN_SERVER_URL];
        info.enabled = [resultSet boolForColumn:COLUMN_ENABLED] ? @"YES" : @"NO";
        info.priority = [resultSet stringForColumn:COLUMN_PRIORITY];
        info.initiated = [resultSet boolForColumn:COLUMN_INITIATED] ? @"YES" : @"NO";
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+ (void)put:(Profile *)info :(int) i
{
    if ([info isEqual:nil ])
    {
        NSLog(@"[ProfileDb][put]ProfileInfo is Empty");
        return;
    }
    if ([self RowCount:@"id" :i] > 0)
    {
        NSLog(@"[ProfileDb][put] Update");
        [self UpdateInfo:info :[NSString stringWithFormat:@"id = %d",i]];
    }
    else
    {
        NSLog(@"[ProfileDb][put] Insert");
        [self Insert:info];
    }
}

+ (BOOL)eachInsert:(NSString *)mColunmName :(id)aInfo
{
    if (aInfo== nil)
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

+ (BOOL)eachUpdate:(NSString *)mColunmName :(NSString *) where :(id)mValue
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
    
    if ([where length] > 0)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:where];
        values = mValue;
    }
    else
    {
        [values addObject:mValue];
    }
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    
    if ([values count] > 1)
    {
        if ([[self SelectQuery:where :[NSArray arrayWithObjects:[values objectAtIndex:1], nil]] count] > 0)
        {
            [db open];
            NSLog(@"ProfileDB eachUpdate");
            isOK = [db executeUpdate:sql withArgumentsInArray:values];
            [db close];
        }
        else
        {
            NSLog(@"ProfileDB eachInsert");
            isOK =[self eachInsert:mColunmName :[values objectAtIndex:0]];
        }
    }
    else
    {
        if([[self Query:nil :nil] count] > 0)
        {
            [db open];
            NSLog(@"ProfileDB eachUpdate");
            isOK = [db executeUpdate:sql withArgumentsInArray:values];
            [db close];
        }
        else
        {
            NSLog(@"ProfileDB eachInsert");
            isOK =[self eachInsert:mColunmName :mValue];
            
        }
    }
    
    return isOK;
}

+ (int)RowCount:(NSString *)ColumnName :(int) i
{
    int Row = -1;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    NSString *colunm  = [NSString stringWithFormat:@"COUNT(%@)",ColumnName];
    [sql appendString:@"SELECT "];
    [sql appendString:colunm];
    [sql appendString:@"FROM "];
    [sql appendString:TABLE_NAME];
    [sql appendFormat:@" WHERE id = %d",i];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    [db open];
    
    FMResultSet *resultSet = [db executeQuery:sql];
    
    while ([resultSet next])
    {
        Row = [resultSet intForColumn:colunm];
    }
    
    [db close];
    return Row;
}

+ (NSString *)getServerUrl
{
    NSString *value = nil;
    NSString *where = [NSString stringWithFormat:@"%@ =? AND %@ =?",COLUMN_ENABLED,COLUMN_PRIORITY];
    NSArray *arg = [NSArray arrayWithObjects:[[NSNumber alloc] initWithBool:true],@"default", nil];
    NSArray *ProfileInfos = [self SelectQuery:where :arg];
    if ([ProfileInfos count] > 0)
    {
        value = [[ProfileInfos objectAtIndex:0] serverUrl];
    }
    
    return value;
}

+ (NSString *)getServerName
{
    NSString *value = nil;
    NSString *where = [NSString stringWithFormat:@"%@ =? AND %@ =?",COLUMN_ENABLED,COLUMN_PRIORITY];
    NSArray *arg = [NSArray arrayWithObjects:[[NSNumber alloc] initWithBool:true],@"default", nil];
    NSArray *ProfileInfos = [self SelectQuery:where :arg];
    for (int i = 0; i < [ProfileInfos count]; i++)
    {
        if([[[ProfileInfos objectAtIndex:i] enabled] isEqual:@"YES"])
            value = [(Profile *)[ProfileInfos objectAtIndex:i] name];
    }
    
    return value;
}

+ (NSString *)getServerId:(NSString *)priority
{
    if([priority length] < 1)
    {
        NSLog(@"[ProfileDb][getServerId]priority is Empty");
        return false;
    }
    
    NSString *value = nil;
    NSArray *ProfileInfos = [self SelectQuery :[NSString stringWithFormat:@"%@ = ?",COLUMN_PRIORITY]
                                              :[[NSArray alloc] initWithObjects:priority, nil]];
    
    for (int i = 0; i < [ProfileInfos count]; i++)
    {
        if([[[ProfileInfos objectAtIndex:i] enabled] isEqual:@"YES"])
           value = [[ProfileInfos objectAtIndex:0] serverId];
    }
    
    return value;
    
}

+ (BOOL)isEnabled:(NSString *)priority
{
    if([priority length] < 1)
    {
        NSLog(@"[ProfileDb][isEnabled]priority is Empty");
        return false;
    }
    
    BOOL value = false;
    NSArray *ProfileInfos = [self SelectQuery :[NSString stringWithFormat:@"%@ = ?",COLUMN_PRIORITY]
                                              :[[NSArray alloc] initWithObjects:priority, nil]];
    
    for (int i = 0; i < [ProfileInfos count]; i++)
    {
        if([[[ProfileInfos objectAtIndex:i] enabled] isEqual:@"YES"])
            value = true;
    }
    
    return value;
    
}

+ (NSArray *)getEnabledAll:(BOOL)isEnabled
{
    
    NSArray *result = [self SelectQuery :[NSString stringWithFormat:@"%@ = ?",COLUMN_ENABLED]
                                        :[[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithBool:isEnabled], nil]];
    return result;
    
}

+ (BOOL)isInitiated
{
    BOOL value = false;
    NSArray *ProfileInfos = [self Query:nil :nil];
    for (int i = 0; i < [ProfileInfos count]; i++)
    {
        if([[[ProfileInfos objectAtIndex:i] initiated] isEqual:@"YES"])
            value = true;
    }
    
    return value;
}

+ (BOOL)isInitiated :(NSString *) priority
{
    BOOL value = false;
    NSArray *ProfileInfos = [self SelectQuery :[NSString stringWithFormat:@"%@ = ?",COLUMN_PRIORITY]
                                              :[[NSArray alloc] initWithObjects:priority, nil]];
    for (int i = 0; i < [ProfileInfos count]; i++)
    {
        if([[[ProfileInfos objectAtIndex:i] initiated] isEqual:@"YES"])
            value = true;
    }
    
    return value;
}

+ (NSArray *)getInitiatedAll:(BOOL)isInitiated
{
    NSArray *args = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithBool:isInitiated], nil];
    NSArray *ProfileInfos = [self SelectQuery:[NSString stringWithFormat:@"%@ = ?",COLUMN_INITIATED]
                                             :args];
    
    return ProfileInfos;
}

+ (void) setInitiated:(NSString *) priority :(BOOL) isIniated
{
    if([priority length] < 1 )
    {
        NSLog(@"[ProfileDb][setInitiated]priority is Empty");
        return;
    }
    NSArray *value = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithBool:isIniated],priority, nil];
    
    [self eachUpdate:COLUMN_INITIATED
                    :[NSString stringWithFormat:@"%@=?",COLUMN_PRIORITY] :value];
    
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

@end
