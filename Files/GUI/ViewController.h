//
//  ViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 20..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LogInViewController,TermsAndEmailViewController,HomeViewController,CustomActionSheetViewController;

@interface ViewController : UIViewController<UIActionSheetDelegate>
{
    LogInViewController *mLoginCtl;
    TermsAndEmailViewController *mTermsCtl;
    HomeViewController *mHomeCtl;
    CustomActionSheetViewController *customCtl;
    BOOL bMainImgChange;
    BOOL bStudentChange;
}

@property (nonatomic,strong) IBOutlet UIImageView *mProgressview;

@end

