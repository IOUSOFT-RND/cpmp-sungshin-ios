//
//  UserData.m
//  Smart
//
//  Created by kwangsik.shin on 2014. 8. 12..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import "UserData.h"

#import <objc/runtime.h>

#define kProperty_UserData      @"UserData_"

@interface UserData ()
@property (strong, nonatomic) NSUserDefaults * userDefaults;

- (void) setObject:(NSObject*)object forKey:(NSString*)key;
- (NSObject*) objectForKey:(NSString*)key;

void dynamicMethodIMP_UserData(id self, SEL _cmd, id aValue);
id dynamicMethodIMPWithReturn_UserData(id self, SEL _cmd);

@end

NSString * kProperty_UserData_Prefix    = @"";

@implementation UserData

//@dynamic LOGON;
//@dynamic USER_ID;
//@dynamic SENDED_TOKEN;

@dynamic HAS_CUSTOM_AUTOLOGIN;
@dynamic CUSTOM_AUTOLOGIN;

@dynamic COOKIE;
@dynamic USER_PASS;
@dynamic PREV_USER_ID;

// Net Data
// VersionInfo
@dynamic version;
@dynamic title;
@dynamic notice;
@dynamic update_url;
@dynamic is_required;

// login
@dynamic USER_TYPE;
@dynamic USER_NAME;
@dynamic USER_NAME_E;
@dynamic DISP_TEXT;
@dynamic DISP_TEXT_E;
@dynamic PHONE_NO;
@dynamic PHOTO_URL;
@dynamic EMAIL;
@dynamic MENU_VERSION;

@dynamic MEMBER_ID;

@dynamic GB_WORK;

// add-on
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
@dynamic uCode;
@dynamic libid;
@dynamic sno;
@dynamic regno;
@dynamic timeType;
@dynamic codeType;

#define kData_Version @"DATA_VERSION"

static UserData * _sharedUserData = nil;

+(UserData*)sharedUserData {

    if (_sharedUserData == NULL) {
        _sharedUserData = [[self alloc] init];

        if ([_sharedUserData.userDefaults objectForKey:kData_Version] == nil) {
            // kDataVersionNumber
            NSString * token = _sharedUserData.SENDED_TOKEN;
            [self resetAll];
            if (token) {
                _sharedUserData.SENDED_TOKEN = token;
            }
        }
        else {
            if (_sharedUserData.USER_ID) {
                [UserData setBaseID:_sharedUserData.USER_ID];
            }
        }
    }
    return _sharedUserData;
}

+(void)setDataVersion:(NSNumber*)version {
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kData_Version];
}

+ (void)setBaseID:(NSString*)baseID {
    kProperty_UserData_Prefix = [NSString stringWithFormat:@"%@%@", kProperty_UserData, baseID];
    if (_sharedUserData == nil) {
        [self sharedUserData];
    }
    [UserData sharedUserData].USER_ID = baseID;
}

-(NSNumber*) LOGON {
    return [_userDefaults objectForKey:@"LOGON"];
}

- (void)setLOGON:(NSNumber *)LOGON {
    if (LOGON) {
        [_userDefaults setObject:LOGON forKey:@"LOGON"];
    }
    else {
        [_userDefaults removeObjectForKey:@"LOGON"];
    }
}

-(NSString*) USER_ID {
    return [_userDefaults objectForKey:@"USER_ID"];
}

- (void)setUSER_ID:(NSString *)USER_ID {
    if (USER_ID) {
        [_userDefaults setObject:USER_ID forKey:@"USER_ID"];
    }
    else {
        [_userDefaults removeObjectForKey:@"USER_ID"];
    }
}

-(NSString*) SENDED_TOKEN {
    return [_userDefaults objectForKey:@"SENDED_TOKEN"];
}

- (void)setSENDED_TOKEN:(NSString *)SENDED_TOKEN {
    if (SENDED_TOKEN) {
        [_userDefaults setObject:SENDED_TOKEN forKey:@"SENDED_TOKEN"];
    }
    else {
        [_userDefaults removeObjectForKey:@"SENDED_TOKEN"];
    }
}

- (NSString*)getServiceId {
    // MEMBER_ID -> sno -> USER_ID
    NSString * serviceId = self.MEMBER_ID;
    if (serviceId == nil) {
        serviceId = self.sno;
    }
    if (serviceId == nil) {
        serviceId = self.USER_ID;
    }
    return serviceId;
}

- (void)setAddonList:(NSArray*)array {
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    for (NSDictionary * dic in array) {
        NSMutableDictionary * newItem = [NSMutableDictionary dictionaryWithDictionary:dic];
        for (NSString * key in [dic allKeys]) {
            NSObject *obj = [newItem objectForKey:key];
            if ([obj isKindOfClass:[NSNull class]]) {
                [newItem removeObjectForKey:key];
            }
        }
        if ([[newItem objectForKey:@"ICON_URL1"] length] > 0) {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[newItem objectForKey:@"ICON_URL1"]]];
            if (data) {
                [newItem setObject:data forKey:@"ICON_URL1_DATA"];
            }
        }
        if ([[newItem objectForKey:@"ICON_URL2"] length] > 0) {
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[newItem objectForKey:@"ICON_URL2"]]];
            if (data) {
                [newItem setObject:data forKey:@"ICON_URL2_DATA"];
            }
        }
        [newDic setObject:newItem forKey:[newItem objectForKey:@"SERVICE_CODE"]];
    }
    [self setObject:newDic forKey:@"addondic"];
}

NSInteger addonDicSort(NSDictionary* id1, NSDictionary* id2, void *context) {
    NSInteger a = [[id1 objectForKey:@"SERVICE_ORDER"] integerValue];
    NSInteger b = [[id2 objectForKey:@"SERVICE_ORDER"] integerValue];
    return (a-b);
}

- (NSDictionary*) addonDic {
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    NSDictionary * dic = (NSDictionary *)[self objectForKey:@"addondic"];
    for (NSString * key in dic) {
        if ([[[dic objectForKey:key] objectForKey:@"SERVICE_TYPE"] isEqualToString:@"nfc"]) continue;
        Addon * addon = [Addon addonFromDic:[dic objectForKey:key]];
        [newDic setObject:addon forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:newDic];
}

- (NSArray*) addonArray {
    NSDictionary * dic = (NSDictionary *)[self objectForKey:@"addondic"];
    NSArray * array = [[dic allValues] sortedArrayUsingFunction:addonDicSort context:nil];
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary * item in array) {
        if ([[item objectForKey:@"SERVICE_TYPE"] isEqualToString:@"nfc"]) continue;
        [newArray addObject:[Addon addonFromDic:item]];
    }
    return [NSArray arrayWithArray:newArray];
}

- (NSDictionary*) allAddonDic {
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    NSDictionary * dic = (NSDictionary *)[self objectForKey:@"addondic"];
    for (NSString * key in dic) {
        Addon * addon = [Addon addonFromDic:[dic objectForKey:key]];
        [newDic setObject:addon forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:newDic];
}

- (NSArray*) allAddonArray {
    NSDictionary * dic = (NSDictionary *)[self objectForKey:@"addondic"];
    NSArray * array = [[dic allValues] sortedArrayUsingFunction:addonDicSort context:nil];
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary * item in array) {
        Addon * addon = [Addon addonFromDic:item];
        [newArray addObject:addon];
    }
    return [NSArray arrayWithArray:newArray];
}

- (void)setMidInfo:(NSDictionary*)dic {
    if (dic == nil) {
        self.uCode = nil;
        self.libid = nil;
        self.sno = nil;
        self.regno = nil;
        self.timeType = nil;
        self.codeType = nil;
    }
    else if ([dic objectForKey:@"code"] && [[dic objectForKey:@"code"] integerValue] == 0) {
        self.uCode = [dic objectForKey:@"uCode"];
        self.libid = [dic objectForKey:@"libid"];
        self.sno = [dic objectForKey:@"sno"];
        self.regno = [dic objectForKey:@"regno"];
        self.timeType = [dic objectForKey:@"timeType"];
        self.codeType = [dic objectForKey:@"codeType"];
    }
}

NSInteger Sort_Bookingdate_Comparer(id id1, id id2, void *context)
{
    // Sort Function
    NSDictionary * booking1 = id1;
    NSDictionary * booking2 = id2;
    return ([[booking1 objectForKey:@"SHORTCUT_ORDER"] compare:[booking2 objectForKey:@"SHORTCUT_ORDER"]]);
}

- (void)setShortcutItem:(Shortcut*)item order:(NSString*)order {

    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary*)[self objectForKey:@"shortcutdic"]];
    if (dic == nil) {
        dic = [NSMutableDictionary dictionary];
    }
    if (item) {
        [dic setObject:item.dic forKey:order];
    }
    else {
        [dic removeObjectForKey:order];
    }
    [self setObject:dic forKey:@"shortcutdic"];
}

- (Shortcut*) noticeShortcut {
    //return [Shortcut shortcutFromDic:(NSDictionary*)[self objectForKey:@"noticeShortcut"]];
    return [Shortcut shortcutForNotice];
}

- (Shortcut*) messageShortcut {
    //return [Shortcut shortcutFromDic:(NSDictionary*)[self objectForKey:@"messageShortcut"]];
    return [Shortcut shortcutForMessage];
}

- (NSMutableDictionary*) shortcutDictionary {
    NSDictionary * dic = (NSDictionary *)[self objectForKey:@"shortcutdic"];
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    for (NSString * key in dic) {
        [newDic setObject:[Shortcut shortcutFromDic:[dic objectForKey:key]] forKey:key];
    }
    return newDic;
}

+ (UserData*) reset {
    [_sharedUserData.userDefaults removeObjectForKey:kData_Version];
    _sharedUserData.COOKIE = nil;
    _sharedUserData.LOGON = nil;
    _sharedUserData.USER_ID = nil;
    _sharedUserData.HAS_CUSTOM_AUTOLOGIN = nil;
    _sharedUserData.CUSTOM_AUTOLOGIN = nil;
    //    NSUserDefaults * ud = [self sharedUserData].userDefaults;
    //	NSDictionary * dic = [ud dictionaryRepresentation];
    //
    //	for (NSString * key in [dic allKeys]) {
    //		if ([key hasPrefix:kProperty_UserData_Prefix]) {
    //			[ud removeObjectForKey:key];
    //		}
    //	}
    return [self save];
}

+ (UserData*) resetAll {
    [self reset];

    NSUserDefaults * ud = [self sharedUserData].userDefaults;
	NSDictionary * dic = [ud dictionaryRepresentation];

	for (NSString * key in [dic allKeys]) {
		if ([key hasPrefix:kProperty_UserData_Prefix]) {
			[ud removeObjectForKey:key];
		}
	}
    return [self save];
}

+ (UserData*) save {
    return [[self sharedUserData] save];
}

- (UserData*) save {
    [_userDefaults synchronize];
    return self;
}

- (id)init {
    if(self = [super init]) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (void) setObject:(NSObject*)object forKey:(NSString*)keyName {
    if (object == nil || [object isKindOfClass:[NSNull class]]) {
        [_userDefaults removeObjectForKey:[kProperty_UserData_Prefix stringByAppendingString:[keyName uppercaseString]]];
    }
    else {
        [_userDefaults setObject:object forKey:[kProperty_UserData_Prefix stringByAppendingString:[keyName uppercaseString]]];
    }
}

- (NSObject*) objectForKey:(NSString*)key {
    return [_userDefaults objectForKey:[kProperty_UserData_Prefix stringByAppendingString:[key uppercaseString]]];
}

+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
	if (([NSStringFromSelector(aSEL) rangeOfString:@":"].location != NSNotFound)){
		class_addMethod([self class], aSEL, (IMP)dynamicMethodIMP_UserData, "v@:@" );
	}
	else {
		class_addMethod([self class], aSEL, (IMP) dynamicMethodIMPWithReturn_UserData, "@@:");
	}
	return YES;
}

void dynamicMethodIMP_UserData(id self, SEL _cmd, id aValue) {

	@autoreleasepool {
		NSString * keyName = NSStringFromSelector(_cmd);

		keyName = [keyName substringToIndex:[keyName length]-1];
		keyName = [keyName substringFromIndex:3];

        [((UserData*)self) setObject:aValue forKey:keyName];
	}
}

id dynamicMethodIMPWithReturn_UserData(id self, SEL _cmd) {

    @autoreleasepool {
        NSString * keyName = NSStringFromSelector(_cmd);
        return [((UserData*)self) objectForKey:keyName];
    }
}

@end
