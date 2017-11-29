//
//  Agent.h
//  emdm
//
//  Created by kdsooi on 13. 8. 1..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgentHandler.h"

@class Agent;
@class Notification;

@protocol AgentDelegate <NSObject>

@optional
- (void)Agent:(Agent *)aAgent didFinish:(AgentStatus)aAgentStatus;
- (void)Agent:(Agent *)aAgent didFail:(AgentStatus)aAgentStatus;

@end


@interface Agent : NSThread <AgentHandlerDelegate>
{
    @private
    id<AgentDelegate> delegate;
    Notification *notification;
    AgentHandler *handler;
}

@property (nonatomic) id<AgentDelegate> delegate;
@property (nonatomic) Notification *notification;
@property (nonatomic) AgentHandler *handler;

- (id)initWithData:(id<AgentDelegate>)aDelegate :(Notification *)aNotification;
- (void)start;

@end
