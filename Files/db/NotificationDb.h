//
//  NotificationDb.h
//  emdm
//
//  Created by kdsooi on 13. 8. 6..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Notification.h"
#import "Db.h"

@interface NotificationDb : NSObject <Db>

+ (void)put:(Notification *)info;
+ (Notification *)getFirstPreDo;
+ (Notification *)getLastPreDo;
+ (Notification *)getLastNotificationInfo;
+ (NSArray *)getAll;
+ (NSArray *)getPreDoAll;
+(NotificationState)getState:(NSString *)sessionId;
+(BOOL)setState:(NSString *)sessionId :(NotificationState) mState;

@end
