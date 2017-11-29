//
//  DevInfo.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@interface DevInfo : NSObject <JsonSerializer>
{
    @private
    NSString *devNum;
    NSString *devId;
    NSString *devType;
    NSString *swV;
    NSString *regId;

}

@property (nonatomic) NSString *devNum;
@property (nonatomic) NSString *devId;
@property (nonatomic) NSString *devType;
@property (nonatomic) NSString *swV;
@property (nonatomic) NSString *regId;

- (id)initAuth;

@end
