//
//  SideMenuViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SettingViewController;

@interface SideMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIStoryboard *stroybord;
    SettingViewController *settingCtl;
    NSMutableArray *mDataArray;
}

@property (nonatomic,strong) IBOutlet UITableView *mSideTableMenu;


-(IBAction)NoticeAction:(id)sender;
-(IBAction)MessageAction:(id)sender;
-(IBAction)TotalServiceAction:(id)sender;
-(IBAction)QRCodeReader:(id)sender;
-(IBAction)Setting:(id)sender;

@end

