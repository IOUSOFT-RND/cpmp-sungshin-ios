//
//  LogHelper.h
//  SmartLauncherSharedCode
//
//  Created by kwangsik.shin on 2014. 9. 30..
//  Copyright (c) 2014년 Arewith. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceInfo.h"
#import "HttpDelegate.h"

@interface LogHelper : NSObject<HttpDelegate>
{
}

+(void)loggingForMenuRun:(ServiceInfo *)service;
+(void)loggingForWebError:(NSString*)url service:(ServiceInfo*)service message:(NSString*)message;
+(void)loggingForTagging:(ServiceInfo *)service tagType:(NSString*)tagType tagUid:(NSString*)tagUid tagId:(NSString*)tagId;
+(void)loggingForTagging:(ServiceInfo *)service tagType:(NSString*)tagType tagUid:(NSString*)tagUid tagId:(NSString*)tagId latitude:(NSString*)latitude longitude:(NSString*)longitude;

@end
