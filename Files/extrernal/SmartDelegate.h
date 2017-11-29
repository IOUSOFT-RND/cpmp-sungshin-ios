//
//  SmartDelegate.h
//  SmartLauncherSharedCode
//
//  Created by kwangsik.shin on 2014. 9. 28..
//  Copyright (c) 2014년 Arewith. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#endif

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s[Line %ld] " fmt), __PRETTY_FUNCTION__, (long)__LINE__, ##__VA_ARGS__)
#else
#define DLog(...)
#endif

@protocol SmartDelegate <NSObject>

@required
@property (strong, nonatomic) UIStoryboard *_storyboard;
@property (strong, nonatomic) UINavigationController *_navigationController;
@property (strong, nonatomic) NSString *_deviceToken;
@property (strong, nonatomic) NSDictionary *_pushDictionary;
@property (strong, nonatomic) UIViewController *_WebViewCtl;

-(void)showAlertWithTitle:(NSString *)title :(NSString *)text :(id)target :(SEL)selector;
-(void)closeAlertWithTitle;

-(void)closeConfirmWithTitle;
-(void)showConfirmWithTitle:(NSString *)title :(NSString *)text :(id)target :(SEL)selector;

-(void)sendIConSetting:(NSInteger)SettingIndex : (BOOL)SetType;
-(void)showIndecator;
-(void)hideIndecator;

-(void)checkLogin;
-(void)logout;

-(void)loadDataFromItemList;
-(void)listPageViewReload;
-(void)deleget_SmartCollectionview_Reload;
-(void)showMidPage;

-(void)sendDeviceToken:(NSString*)token;
-(void)goPushPage:(NSDictionary *)dic;

@end
