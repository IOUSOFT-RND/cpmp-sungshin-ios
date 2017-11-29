//
//  AgentHandler.m
//  emdm
//
//  Created by kdsooi on 13. 8. 2..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "DbProvider.h"

#import "AgentHandler.h"
#import "Notification.h"



@implementation AgentHandler
@synthesize notification;
@synthesize action;
@synthesize step;
@synthesize status;
@synthesize delegate;

- (id)initWithData:(id<AgentHandlerDelegate>)aDelegate :(Notification *)aNotification
{
    self = [super init];
    if (!self)
        return nil;
    

    
    self.delegate = aDelegate;
    self.notification = aNotification;
    self.step = PROCESS_INIT;
    
    return self;
}

- (void)processTask
{
    NSLog(@"handler step : %d", step);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        switch (step)
        {
            case PROCESS_INIT:
                status = [self processInit];
                if (status == OK)
                    step = PROCESS_PKG1;
                else
                    step = PROCESS_ERROR;
                [self respondToAgent];
                break;
                
            case PROCESS_PKG1:
                status = [self processPkgOne];
                if (status != OK)
                    step = PROCESS_ERROR;
                break;
                
            case PROCESS_PKG2:
                status = [self processPkgTwo];
                if (status == CLIENT_NEXT)
                    step = PROCESS_PKG3;
                else if (status == CLIENT_END)
                    step = PROCESS_END;
                else
                    step = PROCESS_ERROR;
                [self respondToAgent];
                break;
                
            case PROCESS_PKG3:
                status = [self processPkgThree];
                if (status != OK)
                    step = PROCESS_ERROR;
                break;
                
            case PROCESS_PKG4:
                status = [self processPkgFour];
                if (status == CLIENT_NEXT)
                    step = PROCESS_PKG3;
                else if (status == CLIENT_END)
                    step = PROCESS_END;
                else
                    step = PROCESS_ERROR;
                [self respondToAgent];
                break;
                
            case PROCESS_END:
                [self processPkgEnd:status];
                step = PROCESS_FINISH;
                [self respondToAgent];
                break;
                
            case PROCESS_ERROR:
                [self processPkgError:status];
                step = PROCESS_FINISH;
                [self respondToAgent];
                break;
                
            default:
                step = PROCESS_FINISH;
                [self respondToAgent];
                break;
        }
    });
}

- (void)respondToAgent
{
    if (delegate && [delegate respondsToSelector:@selector(AgentHandler:didFinishTask:agentStatus:)])
    {
        [delegate AgentHandler:self didFinishTask:step agentStatus:status];
    }
}

- (AgentStatus)processInit
{
    NSLog(@"processInit");
    
    if (!notification)
    {
        NSLog(@"notification == nil");
        return BAD_REQUEST;
    }
    
    switch (notification.actionType)
    {
        default:
            action = nil;
            NSLog(@"unknown action type");
            break;
    }
    
    return OK;
}

- (AgentStatus)processPkgOne
{
    NSLog(@"[AgentHandler]processPkgOne");
    
    return [action processPkgOne];
}

- (AgentStatus)processPkgTwo
{
    NSLog(@"[AgentHandler]processPkgTwo");
    
    return [action processPkgTwo];
}

- (AgentStatus)processPkgThree
{
    NSLog(@"[AgentHandler]processPkgThree");
    
    return [action processPkgThree];
}

- (AgentStatus)processPkgFour
{
    NSLog(@"[AgentHandler]processPkgFour");
    
    return [action processPkgFour];
}

- (void)processPkgEnd:(AgentStatus)aStatus
{
    NSLog(@"[AgentHandler]processPkgEnd");
    
    [action processEnd:aStatus];
}

- (void)processPkgError:(AgentStatus)aStatus
{
    NSLog(@"[AgentHandler]processPkgError");
    
    if (aStatus == DEVICE_PHONENUMBER_NOT_FOUND)
    {
        [DbProvider AllDeleteDb];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                // 이 블럭은 위 작업이 완료되면 호출된다.
            
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).warningPopupCtl setStatus:WARNING_NON_USER_INFO];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).warningPopupCtl setCount:0];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).warningPopupCtl setLesson:@""];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate).warningPopupCtl PopupSetting];
               
            });
        });
        return;
    }
    
    
    [action processError:aStatus];
}

- (void)Action:(id)aAction didFinish:(int)aActionStep
{
    NSLog(@"aAction didFinish step : %d", step);
    
    if (step == PROCESS_PKG1)
    {
        step = PROCESS_PKG2;
    }
    else if (step == PROCESS_PKG3)
    {
        step = PROCESS_PKG4;
    }
    else
    {
        return;
    }
    
    [self respondToAgent];
}

- (void)Action:(id)aAction didFail:(int)aActionStep
{
    NSLog(@"aAction didFail step : %d", step);
    
    step = PROCESS_ERROR;
    
    [self respondToAgent];
}



@end
