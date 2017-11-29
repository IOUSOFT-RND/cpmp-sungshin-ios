//
//  Agent+Status.h
//  emdm
//
//  Created by kdsooi on 13. 7. 31..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Agent.h"
#import "DmEnumDef.h"

@interface Agent (Status)

+ (NSString *)getStatusString:(AgentStatus)aStatus;
+ (NSString *)getStatusDescription:(AgentStatus)aStatus;

@end
