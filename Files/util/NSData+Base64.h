//
//  NSData+Base64.h
//  emdm
//
//  Created by kdsooi on 13. 7. 31..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)aString;
- (id)initWithBase64EncodedString:(NSString *)aString;

- (NSString *)base64Encoding;
- (NSString *)base64EncodingWithLineLength:(NSUInteger)aLineLength;

- (BOOL)hasPrefix:(NSData *)aPrefix;
- (BOOL)hasPrefixBytes:(const void *)aPrefix length:(NSUInteger)aLength;

- (BOOL)hasSuffix:(NSData *)aSuffix;
- (BOOL)hasSuffixBytes:(const void *)aSuffix length:(NSUInteger)aLength;

@end
