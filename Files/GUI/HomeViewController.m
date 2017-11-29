//
//  HomeViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 12..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "HomeViewController.h"
#import "CardCellViewController.h"
#import "IdentificationCardViewController.h"
#import "SettingViewController.h"
#import "NoticeBordViewController.h"
#import "MessageBordViewController.h"
#import "UISidebarViewController.h"
#import "TotalServiceViewController.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "SmartDelegate.h"

#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "Json.h"

#import "AESHelper.h"
#import "Common.h"
#import "UserData.h"
#import "LogHelper.h"

#import "ServiceDb.h"

#import "CustomActionSheetViewController.h"
#import "EnumDef.h"
#import "StringEnumDef.h"


#define USE_UIKIT_DYNAMICS      NO

#define SETTINGE_CTL      1
#define IDENTIFI_CTL      2

@interface HomeViewController ()
{
    BOOL bIndentifiAction;
}
@end

@implementation HomeViewController
@synthesize pageController,mPageView,mBookmark,mPast,mToday,MenuBtn;
@synthesize mSideMenuTouchView,mMainTileImage;
@synthesize mPastBtnLineView,mBookmarkBtnLineView,mTodayBtnLineView;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)loadView
{
    [super loadView];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MainImageType"] != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSMutableString *ImageDir = [[NSMutableString alloc] initWithString:documentsDirectory];
        [ImageDir appendString:@"/mobile/"];
        [ImageDir appendFormat:@"%@/",[[NSUserDefaults standardUserDefaults] objectForKey:@"MainImageType"]];
        [ImageDir appendString:@"bg_top@2x.png"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImageDir])
            [mMainTileImage setImage:[UIImage imageWithContentsOfFile:ImageDir]];
        else
            [mMainTileImage setImage:[UIImage imageNamed:@"bg_top@2x.png"]];
    }
    else
        [mMainTileImage setImage:[UIImage imageNamed:@"bg_top@2x.png"]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewIndex = -1;
    bIndentifiAction = false;
    
    [mTodayBtnLineView setHidden:YES];
    [mPastBtnLineView setHidden:YES];
    [mBookmarkBtnLineView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SettingViewAction) name:@"SettingViewAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoticBordViewAction) name:@"NoticeBordAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MessageViewAction) name:@"MessageBordAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TotalServiceAction) name:@"TotalServiceAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendIConWebview:) name:@"WebViewAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DetailWebviews:) name:@"DetailWebviews" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QRCodeRederAction) name:@"QRCodeRederAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoubleLoginAlertView) name:@"DoubleLoginAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LossLoginAlertView) name:@"LossLoginAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ServerSyncFailAlertView) name:@"ServerSyncFailAction" object:nil];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.delegate = self;
    self.pageController.dataSource = self;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568.0)
        {
            [[self.pageController view] setFrame:CGRectMake(0, 0, 320, 492)];
        }
        else if([[UIScreen mainScreen] bounds].size.height == 480.0)
        {
            [[self.pageController view] setFrame:CGRectMake(0, 0, 320, 494)];
        }
        else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
        {
            [[self.pageController view] setFrame:CGRectMake(0, 0, 375, 591)];
        }
        else
        {
            [[self.pageController view] setFrame:CGRectMake(0, 0, 414, 660)];
        }
    }
    
    CardCellViewController *initialViewController = [self viewControllerAtIndex:1];
    [MenuBtn addTarget:[self appDelegate].sidebarVC action:@selector(toggleSidebar:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [mPageView addSubview:[self.pageController view]];
    [mToday setSelected:YES];
    [mTodayBtnLineView setHidden:NO];
    [self.pageController didMoveToParentViewController:self];
    
}

-(void)DetailWebviews:(NSNotification *)noti
{
    [self sendWebviews:[[noti userInfo] objectForKey:@"URL"]];
}


-(void)sendIConWebview:(NSNotification *)noti{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *stringURL = [[noti userInfo] objectForKey:@"URL"];
            
            WebViewController *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
            [wb setService:[[noti userInfo] objectForKey:@"service"]];
            [wb LoadwebView:stringURL];
            [self appDelegate].webViewCtl = wb;
            [self presentViewController:wb animated:YES completion:^{
                [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
            }];
        });
    });
}

-(void)sendWebviews:(NSString *)url
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            WebViewController *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
            [wb LoadwebView:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self appDelegate].webViewCtl = wb;
            [self presentViewController:wb animated:YES completion:^{
                [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
            }];
        });
    });
}


-(void)SettingViewAction
{
    ViewIndex = SETTINGE_CTL;
    [self getSmartCardAction];
}

-(void)SetttingPageMove
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            settingCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewCtl"];
            [self presentViewController:settingCtl animated:YES completion:^{
                [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
            }];
        });
    });
}

-(void)MessageViewAction
{
    MessageBordCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageBordViewCtl"];
    
    [self presentViewController:MessageBordCtl animated:YES completion:^{
        [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
    }];
    
}

-(void)NoticBordViewAction
{
    noticeBordCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticeBordViewCtl"];
    
    [self presentViewController:noticeBordCtl animated:YES completion:^{
        [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
    }];
    //    http://192.168.10.87:8080/iou/getBoardBox.do?isLogin=true
    //    [self sendWebviews:@"http://192.168.10.87:8080/iou/getBoardBox.do?isLogin=true"];
}

-(void)TotalServiceAction
{
    mTotalCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"TotalServiceViewCtl"];
    
    [self presentViewController:mTotalCtl animated:YES completion:^{
        [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
    }];
    
}

-(void)QRCodeRederAction
{
    mQRviewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeReaderViewCtl"];
    
    [mQRviewCtl setZingDelegate:self];
    [self presentViewController:mQRviewCtl animated:YES completion:^{
        [((UISidebarViewController *)[self appDelegate].sidebarVC) displaySidebar:false animations:nil completion:nil];
    }];
    
}

-(IBAction)PastTapSelect:(id)sender
{
    if ([sender isSelected])
    {
        return;
        
    }
    else
    {
        [mPast setSelected:YES];
        [mToday setSelected:NO];
        [mBookmark setSelected:NO];
        [self PageviewChange:0];
        [mPastBtnLineView setHidden:NO];
        [mTodayBtnLineView setHidden:YES];
        [mBookmarkBtnLineView setHidden:YES];
    }
}

-(IBAction)TodayTapSelect:(id)sender
{
    if ([sender isSelected])
    {
        return;
        
    }
    else
    {
        [mPast setSelected:NO];
        [mToday setSelected:YES];
        [mBookmark setSelected:NO];
        [self PageviewChange:1];
        [mPastBtnLineView setHidden:YES];
        [mTodayBtnLineView setHidden:NO];
        [mBookmarkBtnLineView setHidden:YES];
    }
}
-(IBAction)BookmarkTapSelect:(id)sender
{
    if ([sender isSelected])
    {
        return;
        
    }
    else
    {
        [mPast setSelected:NO];
        [mToday setSelected:NO];
        [mBookmark setSelected:YES];
        [self PageviewChange:2];
        [mPastBtnLineView setHidden:YES];
        [mTodayBtnLineView setHidden:YES];
        [mBookmarkBtnLineView setHidden:NO];
    }
}

-(IBAction)IdentificationAction:(id)sender
{
    if (!bIndentifiAction)
    {
        bIndentifiAction = true;
        ViewIndex = IDENTIFI_CTL;
        [self getSmartCardAction];
    }
}

-(void)IdentificationPagemove
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"SMARTID_TYPE"] isEqualToString:@"1"]
                && [[[NSUserDefaults standardUserDefaults] objectForKey:@"SMART_CARD_TYPE"] isEqualToString:@"1"])
            {
                [[self appDelegate] SideVcAddViewPopupIdentificationFail];
                bIndentifiAction = false;
            }
            else
            {
                
                midentificaitonCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"IdentificationCardViewController"];
                
                // Add the destination view as a subview, temporarily
                [self.view addSubview:midentificaitonCtl.view];
                [self.view bringSubviewToFront:midentificaitonCtl.view];
                
                // Transformation start scale
                midentificaitonCtl.view.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] bounds].size.width, 0.0f);
                
                
                [UIView animateWithDuration:0.25
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     // Grow!
                                     midentificaitonCtl.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
                                 }
                                 completion:^(BOOL finished){
                                     bIndentifiAction = false;
                                 }];
            }
        });
    });

}

-(void)PageviewChange:(int)index
{
    CardCellViewController *initialViewController = [self viewControllerAtIndex:index];;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
}


- (void)getSmartCardAction
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    
    
    plainID  = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    base64ID = [plainID base64EncodedString];
    
    plainPW  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
    base64PW =[plainPW base64EncodedString];
    
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:@"getUsedOneCard" forKey:@"CMD"];
    
    NSMutableString *ParamString = [[NSMutableString alloc] init];
    NSArray *keys = [param allKeys];
    for (int i = 0; i<[keys count];i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *tempString;
        if (![[param objectForKey:key] isKindOfClass:[NSString class]])
        {
            tempString = [NSString stringWithFormat:@"%d",[[param objectForKey:key] intValue]];
        }
        else
            tempString = [param objectForKey:key];
        
        [ParamString appendString:[NSString stringWithFormat:@"%@=%@",key,[tempString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        if ([keys count]-1 != i)
        {
            [ParamString appendString:@"&"];
        }
    }
    [self reqestSending:SERVER_QueryClientBox :[ParamString dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)reqestSending:(NSString *)urlString :(NSData *)bodyData
{
    
    NSURL           *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest     *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    
    NSURLSession            *session = [NSURLSession sharedSession];
    NSURLSessionDataTask  *uploadTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200)
            {
                [self processResponse:data];
            }
            else
            {
                
                NSLog(@"result = %@", [httpResponse description]);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Communication Error"
                                                                    message:@"We received error from server."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Not Connectable"
                                                                message:@"We do not connect to the server."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }];
    [uploadTask resume];
}

- (void)processResponse:(NSData *)aData
{
    NSLog(@"processResponse ");
    
    if (![[self appDelegate] misLogin])
    {
        return;
    }
    
    if (aData != nil)
    {
        NSString *ConvertString = [[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding];
        if (ConvertString == nil) {
            ConvertString = [[NSString alloc] initWithData:aData encoding:(0x80000000+kCFStringEncodingEUC_KR)];
        }
        
        NSLog(@"Data = %@",ConvertString);
        NSDictionary *reponseData = [Json decode:ConvertString];
        
        if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    [[self appDelegate] SideVcAddViewPopup];
                    
                });
            });
            
        }
        else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    [[self appDelegate] SideVcLossAddViewPopup];
                    
                });
            });
        }

        
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"getUsedOneCard"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"SMARTID_TYPE"] forKey:@"SMARTID_TYPE"];
                
                if ([reponseData objectForKey:@"SMARTID_TYPE"] == nil)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"SMARTID_TYPE"];
                }
                
                if (ViewIndex == 1)
                {
                    [self SetttingPageMove];
                }
                else
                {
                    [self IdentificationPagemove];
                }
            }
            else
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"SMARTID_TYPE"];
            
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CardCellViewController *)viewControllerAtIndex:(NSUInteger)index
{
    CardCellViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CardCellViewController"];
    [childViewController setIndex:index];
    
    return childViewController;
    
}

#pragma UIPageViewDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    moveIndex = [[pendingViewControllers objectAtIndex:0] index];
    NSLog(@"PageView willTransitionToViewControllers = %d",(int)moveIndex);
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed && finished)
    {
        NSLog(@"PageView didFinishAnimating = %d",(int)moveIndex);
        if ([pageViewController.viewControllers count] > 0)
        {
           moveIndex = ((CardCellViewController *)[pageViewController.viewControllers objectAtIndex:0]).index;
        }
        
        switch (moveIndex) {
            case 0:
                [mPast setSelected:YES];
                [mToday setSelected:NO];
                [mBookmark setSelected:NO];
                [mPastBtnLineView setHidden:NO];
                [mTodayBtnLineView setHidden:YES];
                [mBookmarkBtnLineView setHidden:YES];
                
                break;
            case 1:
                [mToday setSelected:YES];
                [mPast setSelected:NO];
                [mBookmark setSelected:NO];
                [mPastBtnLineView setHidden:YES];
                [mTodayBtnLineView setHidden:NO];
                [mBookmarkBtnLineView setHidden:YES];
                break;
            case 2:
                [mBookmark setSelected:YES];
                [mToday setSelected:NO];
                [mPast setSelected:NO];
                [mPastBtnLineView setHidden:YES];
                [mTodayBtnLineView setHidden:YES];
                [mBookmarkBtnLineView setHidden:NO];
                break;
                
            default:
                break;
        }
    }
}

#pragma UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(CardCellViewController *)viewController index];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(CardCellViewController *)viewController index];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - ZXingQR
#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(QRCodeReaderViewController*)controller didScanResult:(NSString *)result
{
    NSLog(@"didScanResult= %@",result);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *decodedString = [AESHelper aesDecryptString:result];
            NSLog(@"didScanResult= %@",decodedString);
            
            // do something useful with results
            // useMid 모바일 학생증 아이디
            if ([decodedString hasPrefix:@"sid"]||[decodedString hasPrefix:@"kosid"])
            {
                //        if ([Common useMidInfo])
                //        {
                //            UserData * ud = [UserData sharedUserData];
                //            if (ud.regno == nil) {
                //                // 테깅 성공시 학생증이 없을경우 팅겨냄.
                //                [appDelegate showAlertWithTitle:@"알림" :@"태깅처리를 하려면 모바일회원증을 발급 받으세요." :nil :nil];
                //                [self.navigationController popToRootViewControllerAnimated:YES];
                //                return;
                //            }
                //        }
                
                NSArray * array = [decodedString componentsSeparatedByString:@":"];
                if ([array count] > 1) {
                    NSString * sid;
                    if ([decodedString hasPrefix:@"sid"])
                    {
                        sid = [[array objectAtIndex:0] stringByReplacingOccurrencesOfString:@"sid=" withString:@""];
                    }
                    else
                    {
                        sid = [[array objectAtIndex:0] stringByReplacingOccurrencesOfString:@"kosid=" withString:@""];
                    }
                    
                    NSString * tid = [[array objectAtIndex:1] stringByReplacingOccurrencesOfString:@"tid=" withString:@""];
                    
                    ServiceInfo * addon = nil;
                    NSArray *ServiceArray = [ServiceDb getQRServiceMenuAll:sid];
                    for (ServiceInfo * item in ServiceArray)
                    {
                        if ([item.QRType isEqualToString:sid])
                        {
                            addon = item;
                            [[UserData sharedUserData] setUSER_ID:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                            [[UserData sharedUserData] setUSER_PASS:[[NSUserDefaults standardUserDefaults] objectForKey:@"pw"]];
                            [[UserData sharedUserData] setUSER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"]];
                            
                            break;
                        }

                    }
                    
                    if (!addon)
                    {
                        for (ServiceInfo * item in ServiceArray)
                        {
                            if ([self stringFromContain:item.QRType :@"-"])//[item.QRType containsString:@"-" ]ios8
                            {
                                NSArray *vlueArray = [item.QRType componentsSeparatedByString:@"-"];
                                int minValue = [[vlueArray objectAtIndex:0] intValue];
                                int macValue = [[vlueArray objectAtIndex:1] intValue];
                                
                                if (minValue <= [sid intValue] && macValue >= [sid intValue])
                                {
                                    addon = item;
                                    [[UserData sharedUserData] setUSER_ID:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                                    [[UserData sharedUserData] setUSER_PASS:[[NSUserDefaults standardUserDefaults] objectForKey:@"pw"]];
                                    [[UserData sharedUserData] setUSER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"]];
                                    
                                    break;
                                }
                            }
                        }
         
                    }
                    
                    if (addon) {
                        NSArray * gpsArray = nil;
                        
                        NSDictionary * tagDic = nil;
                        tagDic = @{@"nfcValue":decodedString, @"nfcTid":tid, @"nfcSid":sid};
                        
                        NSString *content_url;
                        NSString * newUrl ;
                        
                        
                        switch ([addon.contentType intValue])
                        {
                            case 1:
                                
                                if (addon.construction == nil|| [addon.construction isEqualToString:@""])
                                {
                                    content_url = addon.contentUrl;
                                    newUrl = [Common getUrlStringWithApplyMetaData:content_url dic:tagDic gpsInfo:&gpsArray];
                                    //                                newUrl = [NSString stringWithFormat:@"tag=%@&sid=%@&tagType=Q",decodedString , sid];
                                    
                                    if (![Common openURL:newUrl])
                                    {
                                        [Common openURL:addon.storeUrl];
                                    }
                                }
                                else
                                {
                                    [self sendWebviews:addon.construction];
                                }

                                
                                
                                [LogHelper loggingForMenuRun:addon];
                                [LogHelper loggingForTagging:addon // service code
                                                     tagType:@"1"  // Q : qrcode, N : NFC
                                                      tagUid:@""
                                                       tagId:decodedString
                                                    latitude:[gpsArray objectAtIndex:0]
                                                   longitude:[gpsArray objectAtIndex:1]];
                                break;
                            case 2:
                                
                                if (addon.construction == nil|| [addon.construction isEqualToString:@""])
                                {
                                    content_url = addon.webContentUrl;
                                    newUrl = [Common getUrlStringWithApplyMetaData:content_url dic:tagDic gpsInfo:&gpsArray];
                                    [self sendWebviews:newUrl];
                                }
                                else
                                {
                                    [self sendWebviews:addon.construction];
                                }

                                [LogHelper loggingForMenuRun:addon];
                                [LogHelper loggingForTagging:addon // service code
                                                     tagType:@"1"  // Q : qrcode, N : NFC
                                                      tagUid:@""
                                                       tagId:decodedString
                                                    latitude:[gpsArray objectAtIndex:0]
                                                   longitude:[gpsArray objectAtIndex:1]];
                                break;
                            case 3:
                                
                                if (addon.construction == nil|| [addon.construction isEqualToString:@""])
                                {
                                    content_url = addon.browserContentUrl;
                                    newUrl = [Common getUrlStringWithApplyMetaData:content_url dic:tagDic gpsInfo:&gpsArray];
                                    [Common openURL:newUrl];
                                }
                                else
                                {
                                    [self sendWebviews:addon.construction];
                                }


                                [LogHelper loggingForMenuRun:addon];
                                [LogHelper loggingForTagging:addon // service code
                                                     tagType:@"1"  // Q : qrcode, N : NFC
                                                      tagUid:@""
                                                       tagId:decodedString
                                                    latitude:[gpsArray objectAtIndex:0]
                                                   longitude:[gpsArray objectAtIndex:1]];
                                break;
                                
                            default:
                                break;
                        }
                        
                        [mQRviewCtl dismissViewControllerAnimated:YES completion:nil];
                    }
                    else
                    {
                        [mQRviewCtl dismissViewControllerAnimated:YES completion:^{
                            [[[UIAlertView alloc] initWithTitle:@"알림"
                                                        message:@"사용할 수 없는 태그입니다."
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil] show];
                        }];
                    }
                }
                else
                    [mQRviewCtl dismissViewControllerAnimated:YES completion:^{
                        [[[UIAlertView alloc] initWithTitle:@"알림"
                                                    message:@"사용할 수 없는 태그입니다."
                                                   delegate:self
                                          cancelButtonTitle:@"확인"
                                          otherButtonTitles:nil] show];
                    }];

                
                
            }
            else {
                [mQRviewCtl dismissViewControllerAnimated:YES completion:^{
                    [[[UIAlertView alloc] initWithTitle:@"알림"
                                                message:@"사용할 수 없는 태그입니다."
                                               delegate:self
                                      cancelButtonTitle:@"확인"
                                      otherButtonTitles:nil] show];
                }];
            }
            DLog(@"decodedString %@",decodedString);
            
        });});
    
}

-(void)DoubleLoginAlertView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            [[self appDelegate] SideVcAddViewPopup];
        });
    });
}

-(void)LossLoginAlertView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            [[self appDelegate] SideVcLossAddViewPopup];
        });
    });
}

- (BOOL)stringFromContain:(NSString *) BaseString :(NSString *) serchString
{
    if([BaseString length] < 1)
    {
        return false;
    }
    
    NSRange textRangs = [BaseString rangeOfString:serchString];
    
    if (textRangs.location == NSNotFound)
    {
        return false;
    }
    
    return true;
}


-(void)ServerSyncFailAlertView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            [[self appDelegate] SideVcAddViewServerSyncFailAlert];
        });
    });
}


-(void)zxingControllerDidCancel:(QRCodeReaderViewController *)controller
{
    [mQRviewCtl dismissViewControllerAnimated:YES completion:nil];
}

@end
