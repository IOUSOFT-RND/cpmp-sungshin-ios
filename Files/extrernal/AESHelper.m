//
//  AESHelper.m
//  Smart
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import "AESHelper.h"
#import "Base64.h"
#import "NSData+AES256.h"

@interface AESHelper ()
@end

@implementation AESHelper

static NSString * key_128= @"ioulogin03160712";

static NSString * keyForSso_= @"F3D83427C13F8FBCB48A19F331444210";

static NSString * key_= @"F3D83427C13F8FBCB48A19F33144421A";//F3D83427C13F8FBCB48A19F33144421B";

static BOOL is128Mode_ = NO;

+ (void)setUse128:(BOOL)use {
    is128Mode_ = use;
}

+ (void)setKey:(NSString *)key {
    key_ = key;
}

//- (id)initWithKey:(NSString *)key {
//    self = [super init];
//    if (self) {
//        key_ = key;
//    }
//    return self;
//}

+ (NSString*) aesEncryptString:(NSString*)textString
{
    if (is128Mode_)
        return [self aes128EncryptString:textString];
    NSData *data = [[NSData alloc] initWithData:[textString dataUsingEncoding:NSUTF8StringEncoding]];

//    //PKCS5 Padding
//    NSMutableData *data = [[NSMutableData alloc] initWithData:[textString dataUsingEncoding:NSUTF8StringEncoding]];
//    int blockSize = 16;
//    int charDiv = blockSize - ((textString.length + 1) % blockSize);
//    NSMutableString *padding = [[NSMutableString alloc] initWithFormat:@"%c",(unichar)10];
//    for (int c = 0; c <charDiv; c++) {
//        [padding appendFormat:@"%c",(unichar)charDiv];
//    }
//    [data appendData:[padding dataUsingEncoding:NSUTF8StringEncoding]];
//    //PKCS5 Padding

    NSData *ret = [data AES256EncryptWithKey:key_];

    return [ret base64EncodedString];
}

+ (NSString*) aesDecryptString:(NSString*)textString
{
    NSData *ret = [self decodeHexString:textString];
    NSData *ret2 = [ret AES128DecryptWithKeyData:[self decodeHexString:key_]];
    NSString *st2 = [[NSString alloc] initWithData:ret2 encoding:NSUTF8StringEncoding];
    return st2;
}

+ (NSString*) aesEncryptStringForSso:(NSString*)textString
{
    if (is128Mode_)
        return [self aes128EncryptString:textString];
    NSData *data = [[NSData alloc] initWithData:[textString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *ret = [data AES256EncryptWithKey:keyForSso_];

    return [ret base64EncodedString];
}

+ (NSString*) aesDecryptStringForSso:(NSString*)textString
{
    if (is128Mode_)
        return [self aes128DecryptString:textString];
    NSData *ret = [textString base64DecodedData];
    NSData *ret2 = [ret AES256DecryptWithKey:keyForSso_];
    NSString *st2 = [[NSString alloc] initWithData:ret2 encoding:NSUTF8StringEncoding];
    return st2;
}

+ (NSString*) aes128EncryptString:(NSString*)textString
{
    NSData *data = [[NSData alloc] initWithData:[textString dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *ret = [data AES128EncryptWithKey:key_128];
    return [self hexEncode:ret];
}

+ (NSString*) aes128DecryptString:(NSString*)textString
{
    NSData *ret = [self decodeHexString:textString];
    NSData *ret2 = [ret AES128DecryptWithKey:key_128];
    NSString *st2 = [[NSString alloc] initWithData:ret2 encoding:NSUTF8StringEncoding];
    return st2;
}

+ (NSString *)hexEncode:(NSData *)data
{
    NSMutableString *hex = [NSMutableString string];
    unsigned char *bytes = (unsigned char *)[data bytes];
    char temp[3];
    NSUInteger i=0;
    
    for(i=0; i<[data length]; i++){
        temp[0] = temp[1] = temp[2] =0;
        (void)sprintf(temp, "%02X",bytes[i]);
        [hex appendString:[NSString stringWithUTF8String:temp]];
    }
    return hex;
}

+ (NSData*) decodeHexString : (NSString *)hexString
{
    NSInteger tlen = [hexString length]/2;
    
    char tbuf[tlen];
    int i,k,h,l;
    bzero(tbuf, sizeof(tbuf));
    
    for(i=0,k=0;i<tlen;i++)
    {
        h=[hexString characterAtIndex:k++];
        l=[hexString characterAtIndex:k++];
        h=(h >= 'A') ? h-'A'+10 : h-'0';
        l=(l >= 'A') ? l-'A'+10 : l-'0';
        tbuf[i]= ((h<<4)&0xf0)| (l&0x0f);
    }
    
    return [NSData dataWithBytes:tbuf length:tlen];
}


@end
