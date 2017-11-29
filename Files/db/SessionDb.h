//
//  SessionDb.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"
#import "Db.h"

@interface SessionDb : NSObject <Db>

+(Session *)get:(NSString *)sessionId;
+(NSArray *)getAll;

@end
