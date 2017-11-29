//
//  TermsAndEmailViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 10..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewController,CustomActionSheetViewController;

@interface TermsAndEmailViewController : UIViewController<UITextFieldDelegate>
{
    HomeViewController *mHomeCtl;
    CustomActionSheetViewController *customCtl;
}
@property (nonatomic,strong) IBOutlet UIView *termsAgreeView;
@property (nonatomic,strong) IBOutlet UIView *NextBtnView ;
@property (nonatomic,strong) IBOutlet UIButton *termsAgreeCheckBox1;
@property (nonatomic,strong) IBOutlet UIButton *termsAgreeCheckBox2;
@property (nonatomic,strong) IBOutlet UITextField *EmailTextFild;
@property (nonatomic,strong) IBOutlet UIButton  *AgreeBtn;

- (IBAction)AgressBtn:(id)sender;
- (IBAction)EmailConfirm:(id)sender;
- (IBAction)back:(id)sender;


@end
