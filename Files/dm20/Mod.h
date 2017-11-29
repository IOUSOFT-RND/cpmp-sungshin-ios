//
//  Mod.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@class Cred;
@class MoData;
@class Alerts;

@interface Mod : NSObject <JsonSerializer>
{
    @private
    Cred *cred;
    MoData *moData;
    Alerts *alerts;
}

@property (nonatomic) Cred *cred;
@property (nonatomic) MoData *moData;
@property (nonatomic) Alerts *alerts;

@end
