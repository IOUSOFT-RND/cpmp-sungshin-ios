//
//  AgentHandler.h
//  emdm
//
//  Created by kdsooi on 13. 8. 2..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DmEnumDef.h"
#import "Action.h"
#import "AppDelegate.h"

@class AgentHandler;
@class Notification;

@protocol AgentHandlerDelegate <NSObject>

@optional
- (void)AgentHandler:(AgentHandler *)aAgentHandler didFinishTask:(int)aAgentHandlerStep agentStatus:(AgentStatus)aAgentStatus;

@end

@interface AgentHandler : NSObject <ActionDelegate>
{
    @private
    Notification *notification;
    id action;
    int step;
    AgentStatus status;
    id<AgentHandlerDelegate> delegate;
}

@property (nonatomic) Notification *notification;
@property (nonatomic) id action;
@property (nonatomic) int step;
@property (nonatomic) AgentStatus status;
@property (nonatomic) id<AgentHandlerDelegate> delegate;

- (id)initWithData:(id<AgentHandlerDelegate>)aDelegate :(Notification *)aNotification;
- (void)processTask;

@end
