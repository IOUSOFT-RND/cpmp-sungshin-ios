//
//  CustomActionSheetViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomActionSheetViewController : UIViewController

@property (nonatomic) int mtype;
@property (nonatomic,strong) NSString *TitleLabel;
@property (nonatomic,strong) NSString *confirmLabel;
@property (nonatomic,strong) NSString *cancelLabel;
@property (nonatomic,strong) NSDictionary *AlertInfo;

@property (nonatomic,strong) IBOutlet UIView *mAniTotalView;

@property (nonatomic,strong) IBOutlet UIView *mLagreTotalView;
@property (nonatomic,strong) IBOutlet UIView *mLagreTotalView_Topview;
@property (nonatomic,strong) IBOutlet UIView *mLagreTotalView_Bottonview;
@property (nonatomic,strong) IBOutlet UILabel *mLagreTitle;
@property (nonatomic,strong) IBOutlet UIButton *mLagreConfirm;
@property (nonatomic,strong) IBOutlet UIButton *mLagreCanCel;


@property (nonatomic,strong) IBOutlet UIView *mTotalView;
@property (nonatomic,strong) IBOutlet UIView *mTotalView_Topview;
@property (nonatomic,strong) IBOutlet UIView *mTotalView_Bottonview;
@property (nonatomic,strong) IBOutlet UIView *mSemiView;
@property (nonatomic,strong) IBOutlet UILabel *mTitle;
@property (nonatomic,strong) IBOutlet UIButton *mConfirm;
@property (nonatomic,strong) IBOutlet UILabel *mSemiTitle;
@property (nonatomic,strong) IBOutlet UIButton *mSemiConfirm;
@property (nonatomic,strong) IBOutlet UIButton *mCanCel;

- (void)setConfirmLabel:(NSString *)confirm;
- (void)setCancelLabel:(NSString *)cancel;
- (IBAction)ComfirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
-(void)ViewReLoad;

@end
