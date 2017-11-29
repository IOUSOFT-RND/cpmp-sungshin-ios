//
//  NSString+Escape.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Escape)

+ (NSString*) unescapeUnicodeString:(NSString*)string;
+ (NSString*) escapeUnicodeString:(NSString*)string;
+ (NSString*) unescapeAddUrldecode:(NSString*)string;
+ (NSString*) unescapeJavacodeString:(NSString*)string;
+ (NSString*) unescapeAddJavaUrldecode:(NSString*)string;
@end
