//
//  Agent.m
//  emdm
//
//  Created by kdsooi on 13. 8. 1..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Agent.h"
#import "NotificationDb.h"
#import "Agent+Status.h"
#import "AgentHandler.h"
#import "Notification.h"
#import "NotificationName.h"

@implementation Agent
@synthesize delegate;
@synthesize notification;
@synthesize handler;

- (id)initWithData:(id<AgentDelegate>)aDelegate :(Notification *)aNotificaiton
{
    self = [super init];
    if (!self)
        return nil;
    
    delegate = aDelegate;
    notification = aNotificaiton;
    handler = [[AgentHandler alloc] initWithData:self :notification];
    
    return self;
}


- (void)start
{
    [handler processTask];
}

- (void)AgentHandler:(AgentHandler *)aAgentHandler didFinishTask:(int)aAgentHandlerStep agentStatus:(AgentStatus)aAgentStatus
{
    NSLog(@"didFinishTask aAgentHandlerStep : %d, aAgentStatus : %@", aAgentHandlerStep, [Agent getStatusString:aAgentStatus]);
    
    if (aAgentHandlerStep == PROCESS_END)
    {
        [NotificationDb setState:[notification sessionId] : DONE];
        if (delegate && [delegate respondsToSelector:@selector(Agent:didFinish:)])
        {
            [delegate Agent:self didFinish:aAgentStatus];
            
        }
    }
    else if (aAgentHandlerStep == PROCESS_ERROR)
    {
        if (delegate && [delegate respondsToSelector:@selector(Agent:didFail:)])
        {
            [delegate Agent:self didFail:aAgentStatus];
            [NotificationDb setState:[notification sessionId] : DONE];
        }
        
        if (aAgentStatus == DEVICE_PHONENUMBER_NOT_FOUND)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:UnRegister_USER_ERROR object:nil];
        }
    }
    
    if (aAgentHandlerStep != PROCESS_FINISH)
        [handler processTask];
}

@end
