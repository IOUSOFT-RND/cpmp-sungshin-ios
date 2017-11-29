//
//  SideMenuCollectionViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 8. 18..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewController;

@interface SideMenuCollectionViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIStoryboard *stroybord;
    SettingViewController *settingCtl;
    NSMutableArray *mDataArray;
}

@property (nonatomic,strong) IBOutlet UICollectionView *mSideCollenctionMenu;


-(IBAction)NoticeAction:(id)sender;
-(IBAction)MessageAction:(id)sender;
-(IBAction)TotalServiceAction:(id)sender;
-(IBAction)QRCodeReader:(id)sender;
-(IBAction)Setting:(id)sender;


@end
