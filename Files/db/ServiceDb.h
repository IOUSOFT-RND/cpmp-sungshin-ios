//
//  ServiceDb.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 1..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Db.h"
#import "ServiceInfo.h"

@interface ServiceDb : NSObject<Db>

+ (BOOL)Delete :(NSString *)mid;
+ (id)SelectQuery:(NSString *)where :(NSArray *)Args;

+ (NSArray *)getAll;
+ (BOOL )AllDelete;
+ (BOOL) isExist:(NSString *)mid;
+ (ServiceInfo *)getServiceInfo:(NSString *)mId;
+ (id)getBookmarkServiceInfo;
+ (NSArray *)getMenuAll;
+ (NSArray *)getQRServiceMenuAll:(NSString *)sid;

@end
