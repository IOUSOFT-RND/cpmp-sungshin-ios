//
//  Addon.h
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 26..
//  Copyright (c) 2014년 SookmyungSmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Addon : NSObject

+(Addon*)addonFromDic:(NSDictionary*)dic;

- (BOOL)isAppContent;

- (NSString*)SERVICE_CODE;
- (NSString*)SERVICE_NAME;
- (NSString*)SERVICE_DESCRIPTION;
- (NSString*)CATEGORY;
- (NSString*)CONTENT_TYPE;
- (NSString*)ICON_URL1;
- (NSString*)ICON_URL2;
- (NSData*)ICON_URL1_DATA;
- (NSData*)ICON_URL2_DATA;
- (NSString*)CONTENT_URL;
- (NSString*)RAW_CONTENT_URL;
- (NSString*)APP_STORE_URL;
- (NSString*)NFC_TYPE;
- (NSInteger)SERVICE_ORDER;

@end
