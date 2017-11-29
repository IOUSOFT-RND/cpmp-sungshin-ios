//
//  Status.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@class Alerts;

@interface Status : NSObject <JsonSerializer>
{
    @private
    NSString *cred;
    NSString *moData;
    Alerts *alerts;
    NSMutableArray *results;
}

@property (nonatomic) NSString *cred;
@property (nonatomic) NSString *moData;
@property (nonatomic) Alerts *alerts;
@property (nonatomic) NSMutableArray *results;

@end
