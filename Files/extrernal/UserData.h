//
//  UserData.h
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 12..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Shortcut.h"
#import "Addon.h"

#define kDataVersionNumber      @(1)

@interface UserData : NSObject

+ (UserData*)sharedUserData;

+(void)setDataVersion:(NSNumber*)version;
+ (void)setBaseID:(NSString*)baseID;

+ (UserData*) save;
- (UserData*) save;

+ (UserData*) reset;

// 전역값
@property (nonatomic, strong) NSNumber * LOGON;
@property (nonatomic, strong) NSString * USER_ID;
@property (nonatomic, strong) NSString * SENDED_TOKEN;
@property (nonatomic, strong) NSNumber * HAS_CUSTOM_AUTOLOGIN;
@property (nonatomic, strong) NSNumber * CUSTOM_AUTOLOGIN;

@property (nonatomic, strong) NSString * PREV_USER_ID;

// App Data
@property (nonatomic, strong) NSString * COOKIE;
@property (nonatomic, strong) NSString * USER_PASS;

// Net Data
// VersionInfo
@property (nonatomic, strong) NSString * version;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * notice;
@property (nonatomic, strong) NSString * update_url;
@property (nonatomic, strong) NSString * is_required;

// login
@property (nonatomic, strong) NSString * USER_TYPE;
@property (nonatomic, strong) NSString * USER_NAME;
@property (nonatomic, strong) NSString * USER_NAME_E;
@property (nonatomic, strong) NSString * DISP_TEXT;
@property (nonatomic, strong) NSString * DISP_TEXT_E;
@property (nonatomic, strong) NSString * PHONE_NO;
@property (nonatomic, strong) NSString * PHOTO_URL;
@property (nonatomic, strong) NSString * EMAIL;
@property (nonatomic, strong) NSString * MENU_VERSION;
@property (nonatomic, strong) NSString * MEMBER_ID;

@property (nonatomic, strong) NSString * GB_WORK;

- (NSString*)getServiceId;      // MEMBER_ID -> sno -> USER_ID

// add-on
- (void)setAddonList:(NSArray*)array;
- (NSDictionary*) addonDic;  // nfc 제외
- (NSArray*) addonArray;    // nfc 제외

- (NSDictionary*) allAddonDic;
- (NSArray*) allAddonArray;

- (void)setMidInfo:(NSDictionary*)dic;

//SERVICE_CODE
//SERVICE_NAME
//SERVICE_DESCRIPTION
//CATEGORY
//CONTENT_TYPE
//ICON_URL1
//ICON_URL2
//CONTENT_URL
//APP_STORE_URL
//NFC_TYPE
//SERVICE_ORDER
// notice list

// mid info
@property (nonatomic, strong) NSString * uCode;
@property (nonatomic, strong) NSString * libid;
@property (nonatomic, strong) NSString * sno;
@property (nonatomic, strong) NSString * regno;
@property (nonatomic, strong) NSString * timeType;
@property (nonatomic, strong) NSString * codeType;

// 메뉴 바로가기 정보 목록
//SERVICE_CODE
//SHORTCUT_ORDER
//SHORTCUT_COLOR

- (void)setShortcutItem:(Shortcut*)item order:(NSString*)order;
- (Shortcut*) noticeShortcut;
- (Shortcut*) messageShortcut;
- (NSMutableDictionary*) shortcutDictionary;

@end
