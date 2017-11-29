//
//  Shortcut.m
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 26..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import "Shortcut.h"
#import "Common.h"

@interface Shortcut ()

//@property (nonatomic, strong) NSDictionary * dic;

@end

static NSString * colorForMessage_ = @"#FFFFFF";
static NSString * colorForNotice_ = @"#FFFFFF";

@implementation Shortcut

+(void)setColorForMessage:(NSString*)colorString {
    colorForMessage_ = colorString;
}

+(void)setColorForNotice:(NSString*)colorString {
    colorForNotice_ = colorString;
}

+(Shortcut*)shortcutFromDic:(NSDictionary*)dic {
    Shortcut * obj = [[Shortcut alloc] init];
    obj.dic = dic;
    return obj;
}

+(Shortcut*)shortcutFromCode:(NSString*)code order:(NSString*)order color:(NSString*)color {
    Shortcut * obj = [[Shortcut alloc] init];
    obj.dic = @{@"SERVICE_CODE":code,@"SHORTCUT_ORDER":order,@"SHORTCUT_COLOR":color};
    return obj;
}

+(Shortcut*)shortcutForMessage {
    Shortcut * obj = [[Shortcut alloc] init];
    obj.dic = @{@"SERVICE_CODE":@"-1",@"SHORTCUT_ORDER":@"-1",@"SHORTCUT_COLOR":colorForMessage_};
    return obj;
}

+(Shortcut*)shortcutForNotice {
    Shortcut * obj = [[Shortcut alloc] init];
    obj.dic = @{@"SERVICE_CODE":@"-1",@"SHORTCUT_ORDER":@"-1",@"SHORTCUT_COLOR":colorForNotice_};
    return obj;
}

- (NSString*)serviceCode {
    return [_dic objectForKey:@"SERVICE_CODE"];
}

- (NSString*)order {
    return [_dic objectForKey:@"SHORTCUT_ORDER"];
}

- (UIColor*)color {
    return [Common colorWithHexString:[_dic objectForKey:@"SHORTCUT_COLOR"]];
}

@end
