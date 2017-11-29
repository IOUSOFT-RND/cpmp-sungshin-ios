//
//  ServiceDb.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 1..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "ServiceDb.h"
#import "ServerIndexEnum.h"
#import "FMDatabase.h"
#import "ServiceInfo.h"
#import "NSString+Escape.h"

#define DB_NAME @"service.db"
#define TABLE_NAME @"service_info"

#define COLUMN_ID                    @"id"
#define COLUMN_NAME                  @"name"
#define COLUMN_TYPE                  @"type"
#define COLUMN_NFCTYPE               @"nfcType"
#define COLUMN_QRTYPE                @"QRType"
#define COLUMN_CONTENTTYPE           @"contentType"
#define COLUMN_CONTENTURL            @"contentUrl"
#define COLUMN_STOREURL              @"storeUrl"
#define COLUMN_WEBCONTENTURL         @"webContentUrl"
#define COLUMN_BROWSERCONTENTURL     @"browserContentUrl"
#define COLUMN_BOOKMARK              @"bookmark"
#define COLUMN_SEQUENCE              @"sequence"
#define COLUMN_MENUSEQUENCE          @"menusequence"
#define COLUMN_ICON                  @"mIcon"
#define COLUMN_CONSTRUCTION          @"construction"
#define COLUMN_OAUTH                 @"OAuth"

@implementation ServiceDb

+ (BOOL)Create
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"CREATE TABLE IF NOT EXISTS "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" (row INTEGER PRIMARY KEY AUTOINCREMENT, "];
    [sql appendString:COLUMN_ID];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_NAME];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_TYPE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_NFCTYPE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_QRTYPE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_CONTENTTYPE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_CONTENTURL];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_STOREURL];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_WEBCONTENTURL];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_BROWSERCONTENTURL];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_BOOKMARK];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_SEQUENCE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_MENUSEQUENCE];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_ICON];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_CONSTRUCTION];
    [sql appendString:@" TEXT, "];
    [sql appendString:COLUMN_OAUTH];
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
    
    ServiceInfo *info = (ServiceInfo *)aInfo;
    
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"INSERT INTO "];
    [sql appendString:TABLE_NAME];
    [sql appendString:@" ("];
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
     COLUMN_ID, COLUMN_NAME, COLUMN_TYPE, COLUMN_NFCTYPE, COLUMN_QRTYPE, COLUMN_CONTENTTYPE, COLUMN_CONTENTURL, COLUMN_STOREURL,
     COLUMN_WEBCONTENTURL, COLUMN_BROWSERCONTENTURL, COLUMN_BOOKMARK, COLUMN_SEQUENCE,COLUMN_MENUSEQUENCE, COLUMN_ICON, COLUMN_CONSTRUCTION, COLUMN_OAUTH];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:info.Id];
    [values addObject:info.name];
    [values addObject:info.type];
    [values addObject:info.nfcType];
    [values addObject:info.QRType];
    [values addObject:info.contentType];
    [values addObject:info.contentUrl];
    [values addObject:info.storeUrl];
    [values addObject:info.webContentUrl];
    [values addObject:info.browserContentUrl];
    [values addObject:info.bookmark];
    [values addObject:info.sequence];
    [values addObject:info.menusequence];
    [values addObject:info.mIcon];
    [values addObject:info.construction];
    [values addObject:info.bOAUTH];
    
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
    [sql appendFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@",
     COLUMN_ID, COLUMN_NAME, COLUMN_TYPE, COLUMN_NFCTYPE, COLUMN_QRTYPE, COLUMN_CONTENTTYPE, COLUMN_CONTENTURL, COLUMN_STOREURL,
     COLUMN_WEBCONTENTURL, COLUMN_BROWSERCONTENTURL, COLUMN_BOOKMARK, COLUMN_SEQUENCE,COLUMN_MENUSEQUENCE, COLUMN_ICON, COLUMN_CONSTRUCTION, COLUMN_OAUTH];
    [sql appendString:@") VALUES ("];
    [sql appendString:@"?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?"];
    [sql appendString:@")"];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    [db beginTransaction];
    
    for (int i = 0; i < [aInfoArray count]; i++)//Wifi *info in aInfoArray)
    {
        NSMutableArray *values = [[NSMutableArray alloc] init];
        [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"ID"]];
        NSLog(@"APP-SERVICE Name = %@",[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"NAME"]]);
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"NAME"]]];
        [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"TYPE"]];
        [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"NFCTYPE"]];
        [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"QRTYPE"]];
        [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"CONTENTTYPE"]];
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"CONTENTURL"]]];
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"STOREURL"]]];
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"WEBCONTENTURL"]]];
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"BROWSERCONTENTURL"]]];
        
        if ([[(NSDictionary *)[aInfoArray objectAtIndex:i] allKeys] containsObject:@"BOOKMARK"])
        {
            [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"BOOKMARK"]];
        }
        else
        {
            [values addObject:@""];
        }
        
        if ([[(NSDictionary *)[aInfoArray objectAtIndex:i] allKeys] containsObject:@"SEQUENCE"])
        {
            [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"SEQUENCE"]];
        }
        else
        {
            [values addObject:@""];
        }
        
        if ([[aInfoArray objectAtIndex:i]objectForKey:@"MENUSEQUENCE"] != nil)
        {
            [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"MENUSEQUENCE"]];
        }
        else
            [values addObject:@""];
        
//        NSMutableString *iconString =[[NSMutableString alloc] initWithString:SERVER_Query_Path];
//        NSString *iconPath =[[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i] objectForKey:@"ICON"]] substringFromIndex:1];
//        [iconString appendString: iconPath];
//        [values addObject:iconString];
        
        [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i] objectForKey:@"ICON"]]];
        
        if ([[aInfoArray objectAtIndex:i]objectForKey:@"CONSTRUCTION"] != nil)
        {
            [values addObject:[NSString unescapeAddJavaUrldecode:[[aInfoArray objectAtIndex:i]objectForKey:@"CONSTRUCTION"]]];
        }
        else
            [values addObject:@""];
        
        if ([[aInfoArray objectAtIndex:i]objectForKey:@"USEOAUTH"] != nil)
        {
            [values addObject:[[aInfoArray objectAtIndex:i]objectForKey:@"USEOAUTH"]];
        }
        else
            [values addObject:@""];
        
        
        
        
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
        return [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    while ([resultSet next])
    {
        ServiceInfo *info = [[ServiceInfo alloc] init];
        
        info.Id = [resultSet stringForColumn:COLUMN_ID];
        info.name = [resultSet stringForColumn:COLUMN_NAME];
        info.type = [resultSet stringForColumn:COLUMN_TYPE];
        info.nfcType = [resultSet stringForColumn:COLUMN_NFCTYPE];
        info.QRType = [resultSet stringForColumn:COLUMN_QRTYPE];
        info.contentType = [resultSet stringForColumn:COLUMN_CONTENTTYPE];
        info.contentUrl = [resultSet stringForColumn:COLUMN_CONTENTURL];
        info.storeUrl = [resultSet stringForColumn:COLUMN_STOREURL];
        info.webContentUrl = [resultSet stringForColumn:COLUMN_WEBCONTENTURL];
        info.browserContentUrl = [resultSet stringForColumn:COLUMN_BROWSERCONTENTURL];
        info.bookmark = [resultSet stringForColumn:COLUMN_BOOKMARK];
        info.sequence = [resultSet stringForColumn:COLUMN_SEQUENCE];
        info.menusequence = [resultSet stringForColumn:COLUMN_MENUSEQUENCE];
        info.mIcon = [resultSet stringForColumn:COLUMN_ICON];
        info.construction = [resultSet stringForColumn:COLUMN_CONSTRUCTION];
        info.bOAUTH = [resultSet stringForColumn:COLUMN_OAUTH];
        
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
        return [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
    while ([resultSet next])
    {
        ServiceInfo *info = [[ServiceInfo alloc] init];
        
        info.Id = [resultSet stringForColumn:COLUMN_ID];
        info.name = [resultSet stringForColumn:COLUMN_NAME];
        info.type = [resultSet stringForColumn:COLUMN_TYPE];
        info.nfcType = [resultSet stringForColumn:COLUMN_NFCTYPE];
        info.QRType = [resultSet stringForColumn:COLUMN_QRTYPE];
        info.contentType = [resultSet stringForColumn:COLUMN_CONTENTTYPE];
        info.contentUrl = [resultSet stringForColumn:COLUMN_CONTENTURL];
        info.storeUrl = [resultSet stringForColumn:COLUMN_STOREURL];
        info.webContentUrl = [resultSet stringForColumn:COLUMN_WEBCONTENTURL];
        info.browserContentUrl = [resultSet stringForColumn:COLUMN_BROWSERCONTENTURL];
        info.bookmark = [resultSet stringForColumn:COLUMN_BOOKMARK];
        info.sequence = [resultSet stringForColumn:COLUMN_SEQUENCE];
        info.menusequence = [resultSet stringForColumn:COLUMN_MENUSEQUENCE];
        info.mIcon = [resultSet stringForColumn:COLUMN_ICON];
        info.construction = [resultSet stringForColumn:COLUMN_CONSTRUCTION];
        info.bOAUTH = [resultSet stringForColumn:COLUMN_OAUTH];
        
        [infoArray addObject:info];
    }
    
    [db close];
    
    return infoArray;
}

+ (BOOL)Delete :(NSString *) mid
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"DELETE FROM "];
    [sql appendString:TABLE_NAME];
    [sql appendFormat:@" WHERE %@ = ?",COLUMN_ID];
    
    NSArray *values = [NSArray arrayWithObjects:mid, nil];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql withArgumentsInArray:values];
    [db close];
    
    return isOK;
}


+ (ServiceInfo *)getServiceInfo:(NSString *)mId
{
    if([mId length] < 1)
    {
        NSLog(@"[ServiceDb][getServiceInfo]ID is Empty");
        return false;
    }
    
    NSArray *serviecInfos = [self SelectQuery :[NSString stringWithFormat:@"%@ = ?",COLUMN_ID]
                                           :[[NSArray alloc] initWithObjects:mId, nil]];
    
    return [serviecInfos objectAtIndex:0];
}

+ (id)getBookmarkServiceInfo
{
    
    NSMutableArray *serviecInfos = [self Query :[NSString stringWithFormat:@"%@ IS NOT NULL AND %@ != \"\"  AND %@ >= 10000",COLUMN_SEQUENCE,COLUMN_SEQUENCE,COLUMN_TYPE]
                                        :[NSString stringWithFormat:@"CAST(%@ AS int) ASC",COLUMN_SEQUENCE]];
    
    return serviecInfos;
}


+ (NSArray *)getAll
{
    return  [self SelectQuery :nil:nil];
}

+(NSArray *)getMenuAll
{
    NSMutableArray *serviecInfos = [self Query :[NSString stringWithFormat:@"%@ >= 10000",COLUMN_TYPE]
                                               :[NSString stringWithFormat:@"CAST(%@ AS int) ASC",COLUMN_MENUSEQUENCE]];
    return serviecInfos;
}

+(NSArray *)getQRServiceMenuAll:(NSString *)sid
{
    NSMutableArray *serviecInfos = [self SelectQuery:[NSString stringWithFormat:@" %@ = ? OR %@ LIKE  ? ",COLUMN_QRTYPE,COLUMN_QRTYPE]
                                                    :[[NSArray alloc] initWithObjects:sid,@"%-%", nil] ];
    
    return serviecInfos;
}


+ (BOOL )AllDelete
{
    NSMutableString *sql = [[NSMutableString alloc] init];
    [sql appendString:@"DROP TABLE "];
    [sql appendString:TABLE_NAME];
    
    BOOL isOK = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    FMDatabase *db = [FMDatabase databaseWithPath:[documentsDirectory stringByAppendingPathComponent:DB_NAME]];
    
    [db open];
    isOK = [db executeUpdate:sql];
    [db close];
    
    [self Create];
    
    return isOK;
}

+ (BOOL) isExist:(NSString *)mid
{
    if([mid length] < 1)
    {
        NSLog(@"[ServiceDb][getServiceInfo]ID is Empty");
        return false;
    }
    
    NSArray *ServiceInfos = [self SelectQuery :[NSString stringWithFormat:@" %@ = ?",COLUMN_ID]
                                           :[[NSArray alloc] initWithObjects:mid, nil]];
    
    if ([ServiceInfos count] > 0)
    {
        return YES;
    }
    
    return NO;
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
