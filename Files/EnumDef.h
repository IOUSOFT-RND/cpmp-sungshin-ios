//
//  EnumDef.h
//  GyeongbukUni
//
//  Created by kdsooi on 13. 7. 23..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#ifndef emdm_EnumDef_h
#define emdm_EnumDef_h

typedef enum
{
    BY_SERVER = 0,
    BY_USER,
    BY_DEVICE,
} NotificationType;

typedef enum
{
    EMPTY = 0,
    PREDO,
    DOING,
    DONE,
    ERROR,
} NotificationState;

typedef enum
{
    NOTIFICATION_MSG_DO_ALL = 0,
    NOTIFICATION_MSG_DO_ONE,
    NOTIFICATION_MSG_DO_INITIATION,
}NotificationHandlerState;


typedef enum
{
    AUTH_READ = 0,
    AUTH_CURRENT,
    AUTH_END,
}AuthState;

typedef enum
{
    ENTER_REQEST = 0,
    ENTER_RESPONSE = 1,
    EXIT_REQEST = 2,
    EXIT_RESPONSE = 3,
}AttendanceState;

typedef enum 
{
    DM = 0,
    MDM = 1,
} ServiceType;

typedef enum
{
    INITIATION = 0,
    AUTH,
    LODING,
    ATTENDANCE,
    POSITION,
    HARDWARE,
} ActionType;

typedef enum
{
    STUDENT = 1,
    TEACHER,
    PARENT,
    ADMIN
}UserCategory;

typedef enum
{
    LocationSerch = 1,
    ContactChoies,
    EmergencyCall,
    EnterWayChoies,
    EnterSucceed,
    EnterNFC,
    FailAttendanc,
    UnRegisterUser,
    WebRefrsh
}PopupType;

typedef enum
{
    AdminCtl = 1,
    UserCtl,
    PhoneRegisterCtl,
    AuthenticationCtl,
    QRcodeCtl,
    LaunchCtl,
    WebviewCtl
}ControllersType;

typedef enum
{
    Join= 1,
    key,
    Attendance_IC,
    Loading_IC,
    Locaiton_IC,
    Service_IC,
    Notice_IC,
}IconType;

typedef enum
{
    Unchecked = 0,
    Enter,
    Exit,
    Vacation,
    OutSide,
    BusinessTrip
}AttendanceType;

typedef enum
{
    Login_defualt = 0,
    Nomal_Noti = 1,
    Minwon_Noti = 3,
    Login_Retry = 10,
    Login_Page_move =11,
    SIMPLE_LOGIN = 12,
    APPVERSION_UPDATE_defualt = 21,
    APPVERSION_UPDATE_chioce = 22,
    Login_Error = 30,
}LoginErrorState;

#endif
