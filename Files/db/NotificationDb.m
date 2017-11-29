//
//  NotificationDb.m
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "NotificationDb.h"
#import "Session.h"
#import "FMDatabase.h"
#import "Notification.h"

#define DB_NAME @"notification.db"
#define TABLE_NAME @"notification_info"

#define COLUMN_NOTIFICATION_TYPE @"notification_type"
#define COLUMN_SERVICE_TYPE @"service_type"
#define COLUMN_ACTION_TYPE @"action_type"
#define COLUMN_SESSION_ID @"session_id"
#define COLUMN_SERVER_ID @"server_id"
#define COLUMN_NOTIFICATION_STATE @"notification_state"

@implementation NotificationDb

#pragma mark db protocol
+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_NOTIFICATION_TYPE];
    [sql appendString:@" INTEGER, "];
    [sql appendString:COLUMN_SERVICE_TYPE];
    [sql appendString:@" INTEGER, "];
    [sql appendString:COLUMN_ACTION_TYPE];
    [sql appendString:@" INTEGER, "];
    [sql appendString:COLUMN_SESSION_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_SERVER_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_NOTIFICATION_STATE];
    [sql appendString:@" INTEGER"];
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
    
    Notification *info = (Notification *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@",
     COLUMN_NOTIFICATION_TYPE, COLUMN_SERVICE_TYPE, COLUMN_ACTION_TYPE, COLUMN_SESSION_ID, COLUMN_SERVER_ID, COLUMN_NOTIFICATION_STATE];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[NSNumber alloc] initWithInt:info.type]];
    [values addObject:[[NSNumber alloc] initWithInt:info.serviceType]];
    [values addObject:[[NSNumber alloc] initWithInt:info.actionType]];
    [values addObject:info.sessionId];
    [values addObject:info.serverId];
    [values addObject:[[NSNumber alloc] initWithInt:info.state]];
    
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
     COLUMN_NOTIFICATION_TYPE, COLUMN_SERVICE_TYPE, COLUMN_ACTION_TYPE, COLUMN_SESSION_ID, COLUMN_SERVER_ID, COLUMN_NOTIFICATION_STATE];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];

    
    [db open];
    [db beginTransaction];
    
    for (Notification *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:[[NSNumber alloc] initWithInt:info.type]];
        [values addObject:[[NSNumber alloc] initWithInt:info.serviceType]];
        [values addObject:[[NSNumber alloc] initWithInt:info.actionType]];
        [values addObject:info.sessionId];
        [values addObject:info.serverId];
        [values addObject:[[NSNumber alloc] initWithInt:info.state]];
        
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
        Notification *info = [[Notification alloc] init];

        info.type = [resultSet intForColumn:COLUMN_NOTIFICATION_TYPE];
        info.serviceType = [resultSet intForColumn:COLUMN_SERVICE_TYPE];
        info.actionType = [resultSet intForColumn:COLUMN_ACTION_TYPE];
        info.sessionId = [resultSet stringForColumn:COLUMN_SESSION_ID];
        info.serverId = [resultSet stringForColumn:COLUMN_SERVER_ID];
        info.state = [resultSet intForColumn:COLUMN_NOTIFICATION_STATE];
        
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
        Notification *info = [[Notification alloc] init];
        
        info.type = [resultSet intForColumn:COLUMN_NOTIFICATION_TYPE];
        info.serviceType = [resultSet intForColumn:COLUMN_SERVICE_TYPE];
        info.actionType = [resultSet intForColumn:COLUMN_ACTION_TYPE];
        info.sessionId = [resultSet stringForColumn:COLUMN_SESSION_ID];
        info.serverId = [resultSet stringForColumn:COLUMN_SERVER_ID];
        info.state = [resultSet intForColumn:COLUMN_NOTIFICATION_STATE];
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}


+ (BOOL)UpdateInfo:(Notification *)aValue :(NSString *)aWhere
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
    [sql appendFormat:@"%@=?,%@=?,%@=?,",COLUMN_NOTIFICATION_TYPE,COLUMN_SERVICE_TYPE,COLUMN_ACTION_TYPE];
    [sql appendFormat:@"%@=?,%@=?,%@=?",COLUMN_SESSION_ID,COLUMN_SERVER_ID,COLUMN_NOTIFICATION_STATE];
    
    if (aWhere)
    {
        [sql appendString:@" WHERE "];
        [sql appendString:aWhere];
    }
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[[NSNumber alloc] initWithInt:aValue.type]];
    [values addObject:[[NSNumber alloc] initWithInt:aValue.serviceType]];
    [values addObject:[[NSNumber alloc] initWithInt:aValue.actionType]];
    [values addObject:aValue.sessionId];
    [values addObject:aValue.serverId];
    [values addObject:[[NSNumber alloc] initWithInt:aValue.state]];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    return isOK;
}

+ (int)RowCount:(NSString *)ColumnName :(NSString *) i
{
    int Row = -1;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    NSString *colunm  = [NSString stringWithFormat:@"COUNT(%@)",ColumnName];
    [sql appendString:@"SELECT "];
    [sql appendString:colunm];
    [sql appendString:@"FROM "];
    [sql appendString:TABLE_NAME];
    [sql appendFormat:@" WHERE %@ = %@",ColumnName,i];
    
    
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

+ (void)put:(Notification *)info
{
    if ([info isEqual:nil ])
    {
        NSLog(@"[NotificationeDb][put]NotificationInfo is Empty");
        return;
    }
    if ([self RowCount:COLUMN_SESSION_ID :[info sessionId]] > 0)
    {
        NSLog(@"[NotificationeDb][put] Update");
        [self UpdateInfo:info :[NSString stringWithFormat:@"%@ = %@",COLUMN_SESSION_ID,info.sessionId]];
    }
    else
    {
        NSLog(@"[NotificationeDb][put] Insert");
        [self Insert:info];
    }
}

+ (Notification *)getFirstPreDo
{
    Notification *info = nil;
    NSArray *result = [self SelectQuery:[NSString stringWithFormat:@"%@ = ?",COLUMN_NOTIFICATION_STATE]
                                       :[[NSArray alloc]initWithObjects:[[NSNumber alloc] initWithInt:PREDO], nil] ];
    if ([result count] > 0)
    {
        info = [result objectAtIndex:0];
    }
    
    return info;
}

+ (Notification *)getLastPreDo
{
    Notification *info = nil;
    NSArray *result = [self SelectQuery:[NSString stringWithFormat:@"%@ = ?",COLUMN_NOTIFICATION_STATE]
                                       :[[NSArray alloc]initWithObjects:[[NSNumber alloc] initWithInt:PREDO], nil] ];
    int Lastindex = (int)[result count]-1;
    
    if ([result count] > 0)
    {
        info = [result objectAtIndex:Lastindex];
    }
    
    return info;
}

+ (Notification *)getLastNotificationInfo
{
    Notification *info = nil;
    NSArray *result = [self Query:nil :nil];
    int Lastindex = (int)[result count]-1;
    
    if ([result count] > 0)
    {
        info = [result objectAtIndex:Lastindex];
    }
    
    return info;
}

+ (NSArray *)getAll
{
    return [self Query:nil :nil];
}

+ (NSArray *)getPreDoAll
{
    return [self SelectQuery:[NSString stringWithFormat:@"%@ = ?",COLUMN_NOTIFICATION_STATE]
                            :[[NSArray alloc]initWithObjects:[[NSNumber alloc] initWithInt:PREDO], nil] ];
}

+(NotificationState)getState:(NSString *)sessionId
{
    NotificationState mState = EMPTY;

    NSArray *result = [self SelectQuery:[NSString stringWithFormat:@"%@ = ?",COLUMN_SESSION_ID]
                                       :[[NSArray alloc]initWithObjects:sessionId, nil] ];
    if ([result count] > 0)
    {
        mState = [(Notification *)[result objectAtIndex:0] state];
    }
    
    return mState;
}

+(BOOL)setState:(NSString *)sessionId :(NotificationState) mState
{
    if ([sessionId length] < 1)
    {
        NSLog(@"[NotificationDb][setState] sessionId is Empty");
        return false;
    }
    
    //UPDATE tablename SET a = 100, c = 200 WHERE b = 100
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"UPDATE "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" SET "];
    [sql appendString:[NSString stringWithFormat:@"%@=?",COLUMN_NOTIFICATION_STATE]];
    [sql appendFormat:@" WHERE %@=?",COLUMN_SESSION_ID];
    
    NSMutableArray *values = [[NSMutableArray alloc]init];
    [values addObject:[[NSNumber alloc] initWithInt:mState]];
    [values addObject:sessionId];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
   
    
    [db open];
    [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    NSString * where = [NSString stringWithFormat:@"%@ = ? ",COLUMN_SESSION_ID];
    NSArray *arg = [NSArray arrayWithObjects:sessionId, nil];
    
    if([[self SelectQuery:where :arg] count] <= 0)
    {
        return  false;
    }
    
    return true;
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
