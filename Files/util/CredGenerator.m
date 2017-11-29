//
//  CredGenerator.m
//  emdm
//
//  Created by kdsooi on 13. 7. 30..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import "CredGenerator.h"

#define ITERATIONS 16
#define ITERATION_NUMBER 1000

Byte dict[] = {0x01, 0x0f, 0x05, 0x0b, 0x13, 0x1c, 0x17, 0x2f,
    0x23, 0x2c, 0x02, 0x0e, 0x06, 0x0a, 0x12, 0x0d,
    0x16, 0x1a, 0x20, 0x2f, 0x03, 0x0d, 0x07, 0x09,
    0x11, 0x1e, 0x15, 0x19, 0x21, 0x2d, 0x04, 0x0c,
    0x08, 0x3f, 0x10, 0x1f, 0x14, 0x18, 0x22, 0x2e};
Byte hexTable[] = {'0', '1', '2', '3', '4', '5', '6', '7',
    '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

@implementation CredGenerator

- (NSString *)generatePassword:(NSString *)aServerId :(NSString *)aDeviceId
{
    if (!aServerId)
    {
        NSLog(@"aServerId == nil");
        return nil;
    }
    
    if (!aDeviceId)
    {
        NSLog(@"aDeviceId == nil");
        return nil;
    }
    
    NSString *deviceNo = [self getDeviceNo:aDeviceId];
    if (!deviceNo)
    {
        NSLog(@"deviceNo == nil");
        return nil;
    }
    
    NSString *key = [self generateKey:deviceNo];
    if (!key)
    {
        NSLog(@"key == nil");
        return nil;
    }
    
    NSData *digestHex = [self generateDigestHex:aServerId :key :aDeviceId];
    if (!digestHex)
    {
        NSLog(@"digestHex == nil");
        return nil;
    }
    
    NSData *salt = [self generateSalt:aDeviceId];
    if (!salt)
    {
        NSLog(@"salt == nil");
        return nil;
    }
    
    NSString *crypt = [self generateCrypt:aDeviceId :salt];
    if (!crypt)
    {
        NSLog(@"crypt == nil");
        return nil;
    }
    
    NSString *password;
    password = [self combinePassword:digestHex :crypt];
    
    password = [self shuffle:password];
    password = [self shuffle:password];
    password = [self shuffle:password];
    
    return password;
}

- (NSString *)generateKey:(NSString *)aSource
{
    if (!aSource)
    {
        NSLog(@"aSource == nil");
        return nil;
    }
    
    long serial1 = 0;
    long serial2 = 0;
    int length = (int)[aSource length];
    
    for (int i = 0; i < length - 1; i++)
    {
        serial1 += [aSource characterAtIndex:i] * dict[i];
        serial2 += [aSource characterAtIndex:i] * [aSource characterAtIndex:(length - i - 1)] * dict[i];
    }
    
    NSString *key = [NSString stringWithFormat:@"%ld%ld", serial1, serial2];
    
    return key;
}

- (NSString *)getDeviceNo:(NSString *)aDeviceId
{
    
    if (!aDeviceId)
    {
        NSLog(@"aDeviceId == nil");
        return nil;
    }
    
    NSMutableString *no = [[NSMutableString alloc] init];


    NSArray *split = [aDeviceId componentsSeparatedByString:@":"];
    if ([split count] == 1)
    {
        NSLog(@"split count < 1");
        [no appendString:aDeviceId];
    }
    else if([split count] > 1)
    {
        int splitCount = (int)[split count];
    
        for (int i = 1; i < splitCount; i++)
        {
            [no appendString:[split objectAtIndex:i]];
        }
    }
    
    return no;
}

- (NSData *)generateDigestHex:(NSString *)aServerId :(NSString *)aKey :(NSString *)aDeviceId
{
    if (!aServerId)
    {
        NSLog(@"aServerId == nil");
        return nil;
    }
    
    if (!aKey)
    {
        NSLog(@"aKey == nil");
        return nil;
    }
    
    if (!aDeviceId)
    {
        NSLog(@"aDeviceId == nil");
        return nil;
    }
    
    NSMutableString *source = [[NSMutableString alloc] init];
    [source appendString:aServerId];
    [source appendString:aKey];
    [source appendString:aDeviceId];
    
    NSData *md5 = [self generateMd5:source];
    
    NSData *digestHex = [self encodeHex:md5];
    
    return digestHex;
}

- (NSData *)generateMd5:(NSString *)aSource
{
    if (!aSource)
    {
        NSLog(@"aSource == nil");
        return nil;
    }
    
    const char *cString = [aSource UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH] = {0,};
    
    CC_MD5(cString, (int)strlen(cString), digest);
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        NSLog(@"%d", digest[i]);
    }
    
    NSData *md5 = [[NSData alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    
    return md5;
}

- (NSData *)encodeHex:(NSData *)aSource
{
    if (!aSource)
    {
        NSLog(@"aSource == nil");
        return nil;
    }
    
    int i = 0, ch = 0, ch1 = 0;
    Byte one = 0;
    Byte digestHex[ITERATIONS * 2] = {0,};
    
    for (int index = 0; index < 16; index++)
    {
        [aSource getBytes:&one range:NSMakeRange(index, 1)];
        ch = (int)one;
        ch1 = ch & 0x0f;
        digestHex[i] = hexTable[ch1];
        i++;
        ch1 = (ch >> 4) & 0x0f;
        digestHex[i] = hexTable[ch1];
        i++;        
    }
    
    NSData *encodeHex = [[NSData alloc] initWithBytes:digestHex length:(ITERATIONS * 2)];
    
    return encodeHex;
}

- (NSData *)generateSalt:(NSString *)aSource
{
    if (!aSource)
    {
        NSLog(@"aSource == nil");
        return nil;
    }
    
    int length = (int)[aSource length];
    uint8_t byteSalt[2] = {0,};
    
    byteSalt[0] = [aSource characterAtIndex:(length - 2)];
    byteSalt[1] = [aSource characterAtIndex:(length - 1)];
    
    NSData *salt = [[NSData alloc] initWithBytes:byteSalt length:2];
    
    return salt;
}

- (NSData *)generateSalt
{
    UInt32 random = 0;
    int result = SecRandomCopyBytes(kSecRandomDefault, sizeof(int), (uint8_t *)&random);

    if (result != 0)
        random = arc4random();
    
    NSData *salt = [[NSData alloc] initWithBytes:&random length:sizeof(random)];
    
    return salt;
}

- (NSString *)combinePassword:(NSData *)aDigestHex :(NSString *)aCrypt
{
    if (!aDigestHex)
    {
        NSLog(@"aDigestHex == nil");
        return nil;
    }
    
    if (!aCrypt)
    {
        NSLog(@"aCrypt == nil");
        return nil;
    }

    NSString *digestHex = [[NSString alloc] initWithData:aDigestHex encoding:NSUTF8StringEncoding];
    
    uint8_t buff[4] = {0,};
    buff[0] = [digestHex characterAtIndex:1];
    buff[1] = [digestHex characterAtIndex:4];
    buff[2] = [digestHex characterAtIndex:5];
    buff[3] = [digestHex characterAtIndex:7];
    
    NSMutableString *password = [[NSMutableString alloc] init];
    [password appendString:[[NSString alloc] initWithBytes:buff length:4 encoding:NSUTF8StringEncoding]];
    [password appendString:aCrypt];
    
    return password;
}

- (NSString *)generateCrypt:(NSString *)aDeviceId :(NSData *)aSalt
{
    if (!aDeviceId)
    {
        NSLog(@"aDeviceId == nil");
        return nil;
    }
    
    if (!aSalt)
    {
        NSLog(@"aSalt == nil");
        return nil;
    }
    
    char *cCrypt;
    
    cCrypt = crypt([aDeviceId UTF8String], (char *)[aSalt bytes]);

    NSString *crypt = [NSString stringWithFormat:@"%s", cCrypt];
    
    return crypt;
}

- (NSString *)shuffle:(NSString *)aSource
{
    if (!aSource)
    {
        NSLog(@"aSource == nil");
        return nil;
    }
    
    NSMutableArray *buff = [[NSMutableArray alloc] init];

    [aSource enumerateSubstringsInRange:NSMakeRange(0, [aSource length]) options:(NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [buff addObject:substring];
    }];

    int length = (int)[aSource length];
    int mod = length % 2;
    int halfPos = 0;
    int insertPos = 0;
    NSString *ch, *temp;

    if (mod == 0)
        halfPos = length / 2;
    else
        halfPos = length / 2 + 1;
    
    for (int i = halfPos; i < length; i++)
    {
        ch = [[buff objectAtIndex:i] copy];
        
        for (int j = i; j < length - 1; j++)
        {
            [buff replaceObjectAtIndex:j withObject:[buff objectAtIndex:(j+1)]];
        }
        
        [buff replaceObjectAtIndex:(length-1) withObject:@"0"];
        
        if (mod == 0)
            insertPos = length - i - 1;
        else
            insertPos = length - i;
        
        for (int k = insertPos; k < length - 1; k++)
        {
            temp = [[buff objectAtIndex:k] copy];
            [buff replaceObjectAtIndex:k withObject:ch];
            ch = [temp copy];
        }
        
        [buff replaceObjectAtIndex:(length-1) withObject:ch];
    }

//    for (int i = 0; i < [buff count]; i++)
//    {
//        NSLog(@"shuffle : %@", [buff objectAtIndex:i]);
//    }
    
    NSString *shuffle = [buff componentsJoinedByString:@""];
    
    return shuffle;
}

- (NSData *)generateCred:(NSString *)aServerId :(NSString *)aDeviceId :(NSData *)aSalt
{
    if (!aServerId)
    {
        NSLog(@"aServerId == nil");
        return nil;
    }
    
    if (!aDeviceId)
    {
        NSLog(@"aDeviceId == nil");
        return nil;
    }
    
    if (!aSalt)
    {
        NSLog(@"aSalt == nil");
        return nil;
    }
    
    NSString *password = [self generatePassword:aServerId :aDeviceId];
    if (!password)
    {
        NSLog(@"password == nil");
        return nil;
    }
    
    NSData *cred = [self generateHash:password :aSalt :ITERATION_NUMBER];
    
    return cred;
}

- (NSData *)generateHash:(NSString *)aPassword :(NSData *)aSalt :(int)aIterationNumber
{
    if (!aPassword)
    {
        NSLog(@"aPassword == nil");
        return nil;
    }
    
    if (!aSalt)
    {
        NSLog(@"aSalt == nil");
        return nil;
    }
    
    NSData *password = [aPassword dataUsingEncoding:NSUTF8StringEncoding];
    Byte digest[CC_SHA1_DIGEST_LENGTH+1] = {0,};
    
    CC_SHA1_CTX ctx;
    
    CC_SHA1_Init(&ctx);
    CC_SHA1_Update(&ctx, [aSalt bytes], (CC_LONG)[aSalt length]);
    CC_SHA1_Update(&ctx, [password bytes], (CC_LONG)[password length]);
    CC_SHA1_Final(digest, &ctx);
    
    for (int i = 0; i < aIterationNumber; i++)
    {
        CC_SHA1_Init(&ctx);
        CC_SHA1_Update(&ctx, digest, CC_SHA1_DIGEST_LENGTH);
        CC_SHA1_Final(digest, &ctx);
    }
    
    digest[CC_SHA1_DIGEST_LENGTH] = '\0';
    
    NSData *hash = [[NSData alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    
    return hash;
}

@end
