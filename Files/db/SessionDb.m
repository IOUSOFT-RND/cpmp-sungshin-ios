//
//  SessionDb.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "SessionDb.h"
#import "FMDatabase.h"
#import "Session.h"

#define DB_NAME @"session.db"
#define TABLE_NAME @"session_info"

#define COLUMN_ID @"id"
#define COLUMN_STATUS @"status"
#define COLUMN_DESCRIPTION @"description"

@implementation SessionDb

#pragma mark db protocol
+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (rowid INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_STATUS];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_DESCRIPTION];
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
    
    Session *info = (Session *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@",
     COLUMN_ID, COLUMN_STATUS, COLUMN_DESCRIPTION];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:info.sessionId];
    [values addObject:info.status];
    [values addObject:info.description];
    
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
    [sql appendFormat:@"%@, %@, %@",
     COLUMN_ID, COLUMN_STATUS, COLUMN_DESCRIPTION];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    [db beginTransaction];
    
    for (Session *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:info.sessionId];
        [values addObject:info.status];
        [values addObject:info.description];
        
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
        Session *info = [[Session alloc] init];
        
        info.sessionId = [resultSet stringForColumn:COLUMN_ID];
        info.status = [resultSet stringForColumn:COLUMN_STATUS];
        info.description = [resultSet stringForColumn:COLUMN_DESCRIPTION];
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
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
        Session *info = [[Session alloc] init];
        
        info.sessionId = [resultSet stringForColumn:COLUMN_ID];
        info.status = [resultSet stringForColumn:COLUMN_STATUS];
        info.description = [resultSet stringForColumn:COLUMN_DESCRIPTION];
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+(Session *) get:(NSString *)sessionId
{
    if([sessionId isEqualToString:@""])
    {
        NSLog(@"[SessionDB][Get]Sessionid is Empty ");
        return  nil;
    }
    NSString *where = [[NSString alloc]initWithFormat:@"%@ = ? ",COLUMN_ID];
    NSArray *arg = [NSArray arrayWithObjects:sessionId, nil];
    Session *info = [[Session alloc]init];
    NSArray *result = [self SelectQuery:where :arg];
    if([result count] > 0)
    {
        info.sessionId   = [[result objectAtIndex:0] sessionId];
        info.status      = [[result objectAtIndex:0] status];
        info.description = [[result objectAtIndex:0] description];
    }
    else
    {
        NSLog(@"[SessionDB][Get]SessionInfo is Empty ");
        return nil;
    }
    
    
    return info;
}

+(NSArray *)getAll
{
    return [self Query:nil :nil];
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
