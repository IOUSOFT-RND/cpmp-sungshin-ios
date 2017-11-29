//
//  NSData+AES256.h
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 25..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

@interface NSData (AES128)

- (NSData *)AES128EncryptWithKey:(NSString *)key;
- (NSData *)AES128EncryptWithKeyData:(NSData *)keyData;
- (NSData *)AES128DecryptWithKey:(NSString *)key;
- (NSData *)AES128DecryptWithKeyData:(NSData*)keyData;

@end
