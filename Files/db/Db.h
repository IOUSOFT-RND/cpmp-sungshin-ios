//
//  Db.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Db <NSObject>

+ (BOOL)Create;
+ (BOOL)Insert:(id)aInfo;
+ (BOOL)Transaction:(NSArray *)aInfoArray;
+ (BOOL)Update:(NSString *)aValue :(NSString *)aWhere;
+ (BOOL)Delete;
+ (id)Query:(NSString *)aWhere :(NSString *)aOrder;
+ (NSString *)Path;
+ (NSString *)DbName;

@end
