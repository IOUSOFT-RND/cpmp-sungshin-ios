//
//  Json.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Json : NSObject

+ (id)encode:(id)aData;
+ (id)decode:(id)aData;
+ (id)decodeHttps:(id)aData;
@end
