//
//  IdentificationCardViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "IdentificationCardViewController.h"
#import "CustomActionSheetViewController.h"
#import "AppDelegate.h"
#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "UIImage+ImageResize.h"
#import "StringEnumDef.h"
#import "EnumDef.h"


#import "NSString+Escape.h"
#import "Json.h"
#import <ZXingObjC/ZXingObjC.h>
#import <QuartzCore/QuartzCore.h>

@interface IdentificationCardViewController ()

@end

@implementation IdentificationCardViewController
@synthesize mCollege,mCreatView,mdescript,mDelete,mdetailView,mIndicater,mName;
@synthesize mSemiView,msmallQR,mtimerNum,mSemiStudenImage,mlargeQRImage,mDetailFixBtn,mSemiFixBtn;
@synthesize mrefreshBtn,mdataView,mBackgroundImageView;

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
        [ImageDir appendFormat:@"/%@/",[[NSUserDefaults standardUserDefaults] objectForKey:@"SudentImageType"]];
        [ImageDir appendString:@"bg_login_id@2x.png"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImageDir])
            [mBackgroundImageView setImage:[UIImage imageWithContentsOfFile:ImageDir]];
        else
            [mBackgroundImageView setImage:[UIImage imageNamed:@"bg_login_id@2x.png"]];
        
    }
    else
        [mBackgroundImageView setImage:[UIImage imageNamed:@"bg_login_id@2x.png"]];
    
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self AllViewinit];
    NSString *mId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    mIdentiUsekey = [NSString stringWithFormat:@"Identifi_Use_%@",mId];
    //switching to Spanish locale. The key used for changing the locale language is 'AppleLanguages'.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowIdentifiView) name:@"IdentificationConfirm" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IdentificationdeleteNotiAction) name:@"IdentificationdeleteAction" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *mId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    mIdentiUsekey = [NSString stringWithFormat:@"Identifi_Use_%@",mId];
    
    [self requestisSmartIdAction];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self StopTimer];
}

-(void)AllViewinit
{
    [mDelete setHidden:YES];
    [mCreatView setHidden:YES];
    [mdetailView setHidden:YES];
    [mSemiView setHidden:YES];
    [mtimerNum setHidden:YES];
    [mIndicater setHidden:YES];
    [mdescript setHidden:YES];
    [mrefreshBtn setHidden:YES];
    [mdataView setHidden:YES];
}

-(void)RoundviewCreate:(UIView *)view
{
    view.layer.cornerRadius = roundf(view.frame.size.width/2.0);
    view.layer.borderWidth = 3;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.masksToBounds = YES;
}

-(void)ShowIdentifiView
{
    [self AllViewinit];
    isTransitioning = false;
    
    if (![mdataView.subviews containsObject:mSemiView])
    {
        [mdataView addSubview:mSemiView];
    }
    if (![mdataView.subviews containsObject:mdetailView])
    {
        [mdataView addSubview:mdetailView];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:mIdentiUsekey];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] == nil ||
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Semi"])
    {
        [mdataView bringSubviewToFront:mSemiView];
        
        [mSemiFixBtn setSelected:YES];
        [mSemiFixBtn setUserInteractionEnabled:NO];
        [mDetailFixBtn setUserInteractionEnabled:YES];
        
        [mSemiView setCenter:CGPointMake(mSemiView.frame.size.width/2, mSemiView.frame.size.height/2) ];
        
        [mSemiView setHidden:NO];
        [mDelete setHidden:NO];
        [mdescript setHidden:NO];
        
        if (TimerCount == 0)
        {
            [self hidenIndicater];
            [mtimerNum setHidden:YES];
            [mrefreshBtn setHidden:NO];
            
        }
        else
        {
            [mtimerNum setHidden:NO];
            [mrefreshBtn setHidden:YES];

        }
    }
    else
    {
        
        [mdataView bringSubviewToFront:mdetailView];
 
        [mDetailFixBtn setSelected:YES];
        [mDetailFixBtn setUserInteractionEnabled:NO];
        [mSemiFixBtn setUserInteractionEnabled:YES];
        
        [mdetailView setCenter:CGPointMake(mdetailView.frame.size.width/2, mdetailView.frame.size.height/2) ];
        
        [mdetailView setHidden:NO];
        [mDelete setHidden:NO];
        [mdescript setHidden:NO];
        
        if (TimerCount == 0)
        {
            [self hidenIndicater];
            [mtimerNum setHidden:YES];
            [mrefreshBtn setHidden:NO];
            
        }
        else
        {
            [mtimerNum setHidden:NO];
            [mrefreshBtn setHidden:YES];
            
        }
    }
    [mdataView setHidden:NO];
}

- (void)TimerStart
{
    TimerCount = 1;
    
    [self ShowIndicater];
    
    [mrefreshBtn setHidden:YES];
    [mtimerNum setHidden:NO];
    
    repeatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(MidInvalidTimer:)
                                   userInfo:nil
                                    repeats:YES];
}


- (void)MidInvalidTimer:(NSTimer *)timer
{
    if (TimerCount == 30)
    {
        [timer invalidate];

        TimerCount = 0;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:mIdentiUsekey] isEqualToString:@"Y"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [mtimerNum setHidden:YES];
                    [self hidenIndicater];
                    [mtimerNum setText:@"30"];
                    [mrefreshBtn setHidden:NO];
                    [mdescript setText:@"새로고침 후 다시 사용해주세요."];
                });
            });
        }
        
    }
    else
    {
        int revserNum = 30 - TimerCount;
        
        if (revserNum >= 10)
        {
            [mtimerNum setText:[NSString stringWithFormat:@"%d",revserNum]];
        }
        else
        {
            [mtimerNum setText:[NSString stringWithFormat:@"%d",revserNum]];
        }
        
        TimerCount++;
    }
}

-(void)StopTimer
{
    if (repeatTimer != nil)
    {
        if ([repeatTimer isValid])
        {
            [repeatTimer invalidate];
            TimerCount = 1;
            [self hidenIndicater];
        }
    }
}


-(void)CreateQRImage:(NSString *)data :(UIImageView *)ImageView
{
    if (data == 0) return;
    
    ZXMultiFormatWriter *writer = [[ZXMultiFormatWriter alloc] init];
    ZXBitMatrix *result = [writer encode:data
                                  format:kBarcodeFormatQRCode
                                   width:ImageView.frame.size.width
                                  height:ImageView.frame.size.height
                                   error:nil];
    
    if (result) {
        ZXImage *image = [ZXImage imageWithMatrix:result];
        ImageView.image = [UIImage imageWithCGImage:image.cgimage];
    } else {
        ImageView.image = nil;
    }
}

- (void)requestisSmartIdAction
{
    [self requestAction:@"isSmartId"];
}

- (void)requestInitSamrtIDAction
{
    [self requestAction:@"getInitSmartID"];
}

- (void)requestSamrtIDAction
{
    [self requestAction:@"getSmartID"];
}

- (void)requestDeleteIDAction
{
    [self requestAction:@"deleteSmartID"];
}

-(void)requestAction:(NSString *)CMD
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
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:CMD forKey:@"CMD"];
    
    [self reqestSending:SERVER_QueryClientBox :[[self BodyDataCreat:param] dataUsingEncoding:NSUTF8StringEncoding]];
}

-(NSString *)BodyDataCreat :(NSDictionary *)param
{
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
    
    return ParamString;
    
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
        
        NSString *mId = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
        mIdentiUsekey = [NSString stringWithFormat:@"Identifi_Use_%@",mId];
        
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = Double_Login_Title;
                    actionSheetViewCtl.mtype = Login_Page_move;
                    actionSheetViewCtl.confirmLabel = @"확인";
                    actionSheetViewCtl.cancelLabel = @"취소";
                    [self.view addSubview:actionSheetViewCtl.view];
                });
            });
            
            return;
        }
        else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = Loss_Login_Title;
                    actionSheetViewCtl.mtype = Login_Page_move;
                    actionSheetViewCtl.confirmLabel = @"확인";
                    [self.view addSubview:actionSheetViewCtl.view];
                });
            });
            
            return;
        }
        else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0201"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = SmartIDNumCreatFail;
                    actionSheetViewCtl.mtype = Login_defualt;
                    actionSheetViewCtl.confirmLabel = @"닫기";
                    [self.view addSubview:actionSheetViewCtl.view];
                });
            });
            
            return;
        }
        else if (![[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = SmartIDCreatFail;
                    actionSheetViewCtl.mtype = Login_defualt;
                    actionSheetViewCtl.confirmLabel = @"닫기";
                    [self.view addSubview:actionSheetViewCtl.view];
                });
            });
            
            return;
        }
        
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"getInitSmartID"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSDictionary *Data =[reponseData objectForKey:@"DATA"];
                
                if (Data == nil)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                            {
                                [actionSheetViewCtl.view removeFromSuperview];
                            }
                            actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            actionSheetViewCtl.TitleLabel = SmartIDCreatFail;
                            actionSheetViewCtl.mtype = Login_defualt;
                            actionSheetViewCtl.confirmLabel = @"닫기";
                            [self.view addSubview:actionSheetViewCtl.view];
                        });
                    });
                    
                    return;
                }
                NSString *mid = [NSString unescapeAddJavaUrldecode: [Data objectForKey:@"ID"]];
                NSString *photo = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"PHOTO"]];
                NSString *name = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"NAME"]];
                NSString *dept = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"DEPT"]];
                NSString *totalInfo = [NSString stringWithFormat:@"%@ | %@",dept,mid];
                NSString *tempQR = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"DATA"]];
                [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:mIdentiUsekey];
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mtimerNum setText:@"30"];

                        [mName setText:name];
                        [mCollege setText:totalInfo];
                        [self CreateQRImage:tempQR :msmallQR];
                        [self CreateQRImage:tempQR :mlargeQRImage];
                        
                        [mdescript setText:@"스마트 ID 사용은 30초 이내에 하셔야 합니다.\n시간이 경과한 경우 새로고침 버튼을 눌러주세요."];
                        [self ShowIdentifiView];
                        [self TimerStart];
                        
                    });
                });
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:photo] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     
                     
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     [mSemiStudenImage setContentMode:UIViewContentModeCenter];
                     if(image){
                         [mSemiStudenImage setContentMode:UIViewContentModeCenter];
                         mSemiStudenImage.image = [image resizedImageWithMaximumSize:mSemiStudenImage.layer.frame.size];
                         [self RoundviewCreate:mSemiStudenImage];
                     }
                     else
                         [mSemiStudenImage setContentMode:UIViewContentModeScaleToFill];
                 }];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getSmartID"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSDictionary *Data =[reponseData objectForKey:@"DATA"];
                
                if (Data == nil)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                            {
                                [actionSheetViewCtl.view removeFromSuperview];
                            }
                            actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            actionSheetViewCtl.TitleLabel = SmartIDCreatFail;
                            actionSheetViewCtl.mtype = Login_defualt;
                            actionSheetViewCtl.confirmLabel = @"닫기";
                            [self.view addSubview:actionSheetViewCtl.view];
                        });
                    });
                    
                    return;
                }
                
                NSString *mid = [NSString unescapeAddJavaUrldecode: [Data objectForKey:@"ID"]];
                NSString *photo = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"PHOTO"]];
                NSString *name = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"NAME"]];
                NSString *dept = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"DEPT"]];
                NSString *totalInfo = [NSString stringWithFormat:@"%@ | %@",dept,mid];
                NSString *tempQR = [NSString unescapeAddJavaUrldecode:[Data objectForKey:@"DATA"]];
                [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:mIdentiUsekey];
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (![mdataView.subviews containsObject:mSemiView])
                        {
                            [mdataView addSubview:mSemiView];
                        }
                        if (![mdataView.subviews containsObject:mdetailView])
                        {
                            
                            [mdataView addSubview:mdetailView];
                        }
                        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] == nil ||
                            [[[NSUserDefaults standardUserDefaults] objectForKey:@"ViewType"] isEqualToString:@"Semi"])
                        {
                            
                            [mSemiView setCenter:CGPointMake(mSemiView.frame.size.width/2, mSemiView.frame.size.height/2) ];
                            [mdataView bringSubviewToFront:mSemiView];
                            [mdataView setHidden:NO];
                            
                            [mSemiFixBtn setSelected:YES];
                            [mSemiFixBtn setUserInteractionEnabled:NO];
                            [mDetailFixBtn setUserInteractionEnabled:YES];
                            
                            [mSemiView setHidden:NO];
                            [mDelete setHidden:NO];
                            [mtimerNum setHidden:NO];
                            
                        }
                        else
                        {
                            [mdetailView setCenter:CGPointMake(mdetailView.frame.size.width/2, mdetailView.frame.size.height/2) ];
                            [mdataView bringSubviewToFront:mdetailView];
                            [mdataView setHidden:NO];
                            
 
                            [mDetailFixBtn setSelected:YES];
                            [mDetailFixBtn setUserInteractionEnabled:NO];
                            [mSemiFixBtn setUserInteractionEnabled:YES];
                            
                            [mdetailView setHidden:NO];
                            [mDelete setHidden:NO];
                            [mtimerNum setHidden:NO];
                            
                        }
                        
                        
                        [mdescript setText:@"스마트 ID 사용은 30초 이내에 하셔야 합니다.\n시간이 경과한 경우 새로고침 버튼을 눌러주세요."];
                        [mName setText:name];
                        [mCollege setText:totalInfo];
                        [self CreateQRImage:tempQR :msmallQR];
                        [self CreateQRImage:tempQR :mlargeQRImage];
                        
                        [self TimerStart];
                        [mdescript setHidden:NO];
                        [mrefreshBtn setHidden:YES];
                    });
                });
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Y" forKey:mIdentiUsekey];
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:photo] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     
                     
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     [mSemiStudenImage setContentMode:UIViewContentModeCenter];
                     if(image){
                         [mSemiStudenImage setContentMode:UIViewContentModeCenter];
                         mSemiStudenImage.image = [image resizedImageWithMaximumSize:mSemiStudenImage.layer.frame.size];
                         [self RoundviewCreate:mSemiStudenImage];
                     }
                     else
                         [mSemiStudenImage setContentMode:UIViewContentModeScaleToFill];
                 }];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"deleteSmartID"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:mIdentiUsekey];
                        [self AllViewinit];
                        [mCreatView setHidden:NO];
                        [self StopTimer];
                    });
                });
                
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"isSmartId"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSDictionary *Data =[reponseData objectForKey:@"DATA"];
                
                if (Data == nil)
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                            {
                                [actionSheetViewCtl.view removeFromSuperview];
                            }
                            actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            actionSheetViewCtl.TitleLabel = SmartIDCreatFail;
                            actionSheetViewCtl.mtype = Login_defualt;
                            actionSheetViewCtl.confirmLabel = @"닫기";
                            [self.view addSubview:actionSheetViewCtl.view];
                        });
                    });
                    
                    return;
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if([[Data objectForKey:@"ISSUE_STATE"] isEqualToString:@"false"])
                        {
                            [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:mIdentiUsekey];
                            [mCreatView setHidden:NO];
                        }
                        else
                        {
                            [self requestSamrtIDAction];
                        }
                    });
                });
            }
        }

        
    }
    
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session  dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if ( !error )
        {
            UIImage *image = [[UIImage alloc] initWithData:data];
            completionBlock(YES,image);
        } else{
            completionBlock(NO,nil);
        }
    }];
    [dataTask resume];
}

-(IBAction)smallQRAction:(id)sender
{
    isTransitioning = true;
    AnimationState = @"Semiflipview";
    [UIView beginAnimations:AnimationState context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:isTransitioning ? UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft forView:mdataView cache:NO];
    [mdataView bringSubviewToFront:mdetailView];
    [mdetailView setCenter:CGPointMake(mdetailView.frame.size.width/2, mdetailView.frame.size.height/2) ];
    [mdetailView setHidden:NO];
    [UIView commitAnimations];
    
    if (isTransitioning)
    {
        isTransitioning = false;
    }
}


-(IBAction)largeQRAction:(id)sender
{
    
    AnimationState = @"Detailflipview";
    [UIView beginAnimations:AnimationState context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition: isTransitioning ? UIViewAnimationTransitionFlipFromRight:UIViewAnimationTransitionFlipFromLeft forView:mdataView cache:NO];
    [mdataView bringSubviewToFront:mSemiView];
    [mSemiView setCenter:CGPointMake(mSemiView.frame.size.width/2, mSemiView.frame.size.height/2) ];
    [mSemiView setHidden:NO];
    [UIView commitAnimations];
    
    if (isTransitioning)
    {

        isTransitioning = false;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)IDCardCreate:(id)sender
{
//    isTransitioning = false;
    [self requestInitSamrtIDAction];
}

-(IBAction)backBtn:(id)sender
{
    
    // Transformation start scale
    self.view.transform = CGAffineTransformMakeTranslation(0.0f, 0.0f);
    
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Grow!
                         self.view.transform = CGAffineTransformMakeTranslation([[UIScreen mainScreen] bounds].size.width, 0.0);
                     }
                     completion:^(BOOL finished){
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"CurrentViewReloadAction" object:nil];
                         [self.view removeFromSuperview];

                     }];
    
//    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)refresh:(id)sender
{
    [self requestSamrtIDAction];
}

-(IBAction)deleteAction:(id)sender
{
    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
    {
        [actionSheetViewCtl.view removeFromSuperview];
    }
    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
    actionSheetViewCtl.TitleLabel = @"학생증을 삭제하시겠습니까?";
    actionSheetViewCtl.mtype  = Login_defualt;
    actionSheetViewCtl.confirmLabel = @"삭제";
    actionSheetViewCtl.cancelLabel=@"취소";
    
    [self.view addSubview:actionSheetViewCtl.view];
    [self.view bringSubviewToFront:actionSheetViewCtl.view ];
}

-(void)IdentificationdeleteNotiAction
{
    [self requestDeleteIDAction];
}


-(IBAction)SemiViewFixBtn:(id)sender
{
    if ([sender isSelected])
    {
        return;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Semi" forKey:@"ViewType"];
        [sender setSelected:YES];
        [mDetailFixBtn setSelected:NO];
        [mSemiFixBtn setUserInteractionEnabled:NO];
        [mDetailFixBtn setUserInteractionEnabled:YES];
    }
    
}

-(IBAction)largeViewFixBtn:(id)sender
{
    if ([sender isSelected])
    {
        return;
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Lagre" forKey:@"ViewType"];
        [sender setSelected:YES];
        [mDetailFixBtn setUserInteractionEnabled:NO];
        [mSemiFixBtn setSelected:NO];
        [mSemiFixBtn setUserInteractionEnabled:YES];
    }
    
}

-(void)ShowIndicater
{
    CAShapeLayer *circle=[CAShapeLayer layer];
    circle.path=[UIBezierPath bezierPathWithArcCenter:CGPointMake(21, 21) radius:23 startAngle:2*M_PI*0-M_PI_2 endAngle:2*M_PI*1-M_PI_2 clockwise:YES].CGPath;
    circle.fillColor=[UIColor clearColor].CGColor;
    circle.strokeColor=[UIColor whiteColor].CGColor;
    circle.lineWidth=6;
    
    
    CAShapeLayer *circle4=[CAShapeLayer layer];
    circle4.path=[UIBezierPath bezierPathWithArcCenter:CGPointMake(21, 21) radius:23 startAngle:2*M_PI*0-M_PI_2 endAngle:2*M_PI*1-M_PI_2 clockwise:YES].CGPath;
    circle4.fillColor=[UIColor clearColor].CGColor;
    circle4.strokeColor=[UIColor colorWithRed:85.0f/255.0f green:138.0f/255.0f blue:229.0f/255.0f alpha:1.0f].CGColor;
    circle4.lineWidth=6;
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration=30;
    animation.removedOnCompletion=NO;
    animation.fromValue=@(1);
    animation.toValue=@(0);
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [circle addAnimation:animation forKey:@"drawCircleAnimation"];
    
    [mIndicater setHidden:NO];
    [mIndicater.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [mIndicater.layer addSublayer:circle4];
    [mIndicater.layer addSublayer:circle];
}

-(void)hidenIndicater
{
    [mIndicater setHidden:YES];
    [mIndicater.layer removeAllAnimations];
    [mIndicater.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
