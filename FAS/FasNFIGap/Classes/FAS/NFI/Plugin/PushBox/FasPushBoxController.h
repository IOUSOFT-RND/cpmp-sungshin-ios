//
//  FasPushBoxController.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FasPushBoxController : UIViewController <UIWebViewDelegate>
{
	int value;
	UIView* mParentView;
	CGRect mRect;
	NSString* mTitle;
	NSString* mUrlLink;
    UIWebView *mContentView;
}

@property (nonatomic,strong) UIWebView *mContentView;

- (id)init;
- (void)setBound:(CGRect)bound;
- (void)setUrlLink:(NSString *)link;
- (void)removePage;
- (void)setParentView:(UIView*)view;
- (void)browser;
- (void)loadView;
- (void)dealloc;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)viewDidLoad;
- (void)webViewDidFinishLoad:(UIWebView *)theWebView;
- (void)webViewDidStartLoad:(UIWebView *)theWebView;

@end
