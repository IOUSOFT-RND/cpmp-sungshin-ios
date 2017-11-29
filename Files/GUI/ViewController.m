//
//  ViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 20..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "FasPushControl.h"
#import "FasPushCallback.h"
#import "LogInViewController.h"
#import "EnumDef.h"

#import "ServerIndexEnum.h"
#import "StringEnumDef.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSString+Escape.h"
#import "Json.h"

#import "ServiceDb.h"
#import "ServiceInfo.h"
#import "TermsAndEmailViewController.h"
#import "HomeViewController.h"
#import "CustomActionSheetViewController.h"


#define DEG2RAD(degrees) (degrees * 0.01745327)

@interface ViewController ()
{
    CAShapeLayer *slice;
    NSInteger agrees;
    NSTimer *timer;
}
@end


@implementation ViewController
@synthesize mProgressview;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    CGPoint point = mProgressview.layer.frame.origin;
    
    point.x = point.x + mProgressview.layer.frame.size.width/2;
    point.y = point.y + mProgressview.layer.frame.size.height/2;
    
    slice = [CAShapeLayer layer];
    slice.fillColor = [UIColor whiteColor].CGColor;
    slice.strokeColor = [UIColor whiteColor].CGColor;
    slice.lineWidth = 1;
    agrees = -89;
    
    CGFloat angle = DEG2RAD(-90.0);
    CGPoint center = point;
    CGFloat radius = 15.0;
    
    UIBezierPath *piePath = [UIBezierPath bezierPath];
    [piePath moveToPoint:center];
    
    [piePath addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];
    
    [piePath addArcWithCenter:center radius:radius startAngle:angle endAngle:DEG2RAD(agrees) clockwise:YES];
    [piePath closePath];
    
    
    [self.view.layer addSublayer:slice];
    
    NSLog(@"slice width = %f, height = %f",slice.frame.size.width,slice.frame.size.height);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(TimerPath) userInfo:nil repeats:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscribeCompleteCallback:) name:@"subscribeComplete" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NextLoginView) name:@"AppUpdataPass" object:nil];
    [self LodingAction];

}

- (void)TimerPath
{
    
    if (agrees < 270)
    {
       agrees = agrees+1;
    }
    
    CGFloat angle = DEG2RAD(-90.0);
    CGPoint center = mProgressview.center;
    CGFloat radius = 15.0;
    
    UIBezierPath *piePath2 = [UIBezierPath bezierPath];
    [piePath2 moveToPoint:center];
    
    [piePath2 addLineToPoint:CGPointMake(center.x + radius * cosf(angle), center.y + radius * sinf(angle))];
    
    [piePath2 addArcWithCenter:center radius:radius startAngle:angle endAngle:DEG2RAD(agrees) clockwise:YES];
    
    
    //  [piePath addLineToPoint:center];
    [piePath2 closePath];
    // this will automatically add a straight line to the center
    slice.path = piePath2.CGPath;
    
    if (agrees >= 270)
    {
        agrees = -89;
    }
    
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)subscribeCompleteCallback:(NSNotification *) noti
{
    NSLog(@"complete subcribe");
    if ([[noti userInfo] objectForKey:@"TEMPLATE_TYPE"] != nil)
    {
        [self TempletChangeCheck:[[noti userInfo] objectForKey:@"TEMPLATE_TYPE"]];
    }

}

-(void)AppUpDataCheck
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"Server-VERSION"] != nil)
    {
        NSString *server_versionInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"Server-VERSION"];
        NSString *UpdataMessage = @"버전 업데이트를 하시겠습니까?";
        NSArray *infoArray;
        
        if ([self stringFromContain:server_versionInfo :@"/" ] )//[server_versionInfo containsString:@"/"]ios8
        {
            infoArray = [server_versionInfo componentsSeparatedByString:@"/"];
        }
        
        if (infoArray != nil && [infoArray count])
        {
            if ([infoArray count] >= 3 )
            {
                NSString *temString = [[infoArray objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if (![temString isEqualToString:@""])
                {
                    UpdataMessage = (NSString *)[infoArray objectAtIndex:2];
                }
            }
            
            
            if ([[infoArray objectAtIndex:1] isEqualToString:@"1"])//필수
            {
                if (![self appVersionCheck:[self getAppVersion] :[infoArray objectAtIndex:0]])
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            if ([self.view.subviews containsObject:customCtl.view])
                            {
                                [customCtl.view removeFromSuperview];
                            }
                            customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            customCtl.TitleLabel = UpdataMessage;
                            customCtl.mtype = APPVERSION_UPDATE_defualt;
                            customCtl.confirmLabel = @"확인";
                            customCtl.cancelLabel = nil;
                            [self.view addSubview:customCtl.view];
                            
                        });
                    });
                    
                }
                else
                    [self NextLoginView];
                
            }
            else if([[infoArray objectAtIndex:1] isEqualToString:@"2"])//선택
            {
                if (![self appVersionCheck:[self getAppVersion] :[infoArray objectAtIndex:0]])
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            if ([self.view.subviews containsObject:customCtl.view])
                            {
                                [customCtl.view removeFromSuperview];
                            }
                            customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            customCtl.TitleLabel = UpdataMessage;
                            customCtl.mtype = APPVERSION_UPDATE_chioce;
                            customCtl.confirmLabel = @"확인";
                            customCtl.cancelLabel = @"취소";
                            [self.view addSubview:customCtl.view];
                            
                        });
                    });
                    
                }
                else
                    [self NextLoginView];
            }
            else//무시
            {
                [self NextLoginView];
            }
        }
        else
        [self NextLoginView];
        
    }
}

-(void)NextLoginView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(LogInViewCalling) userInfo:nil repeats:NO];
        });
    });
}

- (void)LogInViewCalling
{
    NSLog(@"LogInViewCalling");
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"id"] != nil &&
           [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"] != nil)
        {
            [self LoginAction];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
            mLoginCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
            [self presentViewController:mLoginCtl animated:NO completion:^{
                [timer invalidate];
                timer = nil;
            }];
        }
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
        mLoginCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInViewController"];
        [self presentViewController:mLoginCtl animated:NO completion:^{
            [timer invalidate];
            timer = nil;
        }];
    }
}

- (void)getTemplateTitleAction
{
    [self TemplateAction:@"getTemplateTitle"];
}

- (void)getTemplateIDAction
{
    [self TemplateAction:@"getTemplateID"];
}

-(void)TemplateAction:(NSString *)CMD
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    
    [param setObject:CMD forKey:@"CMD"];
    [param setObject:[[UIDevice currentDevice] systemName] forKey:@"os_name"];
    
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
    [self reqestSending:SERVER_QueryClient :[ParamString dataUsingEncoding:NSUTF8StringEncoding]];
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
    [param setObject:@"login" forKey:@"CMD"];
    [param setObject:@"N" forKey:@"overwrite"];
    
    
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

- (void)AppServiceAction
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
    
    [param setObject:@"getAppService" forKey:@"CMD"];
    [param setObject:@"iphone" forKey:@"device"];
    [param setObject:[[self appDelegate] localOSlang] forKey:@"os_locale"];
    
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
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"서버와의 통신이 실패 하였습니다."
                                                                    message:@"앱을 다시 시작 해주세요."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"서버와의 통신이 실패 하였습니다."
                                                                message:@"앱을 다시 시작 해주세요."
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
        
#ifdef DEBUG
        NSLog(@"Data = \n%@",[NSString stringWithString:ConvertString]);
#endif
        
        NSDictionary *reponseData = [Json decode:ConvertString];
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9101"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.view.subviews containsObject:customCtl.view])
                    {
                        [customCtl.view removeFromSuperview];
                    }
                    customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    customCtl.TitleLabel = @"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요.";
                    customCtl.mtype = Login_defualt;
                    customCtl.confirmLabel = @"확인";
                    [self.view addSubview:customCtl.view];
                });
            });
        }

        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"login"])
        {
            if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9107"])
            {
//                [PasswordFailLabel setHidden:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pw"];
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9106"])
            {
//                [IDFailLabel setHidden:NO];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"id"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pw"];
            }
            else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9104"])
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
                        customCtl.mtype = Login_Page_move;
                        customCtl.confirmLabel = @"확인";
                        customCtl.cancelLabel = @"취소";
                        [self.view addSubview:customCtl.view];
                        
                    });
                });
                
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [self appDelegate].misLogin = YES;
                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"SMARTID_TYPE"] forKey:@"SMARTID_TYPE"];
                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"USER_TYPE"] forKey:@"USER_TYPE"];
//                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"TEMPLATE_TYPE"] forKey:@"TEMPLATE_TYPE"];
                
                [self AppServiceAction];
            }
            else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
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
                        customCtl.mtype = Login_Page_move;
                        customCtl.confirmLabel = @"확인";
                        [self.view addSubview:customCtl.view];
                        
                    });
                });
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getAppService"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSArray *Data = [reponseData objectForKey:@"DATA"];
                [ServiceDb AllDelete];
                [ServiceDb Transaction:Data];
                
                [timer invalidate];
                timer = nil;
                
                //[[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
                
                
                NSString *agree_key = [NSString stringWithFormat:@"agree_%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                NSString *email_key = [NSString stringWithFormat:@"email_%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
                
                
                NSLog(@"agree_key=%@:%@", agree_key, [[NSUserDefaults standardUserDefaults] objectForKey:agree_key]);
                NSLog(@"email_key=%@:%@", email_key, [[NSUserDefaults standardUserDefaults] objectForKey:email_key]);
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:agree_key] isEqualToString:@"YES"] &&
                    [[[NSUserDefaults standardUserDefaults] objectForKey:email_key] isEqualToString:@"YES"])
                {
                    [[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
                }
                else
                {
                    [self performSelectorOnMainThread:@selector(TermsCtlGoing) withObject:nil waitUntilDone:YES];
                }
                
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getTemplateTitle"] ||
                [[reponseData objectForKey:@"CMD"] isEqualToString:@"getTemplateID"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSDictionary *Data = [reponseData objectForKey:@"DATA"];
                if (Data == nil)
                {
                    [self AppUpDataCheck];
                }
                [[NSUserDefaults standardUserDefaults] setObject:[NSString unescapeAddJavaUrldecode:[Data objectForKey:@"X1"]] forKey:@"X1"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString unescapeAddJavaUrldecode:[Data objectForKey:@"X2"]] forKey:@"X2"];
                
                if ([self getImageFromURL:@"X2"
                                     Type:[Data objectForKey:@"TEMP_TYPE"]
                                    Index:[Data objectForKey:@"TEMP"]])
                {
                    if ([[Data objectForKey:@"TEMP_TYPE"] isEqualToString:@"01"])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[Data objectForKey:@"TEMP"] forKey:@"MainImageType"];
                        bMainImgChange = false;
                        if (bStudentChange)
                        {
                            [self getTemplateIDAction];
                        }
                        else
                            [self AppUpDataCheck];
                    }
                    else if([[Data objectForKey:@"TEMP_TYPE"] isEqualToString:@"02"])
                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[Data objectForKey:@"TEMP"] forKey:@"SudentImageType"];
                        bStudentChange = false;
                        [self AppUpDataCheck];
                    }
                }
                else
                {
                    if ([[Data objectForKey:@"TEMP_TYPE"] isEqualToString:@"01"])
                    {
                        bMainImgChange = false;
                        if (bStudentChange)
                        {
                            [self getTemplateIDAction];
                        }
                        else
                            [self AppUpDataCheck];
                    }
                    else if([[Data objectForKey:@"TEMP_TYPE"] isEqualToString:@"02"])
                    {
                        bStudentChange = false;
                        [self AppUpDataCheck];
                    }
                }
            }
        }
    }
    
}
- (void)TermsCtlGoing
{
    mTermsCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndEmailViewController"];
    [self presentViewController:mTermsCtl animated:NO completion:nil];
}

- (void)LodingAction
{
    FasPushControl *fasCtl = [FasPushControl getSharedInstance];
    [fasCtl initPush:APPCODE urlSubscribe:SERVER_QueryClient urlMessage:SERVER_QueryClientBox fasPushCallback:[[FasPushCallback alloc]init]];
    [fasCtl setCno:[[self appDelegate] getCno]];
    [fasCtl setCustId:[[self appDelegate] getCno]];
    if (![self appDelegate].misSubScribe)
    {
        [fasCtl subscribe];
    }
    [[self appDelegate] setMisSubScribe:true];
    
    
}


#pragma mark - Util
#pragma mark -
#pragma mark UtilMethods

-(NSString *)getAppVersion
{
    NSDictionary *appPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [appPlist objectForKey:@"app_version"];
    NSLog(@"app software version = %@",appVersion);
    
    return appVersion;
}

-(BOOL)appVersionCheck:(NSString *)appVersion :(NSString *)ServerVersion
{
    
    int appVerNumber = [[appVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    int ServerNumber = [[ServerVersion stringByReplacingOccurrencesOfString:@"." withString:@""] intValue];
    
    if ( appVerNumber  < ServerNumber)
    {
        return false;
    }
    
    return true;
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

-(void) TempletChangeCheck :(NSString *)templet_type
{
    
    NSString  *mMainType;
    NSString  *mSudentType;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MainImageType"] == nil)
    {
        mMainType  = @"1";
        [[NSUserDefaults standardUserDefaults]setObject:mMainType forKey:@"MainImageType"];
    }
    else
        mMainType = [[NSUserDefaults standardUserDefaults] objectForKey:@"MainImageType"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SudentImageType"] == nil)
    {
        mSudentType  = @"1";
        [[NSUserDefaults standardUserDefaults]setObject:mSudentType forKey:@"SudentImageType"];
    }
    else
        mSudentType = [[NSUserDefaults standardUserDefaults] objectForKey:@"SudentImageType"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SideMenuTemplet"] == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"SideMenuTemplet"];
    }
    
    NSArray *newArry =  [templet_type componentsSeparatedByString:@"/"];

    
    if([[newArry objectAtIndex:0] intValue] > 0 && ![mMainType isEqualToString:[newArry objectAtIndex:0]] )
    {
        bMainImgChange = TRUE;
    }
    
    if([[newArry objectAtIndex:1] intValue] > 0 && ![mSudentType isEqualToString:[newArry objectAtIndex:1]] )
    {
        bStudentChange = TRUE;
    }
    
    if ([newArry count] == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"SideMenuTemplet"];
    }
    else if (![[newArry objectAtIndex:2]isEqualToString:@"0"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[newArry objectAtIndex:2] forKey:@"SideMenuTemplet"];
    }
    
    if (bMainImgChange)
    {
        [self getTemplateTitleAction];
    }
    else if(bStudentChange)
    {
        [self getTemplateIDAction];
    }
    else
    {
        [self AppUpDataCheck];
    }
//        [self NextLoginView];
    
}

-(BOOL) getImageFromURL:(NSString *)imageKey Type:(NSString *)TempType Index:(NSString *) TempIndex
{
    
    BOOL bState = FALSE;
    
    NSData *imageData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableString *ImageDir = [[NSMutableString alloc] initWithString:documentsDirectory];
    [ImageDir appendString:@"/mobile/"];
    [ImageDir appendFormat:@"%@/",TempIndex];
    [[NSFileManager defaultManager]createDirectoryAtPath:ImageDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    if ([TempType isEqualToString:@"01"])
    {
        if ([imageKey isEqualToString:@"X1"])
        {
            [ImageDir appendString:@"bg_top.png"];
        }
        else
        {
            [ImageDir appendString:@"bg_top@2x.png"];
        }
    }
    else
    {
        if ([imageKey isEqualToString:@"X1"])
        {
            [ImageDir appendString:@"bg_login_id.png"];
        }
        else
        {
            [ImageDir appendString:@"bg_login_id@2x.png"];
        }
    }
    
    NSMutableString *ImageDownloadUrlStr = [[NSMutableString alloc] init];
//    [ImageDownloadUrlStr appendString:SERVER_Query_Path];
    [ImageDownloadUrlStr appendString:[[NSUserDefaults standardUserDefaults] objectForKey:imageKey]];
    imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageDownloadUrlStr]];
    NSLog(@"ImageDownloadUrlStr = %@",ImageDownloadUrlStr);
    if(imageData != nil)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImageDir])
            [[NSFileManager defaultManager] removeItemAtPath:ImageDir error:nil];
        
        if([[NSFileManager defaultManager]createFileAtPath:ImageDir contents:imageData attributes:nil])
            bState = TRUE;
        else
        {
            if([imageData writeToFile:ImageDir atomically:YES])
            bState = TRUE;
            else
            bState = FALSE;
        }
    }
    else
        bState = FALSE;
    

    
    return bState;
}

@end
