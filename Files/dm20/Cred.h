//
//  Cred.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@interface Cred : NSObject <JsonSerializer>
{
    @private
    NSString *type;
    NSString *salt;
    NSString *data;
}

@property (nonatomic) NSString *type;
@property (nonatomic) NSString *salt;
@property (nonatomic) NSString *data;

@end
