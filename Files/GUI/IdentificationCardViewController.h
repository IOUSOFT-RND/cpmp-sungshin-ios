//
//  IdentificationCardViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

@class CustomActionSheetViewController;

@interface IdentificationCardViewController : UIViewController
{
    CustomActionSheetViewController *actionSheetViewCtl;
    NSString *mIdentiUsekey;
    NSString *mQRCodeTime;
    int TimerCount;
    BOOL isFlipped;
    BOOL isTransitioning;
    NSString *AnimationhidnView;
    NSTimer *repeatTimer;
    NSString *AnimationState;
}

@property (nonatomic) IBOutlet UIView       *mCreatView;
@property (nonatomic) IBOutlet UIImageView  *mBackgroundImageView;
@property (nonatomic) IBOutlet UIView       *mSemiView;
@property (nonatomic) IBOutlet UIView       *mdetailView;
@property (nonatomic) IBOutlet UIView       *mdataView;
@property (nonatomic) IBOutlet UIImageView  *mSemiStudenImage;
@property (nonatomic) IBOutlet UILabel      *mName;
@property (nonatomic) IBOutlet UILabel      *mCollege;
@property (nonatomic) IBOutlet UILabel      *mdescript;
@property (nonatomic) IBOutlet UIImageView  *msmallQR;
@property (nonatomic) IBOutlet UILabel      *mtimerNum;
@property (nonatomic) IBOutlet UIImageView  *mIndicater;
@property (nonatomic) IBOutlet UIButton     *mDelete;
@property (nonatomic) IBOutlet UIButton     *mrefreshBtn;
@property (nonatomic) IBOutlet UIImageView  *mlargeQRImage;
@property (nonatomic) IBOutlet UIButton     *mSemiFixBtn;
@property (nonatomic) IBOutlet UIButton     *mDetailFixBtn;



-(IBAction)smallQRAction:(id)sender;

-(IBAction)IDCardCreate:(id)sender;
-(IBAction)backBtn:(id)sender;
-(IBAction)refresh:(id)sender;
-(IBAction)deleteAction:(id)sender;
-(IBAction)SemiViewFixBtn:(id)sender;
-(IBAction)largeViewFixBtn:(id)sender;

@end
