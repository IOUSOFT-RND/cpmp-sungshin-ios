//
//  NSString+Escape.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "NSString+Escape.h"

@implementation NSString(Escape)


+ (NSString*) unescapeJavacodeString:(NSString*)string
{
    // tokenize based on unicode escape char
    NSMutableString* temp = [[NSMutableString alloc] initWithCapacity:[string length]];
    NSInteger lastPos = 0, pos = 0;
    NSRange mRange;
    
    while (lastPos < [string length])
    {
        mRange = [string rangeOfString:@"%" options:NSCaseInsensitiveSearch range:NSMakeRange(lastPos, [string length]-lastPos)];
        pos = mRange.location;
        if (pos == lastPos)
        {
            if([string characterAtIndex:pos+1]=='u')
            {
                NSRange range = {pos+2, 4};
                NSString *token = [string substringWithRange:range];
                unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
                [temp appendString:[NSString stringWithFormat:@"%C", codeValue]];
                lastPos = pos +6;
            }
            else
            {
                NSRange range = {pos+1, 2};
                NSString *token = [string substringWithRange:range];
                unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
                [temp appendString:[NSString stringWithFormat:@"%C", codeValue]];
                lastPos = pos+3;
            }
        }
        else
        {
            if (pos == NSNotFound)
            {
                [temp appendString:[string substringFromIndex:lastPos]];
                lastPos = [string length];
            }
            else
            {
                [temp appendString:[string substringWithRange:NSMakeRange(lastPos,pos-lastPos)]];
                lastPos = pos;
            }
        }
    }
    return temp;

}

+ (NSString*) unescapeUnicodeString:(NSString*)string
{
    
    // tokenize based on unicode escape char
    NSMutableString* tokenizedString = [NSMutableString string];
    NSScanner* scanner = [NSScanner scannerWithString:string];
    while ([scanner isAtEnd] == NO)
    {
        // read up to the first unicode marker
        // if a string has been scanned, it's a token
        // and should be appended to the tokenized string
        NSString* token = @"";
        [scanner scanUpToString:@"%u" intoString:&token];
        if (token != nil && token.length > 0)
        {
            if ([token characterAtIndex:0]=='u') {
            }
            [tokenizedString appendString:token];
            continue;
        }

        
        
        // skip two characters to get past the marker
        // check if the range of unicode characters is
        // beyond the end of the string (could be malformed)
        // and if it is, move the scanner to the end
        // and skip this token
        NSUInteger location = [scanner scanLocation];
        NSInteger extra = scanner.string.length - location - 4 - 2;
        if (extra < 0)
        {
            NSRange range = {location, -extra};
            [tokenizedString appendString:[scanner.string substringWithRange:range]];
            [scanner setScanLocation:location - extra];
            continue;
        }
        
        // move the location pas the unicode marker
        // then read in the next 4 characters
        location += 2;
        NSRange range = {location, 4};
        token = [scanner.string substringWithRange:range];
        unichar codeValue = (unichar) strtol([token UTF8String], NULL, 16);
        [tokenizedString appendString:[NSString stringWithFormat:@"%C", codeValue]];
        
        // move the scanner past the 4 characters
        // then keep scanning
        location += 4;
        [scanner setScanLocation:location];
    }
    // done
    return tokenizedString;
}

+ (NSString*) escapeUnicodeString:(NSString*)string
{
    // lastly escaped quotes and back slash
    // note that the backslash has to be escaped before the quote
    // otherwise it will end up with an extra backslash
    NSString* escapedString = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    // convert to encoded unicode
    // do this by getting the data for the string
    // in UTF16 little endian (for network byte order)
    NSData* data = [escapedString dataUsingEncoding:NSUTF16LittleEndianStringEncoding allowLossyConversion:YES];
    size_t bytesRead = 0;
    const char* bytes = data.bytes;
    NSMutableString* encodedString = [NSMutableString string];
    
    // loop through the byte array
    // read two bytes at a time, if the bytes
    // are above a certain value they are unicode
    // otherwise the bytes are ASCII characters
    // the %C format will write the character value of bytes
    while (bytesRead < data.length)
    {
        uint16_t code = *((uint16_t*) &bytes[bytesRead]);
        if (code > 0x007E)
        {
            [encodedString appendFormat:@"\\u%04X", code];
        }
        else
        {
            [encodedString appendFormat:@"%C", code];
        }
        bytesRead += sizeof(uint16_t);
    }
    
    // done
    return encodedString;
}

+(NSString*)unescapeAddJavaUrldecode:(NSString*)string
{
    NSString *str =[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString unescapeJavacodeString:str];
}

+ (NSString*) unescapeAddUrldecode:(NSString*)string
{
    NSString *str =[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSString unescapeUnicodeString:str];
}


@end
