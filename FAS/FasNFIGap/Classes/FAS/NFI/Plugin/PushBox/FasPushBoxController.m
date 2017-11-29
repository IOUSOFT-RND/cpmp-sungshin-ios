//
//  FasPushBoxController.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 9..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FasPushBoxController.h"
#import "FasNFIGap.h"

@implementation FasPushBoxController 

@synthesize mContentView;

- (id)init
{
	self = [super init];

	return self;
}

//현재 띄워져 있는 fas webview의 사이즈
- (void)setBound:(CGRect)bound
{
	mRect = bound;
}

//파라메타로 전달받은 url 셋팅
- (void)setUrlLink:(NSString *)link
{
//    if (mUrlLink != nil)
//        [mUrlLink release];
	mUrlLink = [link copy];
}

//webView 닫기
- (void)removePage
{
	[mParentView removeFromSuperview];
}

//webView를 닫기 위해 객체를 전달
- (void)setParentView:(UIView*)view
{
	mParentView = view;
}

//현재 열려있는 주소를 웹브라우저로 열기
- (void)browser
{
	NSURL *goUrl = [[NSURL alloc] initWithString:mContentView.request.URL.absoluteString];
	[[UIApplication sharedApplication] openURL:goUrl];
	[goUrl release];
}

//화면 + toolbar 생성
- (void)loadView
{
	//rt : 전체 화면 크기 | fasRt : 현재 떠 있는 fas에서 만든 화면 크기
	CGRect rt = [[UIScreen mainScreen] bounds];
/*
	CGFloat height = 50.0f;
*/
	NSLog(@"@FAS@|rt.size.width : %f, rt.size.height : %f, fasRt.width : %f, fasRt.height : %f",
		  rt.size.width, rt.size.height, mRect.size.width, mRect.size.height);
	
	float fRectHeight;
	float fRectWidth;
	//세로보기 상태일 경우 (높이 : 최상단 bar의 높이만큼 빼준다) - 아래를 적용하지 않으면 회전에 따라 tabbar menu가 짤려 보이는 현상이 생김
	if (mRect.size.width == rt.size.width)
	{ //fasRt.width,height : 320,460 | rt.width,height : 320,480
		fRectHeight = mRect.size.height;
		fRectWidth = mRect.size.width;
	}
	else
	{ //fasRt.width,height : 480,300 | rt.width,height : 320,480
		fRectHeight = rt.size.height;
		fRectWidth = mRect.size.height;
	}
	NSLog(@"@FAS@|## tempRectHeight : %f, tempRectWidth : %f", fRectHeight, fRectWidth);
	
	//CGRect webFrame = CGRectMake(mRect.origin.x+30.0, mRect.origin.y+30.0, mRect.size.width-60.0, mRect.size.height-60.0);
	CGRect webFrame = CGRectMake(mRect.origin.x, mRect.origin.y, mRect.size.width, mRect.size.height);
/*
	CGRect tabFrame = CGRectMake(mRect.origin.x, mRect.origin.y + fRectHeight - height, fRectWidth, height);
*/	
//    NSURL* urls = [NSURL URLWithString:mUrlLink]; // URL 인코딩이 제대로 되지 않음 빈스트링 처리 된지 않음
//    NSURL* urls = [NSURL fileURLWithPath:mUrlLink]; // URL 인코딩이 제대로 되지 않음 빈스트링 처리 된지 않음
	//NSURL* urls = [NSURL URLWithString:[mUrlLink stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
//	NSURL* urls = [NSURL URLWithString:[mUrlLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
//    NSLog(@"***** FasPushBoxController.loadView - mUrlLink = %@", mUrlLink);
    
    NSURL *urls = [NSURL fileURLWithPath:mUrlLink];
    

	//이동 가능한 URL인 경우와 아닌 경우 처리
	if (![[UIApplication sharedApplication] canOpenURL:urls])
	{
        NSLog(@"***** FasPushBoxController.loadView - canOpenURL");
        
		mContentView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		mContentView.autoresizesSubviews = YES;
//		mContentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		mContentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        mContentView.scalesPageToFit = YES;
//        mContentView.delegate = self;
        [mContentView setDelegate:self];
//        mContentView.backgroundColor = [UIColor clearColor];
//        mContentView.opaque = NO;
/*
		// WorkLight에서 사용하는 WebView의 서브 스크롤뷰들을 삭제한다.
		for (id subview in self.webView.subviews)
			if ([[subview class] isSubclassOfClass: [UIScrollView class]])
				((UIScrollView *)subview).bounces = NO;
*/
//		for(id subview in mContentView.subviews) {
//			if([[subview class] isSubclassOfClass:[UIScrollView class]]) {
//				((UIScrollView *)subview).bounces = NO;
//			}
//		}
		
		
		
/*
		mContentView.layer.cornerRadius = 10;
		mContentView.layer.borderColor = [UIColor blackColor].CGColor;
		mContentView.layer.borderWidth = 2.3;
		mContentView.layer.shadowColor = [UIColor blackColor].CGColor;
		mContentView.layer.shadowOpacity = 1.0;
		mContentView.layer.shadowRadius = 7.0;
		mContentView.layer.shadowOffset = CGSizeMake(0,1);
		mContentView.clipsToBounds = YES;
*/		
		

		NSURLRequest* requestObj = [NSURLRequest requestWithURL:urls];
		[mContentView loadRequest:requestObj];
        
		/*  하단 toolbar  */
/*
		UIToolbar* bottomToolbar = [[UIToolbar alloc] initWithFrame:tabFrame];

		bottomToolbar.barStyle = UIBarStyleBlackTranslucent; //툴바의 색상은 까만 투명색
		
		//빈 영역 잡아주는 버튼 아이템. 왼쪽에 빈 영역을 두고, 오른쪽으로 버튼들을 배치하기 위함.
		UIBarButtonItem *flexibleSpaceItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		NSMutableArray *allitems = [[NSMutableArray alloc] init];

		//웹뷰 닫기
		[allitems addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(removePage)] autorelease]];
	
		
		[bottomToolbar setItems:allitems animated:YES];
		bottomToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
		bottomToolbar.hidden                 = NO;
		bottomToolbar.autoresizesSubviews    = YES;
		
		[mContentView addSubview:bottomToolbar];

		[bottomToolbar release];
		[flexibleSpaceItem2 release];
*/
		self.view = mContentView;
        
        CGRect rect = [[UIScreen mainScreen] applicationFrame];
        [self.view setFrame:rect];
        
//		[mContentView release]; 
	}
	else
	{
        NSLog(@"***** FasPushBoxController.loadView - cannot OpenURL");
		UITextView *contentTextView = [[UITextView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
		
		contentTextView.editable = NO;
		contentTextView.textAlignment = UITextAlignmentCenter;
		contentTextView.font = [UIFont fontWithName:@"American Typewriter" size:20];
        contentTextView.backgroundColor = [UIColor whiteColor];
		
		contentTextView.autoresizesSubviews = YES;
		contentTextView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		
		self.view = contentTextView;
//		[contentTextView release]; 
		
		// Initialize at 50
		[(UITextView *)self.view setText:@"\n잘못된 URL정보입니다."];
	}
    
//    [mParentView addSubview:self.view];

	self.navigationController.view.frame = webFrame;
	self.navigationController.navigationBarHidden = YES;

}

- (void) dealloc
{
    NSLog(@"FasPushBoxController - dealloc invoked!!");
//	[super dealloc];
//    [mContentView setDelegate:nil];
//    [mContentView stopLoading];
    
//    [mContentView stopLoading];
//    if(mContentView.delegate == self)
//        mContentView.delegate = nil;
//    mContentView = nil;
    [super dealloc];
}

//회전 시 반응함
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
#ifdef DEBUG
	NSLog(@"@FAS@|FASPushBoxController.shouldStartLoadWithRequest");
#endif
    
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(requestString);
    
#ifdef DEBUG
    if ([requestString hasPrefix:@"ios-log:"]) {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
#endif
    
	FasNFIGap* aFasNFIGap = [FasNFIGap getSharedInstance];
	[aFasNFIGap setWebView:webView nativeBridgeForWebView:request];
    

	return YES;
}

- (void)viewDidLoad
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasNFIGap.viewDidLoad");
#endif
//	mContentView.delegate = self;
	[super viewDidLoad];
    	NSLog(@"@FAS@|FasNFIGap.viewDidLoad - 1");
    [mContentView setDelegate:self];
    	NSLog(@"@FAS@|FasNFIGap.viewDidLoad - 2");
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasNFIGap.webViewDidFinishLoad");
#endif
}

- (void)webViewDidStartLoad:(UIWebView *)theWebView
{
#ifdef DEBUG
	NSLog(@"@FAS@|FasNFIGap.webViewDidStartLoad");
#endif
}

- (void)viewWillUnload
{
    [mContentView setDelegate:nil];
    [mContentView stopLoading];
}
/*
-(BOOL)shouldAutorotate{
    return YES;
}
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}
*/
@end

