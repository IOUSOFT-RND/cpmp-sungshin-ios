//
//  TotalServiceViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 9..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "TotalServiceViewController.h"
#import "CustomActionSheetViewController.h"
#import "ServiceDb.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "AESHelper.h"
#import "Common.h"
#import "UserData.h"
#import "LogHelper.h"
#import "EnumDef.h"

#import "ServerIndexEnum.h"
#import "StringEnumDef.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "Json.h"

@interface TotalServiceViewController ()
{
    ServiceInfo *SeletItem;
    UIViewController *IndicationCtl;
}

@end

@implementation TotalServiceViewController
@synthesize mlistView;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewItem = [[NSMutableArray alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [ViewItem setArray:[ServiceDb getMenuAll]];
    [mlistView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendIConWebview:(NSDictionary *)Info
{
    
    NSString *stringURL = [Info objectForKey:@"URL"];
    
    WebViewController *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
    [wb LoadwebView:stringURL];
    [wb setService:[Info objectForKey:@"service"]];
    [self appDelegate].webViewCtl = wb;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:wb animated:YES completion:nil];
        });
    });
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
            if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9101"])
            {
                [IndicationCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                if ([self.view.subviews containsObject:customCtl.view])
                {
                    [customCtl.view removeFromSuperview];
                }
                customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                customCtl.TitleLabel = @"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요.";
                customCtl.mtype = Login_defualt;
                customCtl.confirmLabel = @"확인";
                [self.view addSubview:customCtl.view];
            }
            else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IndicationCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
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
            else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IndicationCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
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
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                
                [IndicationCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                [self ServiceExc];
            }
        }
    }
}

-(void)AddIndicationCtl
{
    IndicationCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"InticationView"];
    [self.view addSubview: IndicationCtl.view];
    [self LoginAction];
}

-(void)ServiceExc
{
    if (SeletItem == nil)
        return;
    
    ServiceInfo *info = SeletItem;
    
    [[UserData sharedUserData] setUSER_ID:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
    [[UserData sharedUserData] setUSER_PASS:[[NSUserDefaults standardUserDefaults] objectForKey:@"pw"]];
    [[UserData sharedUserData] setUSER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"]];
    
    NSString * newUrl;
    if ([info.contentType isEqualToString:@"2"])
    {
        
        if (info.construction == nil|| [info.construction isEqualToString:@""])
        {
            NSString *makeUrl = [self makeCONTENT_URL:info.webContentUrl];
            newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        }
        else
        {
            newUrl = info.construction;
        }
        [self sendIConWebview:[[NSDictionary alloc] initWithObjectsAndKeys:newUrl,@"URL",info,@"service", nil]];

        //웹뷰실행
    }
    else if ([info.contentType isEqualToString:@"1"])
    {
        if (info.construction == nil|| [info.construction isEqualToString:@""])
        {
            NSString *makeUrl = [self makeCONTENT_URL:info.contentUrl];
            newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
            NSLog(@"URL =  %@",newUrl);
            if (![Common openURL:newUrl])
            {
                [Common openURL:info.storeUrl];
            }
        }
        else
        {
            newUrl = info.construction;
            [self sendIConWebview:[[NSDictionary alloc] initWithObjectsAndKeys:newUrl,@"URL",info,@"service", nil]];
        }

    }
    else if ([info.contentType isEqualToString:@"3"])
    {
        //사파리실행
        if (info.construction == nil|| [info.construction isEqualToString:@""])
        {
            NSString *makeUrl = [self makeCONTENT_URL:info.browserContentUrl];
            newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
            [Common openURL:newUrl];
        }
        else
        {
            newUrl = info.construction;
            [self sendIConWebview:[[NSDictionary alloc] initWithObjectsAndKeys:newUrl,@"URL",info,@"service", nil]];
        }
    }
    else
    {
        NSString *makeUrl = [self makeCONTENT_URL:info.contentUrl];
        newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        //외부 실행
        [Common openURL:newUrl];
    }
    [LogHelper loggingForMenuRun:info];
    
    SeletItem = nil;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ViewItem count];
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 재사용 큐에 셀을 가져온다
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TotalserviceCell" forIndexPath:indexPath];
    ServiceInfo *info = [ViewItem objectAtIndex:indexPath.row];
    
    // 표시할 이미지 설정
    UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
    if (imgView)
    {
        NSURL *url = [NSURL URLWithString:[info.mIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        imgView.image = image;
    }
    
    UILabel* LabelView = (UILabel*)[cell.contentView viewWithTag:11];
    [LabelView setTextColor:[UIColor whiteColor]];
    LabelView.text = info.name;

    
    return cell;
}

//====================================================================================================//
#pragma mark - UICollectionViewDelegate

// 선택
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return YES;
//}

//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeletItem = [ViewItem objectAtIndex:indexPath.row];
    [self AddIndicationCtl];
}




// 셀이 삭제되거나 보이지 않는 영역으로 이동했을때
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
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
