//
//  Notification.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EnumDef.h"

@interface Notification : NSObject
{
    @private
    int columId;
    NotificationType type;
    NotificationState state;
    ServiceType serviceType;
    ActionType actionType;
    NSString *sessionId;
    NSString *serverId;
}

@property (nonatomic) NotificationType type;
@property (nonatomic) NotificationState state;
@property (nonatomic) ServiceType serviceType;
@property (nonatomic) ActionType actionType;
@property (nonatomic) NSString *sessionId;
@property (nonatomic) NSString *serverId;
@property (nonatomic) int columId;

@end
