//
//  DataBaseFileUpdataDB.m
//  emdm
//
//  Created by jaewon on 2014. 3. 24..
//
//

#import "DataBaseFileUpdataDB.h"
#import "FMDatabase.h"

@implementation DataBaseFileUpdataDB


#define DB_NAME @"dbfileInfo.db"

#define TABLE_NAME @"dbInfo"
#define COLUMN_DB_VERSION @"preVersion"
#define COLUMN_DB_DES     @"description"

#pragma mark db protocol
+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (id INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_DB_VERSION];
    [sql appendString:@" INTEGER, "];
    [sql appendString:COLUMN_DB_DES];
    [sql appendString:@" TEXT "];
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
    
    
    NSDictionary *info = (NSDictionary *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@",COLUMN_DB_VERSION, COLUMN_DB_DES];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[info objectForKey:@"Version" ]];
    [values addObject:[info objectForKey:@"Description" ]];
    
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
    [sql appendFormat:@"%@, %@",COLUMN_DB_VERSION, COLUMN_DB_DES];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    [db beginTransaction];
    
    for (NSDictionary *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:[info objectForKey:@"Version" ]];
        [values addObject:[info objectForKey:@"Description" ]];
        
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
    NSLog(@"%d",isOK);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql];
    NSLog(@"%d",isOK);
    [db close];
    
    return isOK;
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
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        
        [info setObject:[[NSNumber alloc] initWithInt:[resultSet intForColumn:COLUMN_DB_VERSION]] forKey:@"Version"];
        [info setObject:[resultSet stringForColumn:COLUMN_DB_VERSION] forKey:@"Description"] ;
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
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
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        
        [info setObject:[resultSet stringForColumn:COLUMN_DB_VERSION] forKey:@"Version"] ;
        [info setObject:[resultSet stringForColumn:COLUMN_DB_VERSION] forKey:@"Description"] ;
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+ (int)getVersion
{
    NSArray *result = [self Query:nil :nil];
    
    if (result != nil)
    {
       return [[[result objectAtIndex:0] objectForKey:@"Version"] intValue];
    }
    
    NSLog(@"[DataBaseFileUpdateDB getVersion] Fail");
    return -1;
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

+(void)dbFileUpdateCheck:(NSString *)CurrentVersion
{
    int PredbVersion = 0;
    int CurrentdbVersion = 0;
    

    CurrentdbVersion = [CurrentVersion intValue];

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self Path]])
    {
        PredbVersion = [self getVersion];
    }
    else
    {
        PredbVersion = 0;
        [self Create];
        [self eachUpdate:COLUMN_DB_VERSION :nil :[[NSNumber alloc] initWithInt:PredbVersion]];
        
    }
        
    
    if (PredbVersion == CurrentdbVersion)
    {
        return;
    }
    
    
    switch (PredbVersion)
    {
        case 0:

            break;
            
        default:
            break;
    }
    

}

@end
