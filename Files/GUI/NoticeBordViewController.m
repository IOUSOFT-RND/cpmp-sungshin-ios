//
//  NoticeBordViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 13..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "NoticeBordViewController.h"
#import "AppDelegate.h"

#import "NSString+Escape.h"
#import "XTime.h"
#import "StringEnumDef.h"
#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "Json.h"
#import "CustomActionSheetViewController.h"
#import "EnumDef.h"

@interface NoticeBordViewController ()
{
    UIViewController *IndicationCtl;
}
@end

@implementation NoticeBordViewController
@synthesize mNoticWeb;


- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (mTableData == nil)
    {
        mTableData = [[NSMutableArray alloc] init];
        mSeleteData = [[NSMutableArray alloc] init];
    }
    mNoticWeb.delegate = self;

    [self GetNoticeAction];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)GetNoticeAction
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


-(void)AddIndicationCtl
{
    IndicationCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"InticationView"];
    [self.view addSubview: IndicationCtl.view];
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
//
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
        NSDictionary *reponseData = [Json decode:[NSString stringWithString:ConvertString]];
        
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
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
            
            return;
        }
        
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
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
            
            return;
        }
        
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"islogin"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
                NSString *url = [NSString stringWithFormat:@"%@getBoardBox.do?id=%@",SERVER_Query_Path,[mid base64EncodedString]];
                [mNoticWeb performSelectorOnMainThread: @selector(loadRequest:)
                                            withObject: [[NSURLRequest alloc]initWithURL:[[NSURL alloc] initWithString:url]]
                                         waitUntilDone: NO];
            }
        }
    }
    
}

#pragma mark - webview
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"Start Log");
    [self AddIndicationCtl];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Finish Log");
    [IndicationCtl.view removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Fail Log %@",error);
    
    if (error.code != -999) {
        [IndicationCtl.view removeFromSuperview];
        if ([self.view.subviews containsObject:customCtl.view])
        {
            [customCtl.view removeFromSuperview];
        }
        customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
        customCtl.TitleLabel = @"서버에서 응답이 없습니다. 다시 시도해 주세요.";
        customCtl.mtype = Login_defualt;
        customCtl.confirmLabel = @"확인";
        [self.view addSubview:customCtl.view];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(IBAction)openBtnAction:(id)sender
//{
//    UIButton *button = (UIButton *)sender;
//    
//    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
//    if ([[ver objectAtIndex:0] intValue] >= 7) {
//        UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
//        NSIndexPath *path=[self.mNoticeTable indexPathForCell:cell];
//        if (button.isSelected)
//        {
//            [button setSelected:NO];
//            [mSeleteData removeObject:path];
//            
//        }
//        else
//        {
//            [button setSelected:YES];
//            [mSeleteData addObject:path];
//        }
//        [self.mNoticeTable reloadData];
//        
//    }
//    else
//    {
//        UITableViewCell *cell=(UITableViewCell*)[sender superview];
//        NSIndexPath *path=[self.mNoticeTable indexPathForCell:cell];
//        
//        if (button.isSelected)
//        {
//            [button setSelected:NO];
//            [mSeleteData removeObject:path];
//            
//        }
//        else
//        {
//            [button setSelected:YES];
//            [mSeleteData addObject:path];
//        }
//        [self.mNoticeTable reloadData];
//    }
//}

-(NSString *)setWebViewloadHtml:(NSString *)url
{
    NSString *headerString = @"<head><style>img{max-width:100%; width:auto; height:auto;}</style></head>";
    return [NSString stringWithFormat:@"<html>%@<body>%@</body></html>",headerString,url];
}

@end
