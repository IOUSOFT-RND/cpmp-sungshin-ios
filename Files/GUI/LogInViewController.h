//
//  LogInViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TermsAndEmailViewController,HomeViewController,CustomActionSheetViewController;

@interface LogInViewController : UIViewController<UITextFieldDelegate>
{
    TermsAndEmailViewController *mTermsCtl;
    HomeViewController *mHomeCtl;
    CustomActionSheetViewController *actionSheetViewCtl;
}

@property (nonatomic) BOOL mIsOverwrite;
@property (nonatomic,strong) IBOutlet UIImageView *IDFailImage;
@property (nonatomic,strong) IBOutlet UIImageView *PasswordFailImage;
@property (nonatomic,strong) IBOutlet UITextField *IDTextFild;
@property (nonatomic,strong) IBOutlet UITextField *PasswordTextFild;
@property (nonatomic,strong) IBOutlet UILabel *IDFailLabel;
@property (nonatomic,strong) IBOutlet UILabel *PasswordFailLabel;
@property (nonatomic,strong) IBOutlet UIButton *AutoLoginCheckBox;

- (IBAction)AutoLoginStateCheck:(id)sender;
- (IBAction)LoginBtn:(id)sender;
- (IBAction)openUseInformation:(id)sender;
- (IBAction)openFindPassword:(id)sender;

@end
