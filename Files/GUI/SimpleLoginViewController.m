//
//  SimpleLoginViewController.m
//  SmartLauncherSharedCode
//
//  Created by kwangsik.shin on 2014. 11. 4..
//  Copyright (c) 2014년 Arewith. All rights reserved.
//

#import "SimpleLoginViewController.h"
#import "AppDelegate.h"
#import "DataManager.h"

#import "LocationHelper.h"
#import "AESHelper.h"
#import "Common.h"

#import "EnumDef.h"

#import "ServerIndexEnum.h"
#import "StringEnumDef.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "Json.h"

#import "CustomActionSheetViewController.h"

@interface SimpleLoginViewController ()
@property (nonatomic, strong) NSString * urlString;
@property (nonatomic, strong) LocationHelper * helper;
@end

@implementation SimpleLoginViewController

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 위치값을 미리 당김.
    _helper = [LocationHelper sharedLocationHelper];
    
    // 설정
    self.addon = _addon;
//    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    // CFBundleURLSchemes
}

- (void) setAddon:(ServiceInfo *)addon {
    _addon = addon;
    if (_addon && self.isViewLoaded) {
        if (addon.mIcon) {
            _nameImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:addon.mIcon]]];
        }
        
        _nameDetailLabel.text = [NSString stringWithFormat:@"아래의 아이디로 간편하게 로그인하여 %@서비스를 이용 하실수 있습니다.", addon.name];
        _idLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    }
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
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [self ServicStart];
            }
        }

    }
    
}

- (IBAction) tapStart:(id)sender
{
    [self LoginAction];
}

- (void)ServicStart
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * sslUrl;
        if ([_addon.contentType isEqualToString:@"1" ])
        {
            sslUrl = [self makeCONTENT_URL:_addon.contentUrl];
        }
        else if ([_addon.contentType isEqualToString:@"2"])
        {
            sslUrl = [self makeCONTENT_URL:_addon.webContentUrl];
        }
        else if([_addon.contentType isEqualToString:@"3"])
        {
            sslUrl = [self makeCONTENT_URL:_addon.browserContentUrl];
        }
        
        
        // Ryu Edit : gpsEnable 설정할 때만 GPS 읽어오게 수정
        // 테스트용 로그인 버튼으로 보임 어떻게 진입하는지 알 수 없지만 일단 gpsEnable 적용함
        NSString * lat = @"0", *lot = @"0";
        if ([DataManager getInstance].gpsEnable) {
            CLLocationCoordinate2D coor = [_helper getCoordinate];
            if (!(coor.latitude == 0 && coor.longitude == 0)) {
                lat = [NSString stringWithFormat:@"%0.6lf", coor.latitude];
                lot = [NSString stringWithFormat:@"%0.6lf", coor.longitude];
            }
            
        }
        if ([sslUrl rangeOfString:@"?"].location == NSNotFound) {
            sslUrl = [sslUrl stringByAppendingFormat:@"?"];
        }
        else {
            sslUrl = [sslUrl stringByAppendingFormat:@"&"];
        }
        sslUrl = [sslUrl stringByAppendingFormat:@"latitude=%@&longitude=%@&sid=%@&tagType=", lat, lot, _addon.Id];
        
        [Common openURL:sslUrl];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction) tapOutside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)makeCONTENT_URL :(NSString *)contenUrl
{
    NSString *CONTENT_URL = contenUrl;
    
    if (contenUrl != nil && [contenUrl rangeOfString:@":"].location == NSNotFound) {
        BOOL LoginState = [[self appDelegate] misLogin];
        NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
        NSString *mpw = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
        NSString *userType = [[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"];
        
        if (LoginState) {
            CONTENT_URL = [NSString stringWithFormat:@"%@://sso?memberId=%@&memberPw=%@&memberType=%@",
                           contenUrl, mid, [AESHelper aes128EncryptString:mpw], userType];
        }
        else {
            CONTENT_URL = [NSString stringWithFormat:@"%@://", contenUrl];
        }
    }
    return CONTENT_URL;
}

@end
