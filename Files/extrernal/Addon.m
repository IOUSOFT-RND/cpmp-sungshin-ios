//
//  Addon.m
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 26..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import "Addon.h"
#import "UserData.h"
#import "AESHelper.h"

@interface Addon ()

@property (nonatomic, strong) NSDictionary * dic;

@end

@implementation Addon

+(Addon*)addonFromDic:(NSDictionary*)dic {

    Addon * obj = [[Addon alloc] init];
    obj.dic = dic;
    return obj;
}

- (BOOL)isAppContent {
    return [self.CONTENT_TYPE isEqualToString:@"1"];
}

- (NSString*)SERVICE_CODE {
    return [_dic objectForKey:@"SERVICE_CODE"];
}

- (NSString*)SERVICE_NAME {
    return [_dic objectForKey:@"SERVICE_NAME"];
}

- (NSString*)SERVICE_DESCRIPTION {
    return [_dic objectForKey:@"SERVICE_DESCRIPTION"];
}

- (NSString*)CATEGORY {
    return [_dic objectForKey:@"CATEGORY"];
}

- (NSString*)CONTENT_TYPE {
    return [_dic objectForKey:@"CONTENT_TYPE"];
}

- (NSString*)ICON_URL1 {
    return [_dic objectForKey:@"ICON_URL1"];
}

- (NSString*)ICON_URL2 {
    return [_dic objectForKey:@"ICON_URL2"];
}

- (NSData*)ICON_URL1_DATA {
    return [_dic objectForKey:@"ICON_URL1_DATA"];
}

- (NSData*)ICON_URL2_DATA {
    return [_dic objectForKey:@"ICON_URL2_DATA"];
}

- (NSString*)CONTENT_URL {
    NSString * CONTENT_URL = [_dic objectForKey:@"CONTENT_URL"];
    if (CONTENT_URL != nil && [CONTENT_URL rangeOfString:@":"].location == NSNotFound) {
        UserData * ud = [UserData sharedUserData];
        if ([ud.LOGON boolValue]) {
            CONTENT_URL = [NSString stringWithFormat:@"%@://sso?memberId=%@&memberPw=%@&memberType=%@",
                           CONTENT_URL, ud.USER_ID, [AESHelper aes128EncryptString:ud.USER_PASS], ud.USER_TYPE];
        }
        else {
            CONTENT_URL = [NSString stringWithFormat:@"%@://", CONTENT_URL];
        }
    }
    return CONTENT_URL;
}
- (NSString*)RAW_CONTENT_URL {
    return [_dic objectForKey:@"CONTENT_URL"];
}

- (NSString*)APP_STORE_URL {
    return [_dic objectForKey:@"APP_STORE_URL"];
}

- (NSString*)NFC_TYPE {
    return [_dic objectForKey:@"NFC_TYPE"];
}
- (NSInteger)SERVICE_ORDER {
    return [(NSString*)[_dic objectForKey:@"SERVICE_ORDER"] integerValue];
}

@end
