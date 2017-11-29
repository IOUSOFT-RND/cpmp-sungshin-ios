//
//  WebViewController.m
//  Smart
//
//  Created by hwansday on 2014. 5. 15..
//  Copyright (c) 2014년 GGIHUB. All rights reserved.
//
// 웹뷰를 관리하는 페이지
#import "WebViewController.h"
#import "Common.h"
#import "LogHelper.h"
#import "HttpHelper.h"
#import "AppDelegate.h"
#import "EnumDef.h"
#import "CustomActionSheetViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "StringEnumDef.h"
#import "Json.h"
#import "ServerIndexEnum.h"

@interface WebViewController () {
    id<SmartDelegate>  appDelegate;
    NSString *tempURL;
    UIViewController *IndicationCtl;
    BOOL isIndigater;
}

@end

@implementation WebViewController
@synthesize service,WebviewtopBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isIndigater = false;
    appDelegate = (id<SmartDelegate>) [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebviewRemove) name:@"WebviewRemoe" object:nil];
    __webView.backgroundColor = [UIColor whiteColor];
    __webView.scrollView.backgroundColor = [UIColor whiteColor];
    [__webView.scrollView setDelegate:self];
    [__webView.scrollView setBounces:NO];
    __webView.delegate = self;
    NSString * urlString = [Common addressHomePage];
    if (tempURL) urlString = tempURL;
    [self._webView loadRequest:[HttpHelper requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    self._webView.scrollView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}

-(void)WebviewRemove
{
    isClose = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)LoadwebView:(NSString *)stringURL{
    tempURL = stringURL;
    isClose = false;
    DLog(@"LOAD URL : %@", stringURL);
    if (self._webView && tempURL) {
        [self._webView loadRequest:[HttpHelper requestWithURL:[NSURL URLWithString:[stringURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)WebViewTopBtnAction:(id)sender
{
    [__webView.scrollView setContentOffset:CGPointMake(0.0f, 0.0f)];
}

-(void)AddIndicationCtl
{
    if (!isIndigater)
    {
        isIndigater = true;
        IndicationCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"InticationView"];
        NSMutableArray *subview = [[NSMutableArray alloc] init];
        [subview addObjectsFromArray:self.view.subviews];
        [self.view addSubview: IndicationCtl.view];
    }
}

#pragma mark - webview
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    DLog(@"Start Log");
    [self AddIndicationCtl];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    DLog(@"Finish Log");
    [self resetButtonStatus];
    [IndicationCtl.view removeFromSuperview];
    isIndigater =false;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"Fail Log %@",error);
    isIndigater =false;
    __webView.backgroundColor = [UIColor whiteColor];
    __webView.scrollView.backgroundColor = [UIColor whiteColor];
    
    [LogHelper loggingForWebError:webView.request.URL.absoluteString
                          service:service
                          message:[NSString stringWithFormat:@"%d",(int)error.code]];
    
    if ([self.view.subviews containsObject:customCtl.view])
    {
        [customCtl.view removeFromSuperview];
    }
    customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
    customCtl.TitleLabel = @"해당 웹페이지를 사용할 수 없습니다.";
    customCtl.mtype = Login_defualt;
    customCtl.confirmLabel = @"확인";
    [self.view addSubview:customCtl.view];

    [self resetButtonStatus];
}

- (UIViewController *)presentingViewController {
    
    static BOOL flagged;
    if (flagged ||[self.presentedViewController isKindOfClass:[UIDocumentMenuViewController class]]) {
        flagged = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            flagged = NO;
        });
        return nil;
    } else {
        return [super presentingViewController];
    }
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if ( self.presentedViewController || isClose)
    {
        isClose = false;
        [super dismissViewControllerAnimated:flag completion:completion];
    }
}

-(void)fnFailLoad{
    [self.navigationController popViewControllerAnimated:YES];
    [self resetButtonStatus];
}

- (IBAction) actionPrev:(UIBarButtonItem*)sender {
    [__webView goBack];
    [self resetButtonStatus];
}

- (IBAction) actionNext:(UIBarButtonItem*)sender {
    [__webView goForward];
    [self resetButtonStatus];
}

- (IBAction) actionHome:(UIBarButtonItem*)sender {
    
    isClose = true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) actionReload:(UIBarButtonItem*)sender {
    [__webView reload];
}

- (void)resetButtonStatus {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (__webView) {
                _prev.enabled = [__webView canGoBack];
                _next.enabled = [__webView canGoForward];
            }
        });
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > 5.0f)
    {
        [WebviewtopBtn setHidden:NO];
    }
    else
        [WebviewtopBtn setHidden:YES];
        
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    if ([self stringFromContain:urlString :@"http://14.63.168.70:9280/spay/"])//[urlString containsString:@"http://14.63.168.70:9280/spay/"]ios8
    {
        [self LoginAction];
    }

    return YES;
}

- (void)LoginAction
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
    
    [param setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] forKey:@"auto"];
    [param setObject:@"islogin" forKey:@"CMD"];
    
    
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
        
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"islogin"])
        {
            if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        if ([self.view.subviews containsObject:customCtl.view])
                        {
                            [customCtl.view removeFromSuperview];
                        }
                        customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                        customCtl.TitleLabel = Double_Login_Title;
                        customCtl.mtype = SIMPLE_LOGIN;
                        customCtl.confirmLabel = @"확인";
                        customCtl.cancelLabel = @"취소";
                        [self.view addSubview:customCtl.view];
                        
                    });
                });
                
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        if ([self.view.subviews containsObject:customCtl.view])
                        {
                            [customCtl.view removeFromSuperview];
                        }
                        customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                        customCtl.TitleLabel = Loss_Login_Title;
                        customCtl.mtype = SIMPLE_LOGIN;
                        customCtl.confirmLabel = @"확인";
                        [self.view addSubview:customCtl.view];
                        
                    });
                });
            }
        }
        
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self._webView loadRequest:[HttpHelper requestWithURL:[NSURL URLWithString:[@"about:blank" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
    
}


@end



@implementation UIWebView (JavaScriptAlert)

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString*)message initiatedByFrame:(WebFrame *)frame {
    DLog(@"javascript alert : %@",message);
    if([message isEqualToString:@"APP_CMD>action=go_home"]){
       [[self appDelegate].webViewCtl dismissViewControllerAnimated:YES completion:nil];
    } else if([message isEqualToString:@"APP_CMD>action=go_mid"]){
        [[self appDelegate].webViewCtl dismissViewControllerAnimated:YES completion:nil];
    } else{
        [[[UIAlertView alloc]initWithTitle:@"알림" message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles: nil] show];
    }
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    NSString *lat = [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.latitude];
    NSString *lng = [[NSString alloc]initWithFormat:@"%g",newLocation.coordinate.longitude];
    NSString *tempjavascript = @"setMapCenter('{lat}','{lng}','현위치')";

    tempjavascript = [tempjavascript stringByReplacingOccurrencesOfString:@"{lat}" withString:lat];
    tempjavascript = [tempjavascript stringByReplacingOccurrencesOfString:@"{lng}" withString:lng];

    [((WebViewController*)self)._webView stringByEvaluatingJavaScriptFromString:tempjavascript];

    [manager stopUpdatingLocation];

}
@end

