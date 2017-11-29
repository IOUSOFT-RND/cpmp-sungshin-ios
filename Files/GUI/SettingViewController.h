//
//  SettingViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkSettingViewController,CustomActionSheetViewController;

@interface SettingViewController : UIViewController
{
    BookmarkSettingViewController *bookmarkSettingCtl;
    CustomActionSheetViewController *customCtl;
}
@property (nonatomic,strong) IBOutlet UILabel  *mlogoutId;
@property (nonatomic,strong) IBOutlet UISwitch *autologin;
@property (nonatomic,strong) IBOutlet UISwitch *notiSetting;
@property (nonatomic,strong) IBOutlet UISwitch *PlarsticCard;
@property (nonatomic,strong) IBOutlet UISwitch *MobileCard;
@property (nonatomic,strong) IBOutlet UILabel  *version;
@property (nonatomic,strong) IBOutlet UIView   *SmartIDView;
@property (nonatomic,strong) IBOutlet UIView   *VersionView;
@property (nonatomic,strong) IBOutlet UIView   *VersionLine;
@property (nonatomic,strong) IBOutlet UIView   *UpdataView;
@property (nonatomic,strong) IBOutlet UIButton *UpdataBtn;

@property (nonatomic,strong) IBOutlet UILabel  *SmartIDversion;
@property (nonatomic,strong) IBOutlet UIView   *SmartIDVersionView;
@property (nonatomic,strong) IBOutlet UIView   *SmartIDVersionLine;
@property (nonatomic,strong) IBOutlet UIView   *SmartIDUpdataView;
@property (nonatomic,strong) IBOutlet UIButton *SmartIDUpdataBtn;

-(IBAction)backAction:(id)sender;
-(IBAction)BookmarkSetting:(id)sender;
-(IBAction)logoutMenu:(id)sender;

-(IBAction)AutoLoginSetting:(id)sender;
-(IBAction)NotiSetting:(id)sender;

@end
