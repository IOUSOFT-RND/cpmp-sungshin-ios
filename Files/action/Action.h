//
//  Action.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DmEnumDef.h"

#define URI_HW @"HW"
#define URI_SW @"SW"
#define URI_ATTENDANCE @"Attendance"

#define CMD_EXEC @"EXEC"
#define CMD_GET @"GET"
#define CMD_END @"END"

#define OPERATION_ON @"ON"
#define OPERATION_OFF @"OFF"

#define INDEX_CMD 0
#define INDEX_URI 1
#define INDEX_OPERATION 2
#define INDEX_DATA 3

#define HW_BLUETOOTH 1
#define HW_CAMERA 2
#define HW_GPS 4
#define HW_WIFI 8
#define HW_NETWORK 16

#define MIME_TYPE_PLAIN @"text/plain"

@protocol ActionDelegate <NSObject>

- (void)Action:(id)aAction didFinish:(int)aActionStep;
- (void)Action:(id)aAction didFail:(int)aActionStep;

@end

@protocol Action

- (id)initWithData:(id<ActionDelegate>) aDelegate :(NSString *)aServerId :(NSString *)aSessionId;

- (AgentStatus)makePkgOne;
- (AgentStatus)makePkgThree;
- (AgentStatus)makePkgThreeNext;

- (AgentStatus)processPkgOne;
- (AgentStatus)processPkgTwo;
- (AgentStatus)processPkgThree;
- (AgentStatus)processPkgFour;

- (void)processEnd:(AgentStatus)aStatus;
- (void)processError:(AgentStatus)aStatus;

- (AgentStatus)processStatus:(id)aStatus;
- (AgentStatus)processMoData:(id)aMoData;
- (AgentStatus)processCmds:(id)aCmds;

@end

@interface Action : NSObject

@end
