//
//  WebViewController.h
//  Smart
//
//  Created by hwansday on 2014. 5. 15..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreLocation/CoreLocation.h>
#import "SmartDelegate.h"
#import "ServiceInfo.h"

@class CustomActionSheetViewController;

@interface WebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>
{
    CustomActionSheetViewController *customCtl;
    BOOL isClose;
    BOOL isPopup;
}

@property (strong, nonatomic) ServiceInfo *service;
@property (strong, nonatomic) IBOutlet UIWebView *_webView;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *prev;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *home;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reload;
@property (strong, nonatomic) IBOutlet UIButton  *WebviewtopBtn;

- (void)LoadwebView:(NSString *)stringURL;

- (IBAction) actionPrev:(UIBarButtonItem*)sender;
- (IBAction) actionNext:(UIBarButtonItem*)sender;
- (IBAction) actionHome:(UIBarButtonItem*)sender;
- (IBAction) actionReload:(UIBarButtonItem*)sender;
- (IBAction) WebViewTopBtnAction:(id)sender;
@end

@class WebFrame;
@interface UIWebView (JavaScriptAlert)<CLLocationManagerDelegate,UIWebViewDelegate>

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString*)message initiatedByFrame:(WebFrame *)frame;
@end