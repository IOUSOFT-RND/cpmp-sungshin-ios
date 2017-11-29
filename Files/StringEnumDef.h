//
//  StringEnumDef.h
//  emdm
//
//  Created by jaewon on 2013. 12. 30..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#ifndef emdm_StringEnumDef_h
#define emdm_StringEnumDef_h


#define APPCODE         @"1100" // 앱 코드

#define DEVICE_INITATIONS              @"device_Initation"
#define NOTI_INFO_REG                  @"noti_Reg"
#define APP_VERSION                    @"app_version"
#define Server_Version                 @"Server_Version"

#define WEB_NOTI                       @"Notice"
#define NEW_WEB_NOTI                   @"New_Notice"
#define Old_WEB_NOTI                   @"Old_Notice"

#define WEB_NOTI1NO                    @"Notice1No"
#define WEB_NOTI2NO                    @"Notice2No"
#define WEB_NOTI3NO                    @"Notice3No"

#define USER_LEVEL                     @"User_Level"

#define Calling_Target                 @"Calling_target"

#define ATTENDANCERECORDS              @"AttendanceRecords"

#define ATTENDANCEDATE                 @"AttendanceDate"
#define EXITDATE                       @"ExitDate"
#define ATTENDANCESTATE                @"AttendanceState"
#define BeconPosition                  @"BeaconPosition"

#define NOTI_HOUR_ALERT                @"hour_alert_state"
#define NOTI_DAY_ALERT                 @"day_alert_state"
#define AUTH_COMPLETE                  @"auth_complete"
#define AUTH_NUN                       @"auth_Num"

#define BEACON_POSITION                @"BeaconPosition"

#define APP_NAME                       @"스마트맥"
#define USER_PHONENUMBER               @"user_phoneNumber"


#define PUSH_GET_NOTI                  @"Push_noti"
#define PUSH_EMERGENCY                 @"Push_Emergency"
#define PUSH_EMERGENCY_info            @"Push_Emergency_info"

#define TODAY_ATTENDANCE_STATE         @"Today_Attendance_State"

#define WARNING_CONNECT_FAIL_STRING    @"웹페이지에 접속할 수 없습니다. \n네트워크 상태를 체크 해주세요. "


#define LODING_STTRING                 @"로딩중.."

#define HTTP_ERROR                     @"서버와의 통신이 실패하였습니다.\n관리자에게 문의 해주세요."
#define HTTP_ERROR_TEXT                @"서버와의 통신이 실패하였습니다."
#define HTTP_RETRY                     @"서버와의 통신이 실패하여 1분 후 재시도 합니다. \n재시도 횟수 :"

#define NOTICE_REG                     @"공지사항이 등록 되었습니다."
#define APP_UPDATE                     @"최신 버전이 등록되었습니다. \n업데이트를 진행 후 서비스를 이용해주세요."
#define PROFILE_PHOTO_REG              @"프로필 사진이 등록 되었습니다."
#define PROFILE_PHOTO_REG_FAIL         @"프로필 사진을 등록하지 못하였습니다."

#define DEVICE_INIT_FAIL               @"디바이스 설정 초기화에 실패하였습니다.\n앱을 다시 실행하여 디바이스 등록을 완료하여 주시기 바랍니다."
#define WARNING_APNS_REG_NONSETTING_STRING     @"푸시알림 설정을 허용하지 않으실 경우 수업관련 공지를 못 받으실수 있습니다.\n설정 < 알림센터 < CLE < 알림스타일을 배너 또는 알림으로 설정부탁드립니다."

#define NON_USER_INFOMATION            @"사용자 정보를 찾을 수 없습니다.\n관리자에게 문의해주세요."

#define Base64ID                            @"base64id"
#define Base64PW                            @"base64pw"

#define Msgobj_id                           @"Msgobj_id"
#define Msgobj_type                         @"Msgobj_type"

#define CardType_Message    1
#define CardType_lcecture   2
#define CardType_Food       3
#define CardType_Bus        4
#define CardType_Notic      5

#define Loss_Login_Title @"현재 기기는 분실처리된 단말입니다.\n"
#define Double_Login_Title @"다른 기기에서 로그인 되어있습니다.\n다른 기기의 로그인을 끊고 현재의 기기에서 로그인하시겠습니까?"
#define SmartIDCreatFail   @"SmartID 발급이 실패 하였습니다."
#define SmartIDNumCreatFail   @"SmartID 차수가 없어서 발급이 실패 하였습니다."

#define NotiSettingAlert   @"푸시 설정은 변경하시려면\n\"설정>알림>bufs\"에서 변경해주세요."

#define CONFIRM   @"확인"
#define APP_CLOSE @"닫기"
#define RETRY     @"Retry"
#define CANCEL    @"Cancel"

#endif
