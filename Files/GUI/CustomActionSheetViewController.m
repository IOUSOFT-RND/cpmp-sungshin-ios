//
//  CustomActionSheetViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "CustomActionSheetViewController.h"
#import "AppDelegate.h"
#import "EnumDef.h"

@interface CustomActionSheetViewController ()

@end

@implementation CustomActionSheetViewController
@synthesize mCanCel,mConfirm,mTitle;
@synthesize confirmLabel,cancelLabel,TitleLabel;
@synthesize mTotalView,mSemiView,mSemiConfirm,mSemiTitle;
@synthesize mLagreCanCel,mLagreConfirm,mLagreTitle,mLagreTotalView;
@synthesize mtype, mAniTotalView;
@synthesize mTotalView_Bottonview,mTotalView_Topview,mLagreTotalView_Bottonview,mLagreTotalView_Topview,AlertInfo;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.cancelLabel == nil || [self.cancelLabel isEqualToString:@""])
    {
        [mSemiView setHidden:NO];
        [mTotalView setHidden:YES];
        [mLagreTotalView setHidden:YES];
        [self.mSemiTitle setText:TitleLabel];
        [self.mSemiConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
    }
    else
    {
        [mSemiView setHidden:YES];
        if (mtype >= 10 && mtype < 20)
        {
            [mTotalView setHidden:YES];
            [mLagreTotalView setHidden:NO];
            [self.mLagreTitle setText:TitleLabel];
            [self.mLagreConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mLagreCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }
        else
        {
            [mLagreTotalView setHidden:YES];
            [mTotalView setHidden:NO];
            [self.mTitle setText:TitleLabel];
            [self.mConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }

    }
    [self AddViewAnimation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Do any additional setup after loading the view.
    
    [self RoundviewCreate:mSemiView];
    [self RoundviewCreate:mTotalView_Topview];
    [self RoundviewCreate:mTotalView_Bottonview];
    [self RoundviewCreate:mLagreTotalView_Topview];
    [self RoundviewCreate:mLagreTotalView_Bottonview];

    
    if (self.cancelLabel == nil || [self.cancelLabel isEqualToString:@""])
    {
        [mSemiView setHidden:NO];
        [mTotalView setHidden:YES];
        [mLagreTotalView setHidden:YES];
        [self.mSemiTitle setText:TitleLabel];
        [self.mSemiConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
    }
    else
    {
        [mSemiView setHidden:YES];
        if (mtype >= 10 && mtype < 20)
        {
            [mTotalView setHidden:YES];
            [mLagreTotalView setHidden:NO];
            [self.mLagreTitle setText:TitleLabel];
            [self.mLagreConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mLagreCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }
        else
        {
            [mLagreTotalView setHidden:YES];
            [mTotalView setHidden:NO];
            [self.mTitle setText:TitleLabel];
            [self.mConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }
        
    }
}

-(void)ViewReLoad
{
    [self RoundviewCreate:mSemiView];
    [self RoundviewCreate:mTotalView_Topview];
    [self RoundviewCreate:mTotalView_Bottonview];
    [self RoundviewCreate:mLagreTotalView_Topview];
    [self RoundviewCreate:mLagreTotalView_Bottonview];
    
    
    if (self.cancelLabel == nil || [self.cancelLabel isEqualToString:@""])
    {
        [mSemiView setHidden:NO];
        [mTotalView setHidden:YES];
        [mLagreTotalView setHidden:YES];
        [self.mSemiTitle setText:TitleLabel];
        [self.mSemiConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
    }
    else
    {
        [mSemiView setHidden:YES];
        if (mtype >= 10 && mtype < 20)
        {
            [mTotalView setHidden:YES];
            [mLagreTotalView setHidden:NO];
            [self.mLagreTitle setText:TitleLabel];
            [self.mLagreConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mLagreCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }
        else
        {
            [mLagreTotalView setHidden:YES];
            [mTotalView setHidden:NO];
            [self.mTitle setText:TitleLabel];
            [self.mConfirm setTitle:self.confirmLabel forState:UIControlStateNormal];
            [self.mCanCel setTitle:self.cancelLabel forState:UIControlStateNormal];
        }
        
    }
    
}


-(void)RoundviewCreate:(UIView *)view
{
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

- (void)AddViewAnimation
{
    float mViewHeight = mAniTotalView.frame.size.height;
    mAniTotalView.transform = CGAffineTransformMakeTranslation(0.0f,[[UIScreen mainScreen] bounds].size.height);
    float yPos = [[UIScreen mainScreen] bounds].size.height - mViewHeight;
    
    
    [UIView beginAnimations:@"yPosionTrans" context:(__bridge void *)(mAniTotalView)];
    [UIView setAnimationDuration:0.7f];
    [UIView setAnimationDelegate:self];
    CGRect frame = mAniTotalView.frame;
    frame.origin = CGPointMake(0.0f, yPos); // 이동시킬 위치
    mAniTotalView.frame = frame;
    mAniTotalView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)RemoveViewAnimation
{

    
    //    [UIView beginAnimations:@"yPosionTrans" context:(__bridge void *)(mAniTotalView)];
    //    [UIView setAnimationDuration:1.0f];
    //    [UIView setAnimationDelegate:self];
    //    CGRect frame = mAniTotalView.frame;
    //    frame.origin = CGPointMake(0.0f, [[UIScreen mainScreen] bounds].size.height); // 이동시킬 위치
    //    mAniTotalView.frame = frame;
    //    mAniTotalView.transform = CGAffineTransformIdentity;
    //    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)ComfirmAction:(id)sender
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         // Grow!
                         mAniTotalView.transform = CGAffineTransformMakeTranslation(0.0f, [[UIScreen mainScreen] bounds].size.height);
                     }
                     completion:^(BOOL finished){
                         if([confirmLabel isEqualToString:@"로그아웃"])
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingLogOut" object:nil];
                             [self.view removeFromSuperview];
                         }
                         else if([confirmLabel isEqualToString:@"확인"])
                         {
                             if ([TitleLabel isEqualToString:@"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요."])
                             {
                                 exit(0);
                                 return;
                             }
                             
                             if ([TitleLabel isEqualToString:@"해당 웹페이지를 사용할 수 없습니다."])
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"WebviewRemoe" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else if (mtype == Login_Retry)
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"OverWriteLogin" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else if(mtype == Login_Page_move)
                             {
                                 [[self appDelegate] setMisLogin:NO];
                                 [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewChange" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else if(mtype == SIMPLE_LOGIN)
                             {
                                 [[self appDelegate] setMisLogin:NO];
                                 [[self appDelegate] setMSimpleLogin:YES];
                                 [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewChange" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else if(mtype == APPVERSION_UPDATE_defualt || mtype == APPVERSION_UPDATE_chioce)
                             {
                                 NSString *urlAddress = @"itms-services://?action=download-manifest&url=https://dl.dropboxusercontent.com/s/r6sk6u0pru4ue2o/Slu.plist?";
                                 NSURL *url = [NSURL URLWithString:urlAddress];
                                 [[UIApplication sharedApplication] openURL:url];
                                 exit(0);
                             }
                             else if(mtype == Login_Error)
                             {
                                 [self.view removeFromSuperview];
                             }
                             else if(mtype == Nomal_Noti)
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageViewAdd" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else
                             {
                                 [self.view removeFromSuperview];
                             }
                             
                         }
                         else if([confirmLabel isEqualToString:@"삭제"])
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"IdentificationdeleteAction" object:nil];
                             [self.view removeFromSuperview];
                         }
                         else if([confirmLabel isEqualToString:@"닫기"])
                         {
                             [self.view removeFromSuperview];
                         }
                     }];


}

- (IBAction)cancelAction:(id)sender
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         // Grow!
                         mAniTotalView.transform = CGAffineTransformMakeTranslation(0.0f, [[UIScreen mainScreen] bounds].size.height);
                     }
                     completion:^(BOOL finished){
                         if ([cancelLabel isEqualToString:@"취소"])
                         {
                             if (mtype == Login_Retry)
                             {
                                 exit(0);
                             }
                             else if(mtype == Login_Page_move)
                             {
                                 [[self appDelegate] setMisLogin:NO];
                                 [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                                 exit(0);
                             }
                             else if(mtype == SIMPLE_LOGIN)
                             {
                                 [[self appDelegate] setMisLogin:NO];
                                 [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                                 exit(0);
                             }
                             else if(mtype == APPVERSION_UPDATE_chioce)
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"AppUpdataPass" object:nil];
                                 [self.view removeFromSuperview];
                             }
                             else
                             {
                                 [self.view removeFromSuperview];
                             }
                         }
                     }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
