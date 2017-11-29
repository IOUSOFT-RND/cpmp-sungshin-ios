//
//  Common.h
//  SmartOffice
//
//  Created by hwansday on 2014. 5. 1..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserData.h"
#import "Base64.h"

#define APPID  @"launcher"
#define DEVICE @"11"

#define HTTP    @"http://"

@interface Common : NSObject

//Ryu add  아이콘 흰색으로 만들기
+(UIImage*)imageWhiteWithImage:(UIImage*)image;

+(void)setServerAddress:(NSString*)address;
+(void)setMobileServerAddress:(NSString*)address;
+(void)setAddress:(NSString*)address key:(NSString*)key;

+(NSString*)addressHomePage;
+(NSString*)addressFaq;

+(NSString*)addressUpdate;
+(NSString*)addressLogin;
+(NSString*)addressServiceList;
+(NSString*)addressSendTocken;
+(NSString*)addressNoticeList;
+(NSString*)addressNotice;
+(NSString*)addressMessageList;
+(NSString*)addressMessage;
+(NSString*)addressShortCut;
+(NSString*)addressSmartId;
+(NSString*)addressCheckSmartId;
+(NSString*)addressJoinSmartId;

+(NSString*)addressSendPush;
+(NSString*)addressPushInfo;

+(NSString*)addressLoggingWithRunMenu;
+(NSString*)addressLoggingWithErrorWeb;
+(NSString*)addressLoggingWithTagging;

+(UIColor *) colorWithHexString: (NSString *) hexString;

//+(NSString *)convertGyosiNumber:(int)num;
////+ (NSString *)dataFilePath;
+(NSString *)dataPhotoFilePath;
+(BOOL)dataFilePhotoDelete;
+(BOOL)dataFilePhotoSave:(NSData*)saveData;
//+ (BOOL)dataFilePathDelect;
//+ (BOOL)dataFileSave:(NSData*)SavaList;
//+ (NSMutableArray *)dataFileArray;
//+(NSString *)mutablearryToString:(NSMutableArray*)mutablearray;
//+(NSMutableArray *)stringToMutablearray:(NSString*)datastring;
+(NSString *)updateTimecode;

+(void) setUseMidInfo:(BOOL)use;
+(BOOL) useMidInfo;

+(NSString*)appid;
+(NSString*)currentVersion;
+(BOOL)needUpdate:(NSString*)version;
+(NSString*)bundleIdentifier;

+(BOOL)boolAppYN:(NSString*)schemesURL;
+(BOOL)openURL:(NSString*)urlString;

+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString;
+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString dic:(NSDictionary*)dic;
+(NSString*)getUrlStringWithApplyMetaData:(NSString*)urlString dic:(NSDictionary*)dic gpsInfo:(NSArray *__autoreleasing *)gpsInfoArray;
+(NSString*)addressHttpCheck:(NSString *)address;

@end
