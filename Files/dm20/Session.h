//
//  Session.h
//  emdm
//
//  Created by kdsooi on 13. 8. 2..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject
{
    @private
    NSString *sessionId;
    NSString *status;
    NSString *description;
}

@property (nonatomic) NSString *sessionId;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *description;

+ (NSString *)generateSessionId;

@end
