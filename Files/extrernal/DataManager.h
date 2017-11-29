//
//  DataManager.h
//
//
//  1. 서버에서 받은 데이터를 보관한다.  2.재사용이 필요한 생성 데이터를 보관한다 3.접근이 필요한 객체포인터를 보관한다 4.UserDefault의 관리
//  Created by Ryu on 15. 3. 11.
//  Copyright (c) 2013년 iconlab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DataManager : NSObject {
}


#pragma mark - Life cycle
+ (DataManager *)getInstance;
-(void)execute; //  추가적으로 초기화 하거나 임시 초기데이터를 생성한다

#pragma mark - 접근이 필요한 뷰
@property (nonatomic, assign) UIViewController *mainPageViewController;


#pragma mark - CFG_OPTION  서버 설정 상태값 저장
// gps정보 사용 여부   *Defalt: false
@property (nonatomic, assign) BOOL gpsEnable;  // main_use_gpson_qr 값이 true일때 gps정보를 서버에 보내도록

// 신분증의 QR코드를 리플래시 하는 시간(분)
@property (nonatomic, assign) int qrCodeRefresh_rate_min;

// login 생략 기능
@property (nonatomic, assign) BOOL isByPassLogin;  // 대구대만 YES

// 즐겨찾기 커스텀 컬러 사용
@property (nonatomic, assign) BOOL isEnabledCustomFabvoritesColor;  // 대구대만 YES
@property (nonatomic, retain) NSMutableArray *customColorArray;

// 공지사항 사용여부
@property (nonatomic, assign) BOOL isUseNotice; // 대구대만 NO

// 메뉴 레이아웃 변경시 사용
@property (nonatomic, assign) BOOL isEnabledCustomLayouts;  // 대구대만 YES
@property (nonatomic, assign) int magazineLayoutsPerRow;
@property (nonatomic, retain) NSArray *customCellTypeArray;

// 메뉴 바로가기 기본 설정 기능
@property (nonatomic, assign) BOOL isEnabledDefaultShortcut; // 기본 바로가기 메뉴 사용여부
@property (nonatomic, assign) BOOL isShotCutLoadDynamically;
@property (nonatomic, assign) int userShortcutStartMenuIndex;
@property (nonatomic, assign) int defaultFabvoritesStartMenuIndex;



#pragma mark - 기타

#pragma mark - 필요한 함수
- (void)updateDefaultShortcutData;
- (BOOL)canUseCamera;
   

@end