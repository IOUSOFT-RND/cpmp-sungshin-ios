//
//  AESHelper.h
//  Smart
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AESHelper : NSObject

+ (void)setKey:(NSString *)key;
+ (void)setUse128:(BOOL)use;
//- (id)initWithKey:(NSString *)key;

+ (NSString*)aesEncryptString:(NSString*)textString;
+ (NSString*)aesDecryptString:(NSString*)textString;

+ (NSString*)aesEncryptStringForSso:(NSString*)textString;
+ (NSString*)aesDecryptStringForSso:(NSString*)textString;

+ (NSString*)aes128EncryptString:(NSString*)textString;
+ (NSString*)aes128DecryptString:(NSString*)textString;

+ (NSString *)hexEncode:(NSData *)data;
+ (NSData*)decodeHexString:(NSString *)hexString;

@end
