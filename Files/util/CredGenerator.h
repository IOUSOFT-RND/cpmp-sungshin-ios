//
//  CredGenerator.h
//  emdm
//
//  Created by kdsooi on 13. 7. 30..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredGenerator : NSObject

- (NSData *)generateSalt;
- (NSData *)generateCred:(NSString *)aServerId :(NSString *)aDeviceId :(NSData *)aSalt;
- (NSString *)generatePassword:(NSString *)aServerId :(NSString *)aDeviceId;

@end
