//
//  Shortcut.h
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 26..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Shortcut : NSObject

@property (nonatomic, strong) NSDictionary * dic;

+(void)setColorForMessage:(NSString*)colorString;
+(void)setColorForNotice:(NSString*)colorString;

+(Shortcut*)shortcutFromDic:(NSDictionary*)dic;
+(Shortcut*)shortcutFromCode:(NSString*)code order:(NSString*)order color:(NSString*)color;
+(Shortcut*)shortcutForMessage;
+(Shortcut*)shortcutForNotice;

- (NSString*)serviceCode;
- (NSString*)order;
- (UIColor*)color;

@end
