//
//  AppDelegate.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 20..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@class UISidebarViewController,WebViewController,CustomActionSheetViewController,MessageBordViewController,SideMenuCollectionViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIStoryboard *iphone;
    /*
    UIStoryboard *iphone4Inch;
    UIStoryboard *iphone4_7Inch;
    UIStoryboard *iphone5_5Inch;
     */
}

@property (strong, nonatomic) UISidebarViewController *sidebarVC;
@property (strong, nonatomic) WebViewController *webViewCtl;
@property (strong, nonatomic) CustomActionSheetViewController *customViewCtl;
@property (strong, nonatomic) MessageBordViewController * MessageCtl;
@property (strong, nonatomic) ServiceInfo * simpleAddon;
@property (strong, nonatomic) WebViewController * wbCtl;
@property (nonatomic) int userType;

@property (nonatomic)  BOOL misLogin;
@property (nonatomic)  BOOL mSimpleLogin;
@property (nonatomic)  BOOL misSubScribe;
@property (strong, nonatomic) UIWindow *window;

- (NSString *) getCno;
- (NSString *) localOSlang;
- (void) windowRootViewChange;
- (void) SideVcAddViewPopup;
- (void) openSimpleLoginViewController;
- (void) SideVcAddViewServerSyncFailAlert;
- (void) SideVcAddViewPopupIdentificationFail;
- (void) SideVcLossAddViewPopup;
@end

