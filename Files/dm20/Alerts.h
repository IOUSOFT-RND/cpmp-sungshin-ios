//
//  Alerts.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonSerializer.h"

@interface Alert : NSObject <JsonSerializer>
{
    @private
    NSString *mimeType;
    NSString *sourceUri;
    NSString *targetUri;
    NSString *data;
}

@property (nonatomic) NSString *mimeType;
@property (nonatomic) NSString *sourceUri;
@property (nonatomic) NSString *targetUri;
@property (nonatomic) NSString *data;

@end

@interface Alerts : NSObject <JsonSerializer>
{
    @private
    NSMutableArray *alerts;
}

@property (nonatomic) NSMutableArray *alerts;

@end
