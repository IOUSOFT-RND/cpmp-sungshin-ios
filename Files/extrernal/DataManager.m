//
//  DataManager.m
//  
//
//  Created by softcross on 13. 6. 18..
//  Copyright (c) 2013년 softcross. All rights reserved.
//

#import "DataManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#define kIsShotCutLoadDynamically      @"kIsShotCutLoadDynamically"
#define kIsByPassLogin                 @"kIsByPassLogin"

@interface DataManager()
@end

@implementation DataManager
{}

#pragma mark - User Default 설정
- (BOOL)isShotCutLoadDynamically
{
    NSString *tempString = [[NSUserDefaults standardUserDefaults] objectForKey:kIsShotCutLoadDynamically];
    if (tempString && [tempString isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
    
}

- (void)setIsShotCutLoadDynamically:(BOOL)isShotCutLoadDynamically
{
    if (self.isShotCutLoadDynamically == isShotCutLoadDynamically ) {
        return;
    }
    NSString *tempString = isShotCutLoadDynamically?@"YES":@"NO";
    [[NSUserDefaults standardUserDefaults] setObject:tempString forKey:kIsShotCutLoadDynamically];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// login 생략
- (BOOL)isByPassLogin
{
    NSString *tempString = [[NSUserDefaults standardUserDefaults] objectForKey:kIsByPassLogin];
    if (tempString && [tempString isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
    
}

- (void)setIsByPassLogin:(BOOL)isByPassLogin
{
    if (self.isByPassLogin == isByPassLogin ) {
        return;
    }
    NSString *tempString = isByPassLogin?@"YES":@"NO";
    [[NSUserDefaults standardUserDefaults] setObject:tempString forKey:kIsByPassLogin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - 필요한 함수
- (BOOL)canUseCamera
{
    NSLog(@"[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]: %d", (int)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
    
}


- (void)updateDefaultShortcutData
{
    
}

#pragma mark -
static DataManager *instance = nil;

+ (DataManager *)getInstance
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [[self alloc] init];
            [instance execute];
		}
	}
	
	return instance;
}


- (id)init
{
	@synchronized(self)
	{
		self = [super init];
        
	}
	return self;
}


+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
	{
		if (instance == nil)
		{
			instance = [super allocWithZone:zone];
			return instance;
            
		}
	}
	return nil;
}

//  추가적으로 초기화 하거나 임시 초기데이터를 생성한다
- (void)execute
{
    // CFG_OPTION  서버 설정 상태값 초기값 설정
    self.qrCodeRefresh_rate_min = 5;
    self.gpsEnable = NO; // test default: NO
    self.isEnabledCustomFabvoritesColor = YES;
    self.magazineLayoutsPerRow = 8;
    self.userShortcutStartMenuIndex =2;
    self.defaultFabvoritesStartMenuIndex = 2;
    self.isUseNotice = YES;
    
    
}



@end