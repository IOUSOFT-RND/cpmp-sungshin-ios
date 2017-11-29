//
//  Profiles.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@interface Profile : NSObject <JsonSerializer>
{
    @private
    NSString *name;
    NSString *serverId;
    NSString *serverUrl;
    NSString *enabled;
    NSString *priority;
    NSString *initiated;
}

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *serverId;
@property (nonatomic) NSString *serverUrl;
@property (nonatomic) NSString *enabled;
@property (nonatomic) NSString *priority;
@property (nonatomic) NSString *initiated;

- (BOOL) load;
+ (BOOL) initiatize;
+ (BOOL) reInitiatize;

@end

@interface Profiles : NSObject <JsonSerializer>
{
    @private
    NSMutableArray *profiles;
}

@property (nonatomic) NSMutableArray *profiles;

- (NSArray *)ResouceProfileLoad;

@end
