//
//  QRCodeReaderViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZXingObjC/ZXingObjC.h>

@protocol ZXingDelegate;

@class CustomActionSheetViewController;

@interface QRCodeReaderViewController : UIViewController<ZXCaptureDelegate>
{
    CustomActionSheetViewController *customCtl;
}

@property (nonatomic) BOOL bResult;

-(void)setZingDelegate:(id<ZXingDelegate>)mdelegate;
-(IBAction)Cancel:(id)sender;

@end

@protocol ZXingDelegate
- (void)zxingController:(QRCodeReaderViewController*)controller didScanResult:(NSString *)result;
- (void)zxingControllerDidCancel:(QRCodeReaderViewController*)controller;
@end
