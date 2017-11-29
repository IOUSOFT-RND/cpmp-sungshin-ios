//
//  ProfileDb.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Db.h"
#import "Profiles.h"

#define DB_NAME @"profile.db"
#define TABLE_NAME @"profile_info"

#define COLUMN_NAME @"name"
#define COLUMN_SERVER_ID @"server_id"
#define COLUMN_SERVER_URL @"server_url"
#define COLUMN_ENABLED @"enabled"
#define COLUMN_PRIORITY @"priority"
#define COLUMN_INITIATED @"initiated"

@interface ProfileDb : NSObject <Db>

+ (BOOL)Delete :(NSString *) serverId;
+ (void)put:(Profile *)info :(int) i;
+ (id)SelectQuery:(NSString *)where :(NSArray *)Args;
+ (NSString *)getServerUrl;
+ (NSString *)getServerName;
+ (NSString *)getServerId:(NSString *)priority;
+ (BOOL)isEnabled:(NSString *)priority;
+ (NSArray *)getEnabledAll:(BOOL)isEnabled;
+ (BOOL)isInitiated;
+ (BOOL)isInitiated :(NSString *) priority;
+ (NSArray *)getInitiatedAll:(BOOL)isInitiated;
+ (void) setInitiated:(NSString *) priority :(BOOL) isIniated;


@end
