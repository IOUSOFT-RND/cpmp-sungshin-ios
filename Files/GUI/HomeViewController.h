//
//  HomeViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 12..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "QRCodeReaderViewController.h"

@class CardCellViewController,SideMenuViewController,IdentificationCardViewController,SettingViewController;
@class NoticeBordViewController,MessageBordViewController,QRCodeReaderViewController,TotalServiceViewController;
@class CustomActionSheetViewController,SideMenuCollectionViewController;

@interface HomeViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,ZXingDelegate>
{
    SideMenuCollectionViewController *mSideMenuCollectionViewCtl;
    SideMenuViewController *mSideMenuTableViewCtl;
    IdentificationCardViewController *midentificaitonCtl;
    CardCellViewController *mCardCellCtl;
    SettingViewController *settingCtl;
    NoticeBordViewController *noticeBordCtl;
    MessageBordViewController *MessageBordCtl;
    QRCodeReaderViewController *mQRviewCtl;
    TotalServiceViewController *mTotalCtl;
    CustomActionSheetViewController *customCtl;
    NSUInteger moveIndex;
    
    NSInteger ViewIndex;
}


@property (strong, nonatomic) UIPageViewController      *pageController;
@property (strong, nonatomic) IBOutlet      UIImageView *mMainTileImage;
@property (strong, nonatomic) IBOutlet      UIView      *mSideMenuTouchView;
@property (strong, nonatomic) IBOutlet      UIButton    *MenuBtn;
@property (strong, nonatomic) IBOutlet      UIView      *mPageView;
@property (strong, nonatomic) IBOutlet      UIButton    *mPast;
@property (strong, nonatomic) IBOutlet      UIButton    *mToday;
@property (strong, nonatomic) IBOutlet      UIButton    *mBookmark;
@property (strong, nonatomic) IBOutlet      UIView      *mPastBtnLineView;
@property (strong, nonatomic) IBOutlet      UIView      *mTodayBtnLineView;
@property (strong, nonatomic) IBOutlet      UIView      *mBookmarkBtnLineView;

-(IBAction)PastTapSelect:(id)sender;
-(IBAction)TodayTapSelect:(id)sender;
-(IBAction)BookmarkTapSelect:(id)sender;
-(IBAction)IdentificationAction:(id)sender;

@end
