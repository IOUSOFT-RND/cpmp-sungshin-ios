//
//  MoData.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@class DevInfo;

@interface MoData : NSObject <JsonSerializer>
{
    @private
    DevInfo *devInfo;
}

@property (nonatomic) DevInfo *devInfo;

@end
