//
//  SettingViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "SettingViewController.h"
#import "BookmarkSettingViewController.h"
#import "Device.h"
#import "CustomActionSheetViewController.h"

#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "ServerIndexEnum.h"
#import "Json.h"
#import "AppDelegate.h"
#import "StringEnumDef.h"
#import "EnumDef.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize mlogoutId,autologin,notiSetting,version;
@synthesize UpdataView,SmartIDView,VersionView,VersionLine,UpdataBtn;
@synthesize SmartIDversion,SmartIDUpdataView,SmartIDVersionView,SmartIDVersionLine,SmartIDUpdataBtn;
@synthesize PlarsticCard,MobileCard;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SettingLogOutAction) name:@"SettingLogOut" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotiSettingState) name:@"RemoteNotiStateCheck" object:nil];
    
    
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    [mlogoutId setText:mid];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
    {
        [autologin setOn:true];
    }
    else
        [autologin setOn:false];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SMARTID_TYPE"] isEqualToString:@"0"] ||
        [[NSUserDefaults standardUserDefaults] objectForKey:@"SMARTID_TYPE"] == nil)
    {
        [SmartIDView setHidden:YES];
        [VersionView setHidden:NO];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CardState"] == nil ||
             [[[NSUserDefaults standardUserDefaults] objectForKey:@"CardState"] isEqualToString:@"Plarstic"])
        {
            [PlarsticCard setOn:YES animated:YES];
            [MobileCard setOn:NO animated:YES];
        }
        else
        {
            [PlarsticCard setOn:NO animated:YES];
            [MobileCard setOn:YES animated:YES];
        }
        
        [SmartIDView setHidden:NO];
        [VersionView setHidden:YES];
    }
    
    if ([self appVersionCheck:[Device getAppVersion]:[[NSUserDefaults standardUserDefaults] objectForKey:@"Server-VERSION"]])
    {
        [version setText:[Device getAppVersion]];
        [VersionLine setHidden:NO];
        [UpdataView setHidden:NO];
        [UpdataBtn setEnabled:NO];
        [UpdataBtn setTitle:@"최신버전입니다." forState:UIControlStateDisabled];
        
        [SmartIDversion setText:[Device getAppVersion]];
        [SmartIDVersionLine setHidden:NO];
        [SmartIDUpdataView setHidden:NO];
        [SmartIDUpdataBtn setEnabled:NO];
        [SmartIDUpdataBtn setTitle:@"최신버전입니다." forState:UIControlStateDisabled];
    }
    else
    {
        [version setText:[Device getAppVersion]];
        [VersionLine setHidden:NO];
        [UpdataView setHidden:NO];
        [UpdataBtn setEnabled:YES];
        [UpdataBtn setTitle:@"업데이트" forState:UIControlStateNormal];
        
        [SmartIDversion setText:[Device getAppVersion]];
        [SmartIDVersionLine setHidden:NO];
        [SmartIDUpdataView setHidden:NO];
        [SmartIDUpdataBtn setEnabled:YES];
        [SmartIDUpdataBtn setTitle:@"업데이트" forState:UIControlStateNormal];
    }
    
    [self NotiSettingState];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    [mlogoutId setText:mid];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] != nil &&
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLoginState"] isEqualToString:@"true"])
    {
        [autologin setOn:true];
    }
    else
        [autologin setOn:false];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SMARTID_TYPE"] isEqualToString:@"0"])
    {
        [SmartIDView setHidden:YES];
        [VersionView setHidden:NO];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CardState"] == nil ||
            [[[NSUserDefaults standardUserDefaults] objectForKey:@"CardState"] isEqualToString:@"Plarstic"])
        {
            [PlarsticCard setOn:YES];
            [MobileCard setOn:NO];
        }
        else
        {
            [PlarsticCard setOn:NO];
            [MobileCard setOn:YES];
        }
        
        [SmartIDView setHidden:NO];
        [VersionView setHidden:YES];
    }
    
    if ([self appVersionCheck:[Device getAppVersion]:[[NSUserDefaults standardUserDefaults] objectForKey:@"VERSION"]])
    {
        [version setText:[Device getAppVersion]];
        [VersionLine setHidden:NO];
        [UpdataView setHidden:NO];
        [UpdataBtn setEnabled:NO];
        [UpdataBtn setTitle:@"최신버전입니다." forState:UIControlStateDisabled];
        
        [SmartIDversion setText:[Device getAppVersion]];
        [SmartIDVersionLine setHidden:NO];
        [SmartIDUpdataView setHidden:NO];
        [SmartIDUpdataBtn setEnabled:NO];
        [SmartIDUpdataBtn setTitle:@"최신버전입니다." forState:UIControlStateDisabled];
    }
    else
    {
        [version setText:[Device getAppVersion]];
        [VersionLine setHidden:NO];
        [UpdataView setHidden:NO];
        [UpdataBtn setEnabled:YES];
        [UpdataBtn setTitle:@"업데이트" forState:UIControlStateNormal];
        
        [SmartIDversion setText:[Device getAppVersion]];
        [SmartIDVersionLine setHidden:NO];
        [SmartIDUpdataView setHidden:NO];
        [SmartIDUpdataBtn setEnabled:YES];
        [SmartIDUpdataBtn setTitle:@"업데이트" forState:UIControlStateNormal];
    }
    
    [self NotiSettingState];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)NotiSettingState
{
    [notiSetting setEnabled:NO];
    if ([self isNotificationsEnabled])
    {
        [notiSetting setOn:YES];
    }
    else
    {
        [notiSetting setOn:NO];
    }
}

- (BOOL) isNotificationsEnabled
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (!noticationSettings || (noticationSettings.types == UIUserNotificationTypeNone)) {
            return NO;
        }
        return YES;
    }
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    if (types & UIRemoteNotificationTypeAlert){
        return YES;
    } else{
        return NO;
    }
}

-(IBAction)BookmarkSetting:(id)sender;
{
    bookmarkSettingCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"BookmarkSettingViewController"];
    [self presentViewController:bookmarkSettingCtl animated:YES completion:nil];
}
-(IBAction)logoutMenu:(id)sender
{
    if ([self.view.subviews containsObject:customCtl.view])
    {
        [customCtl.view removeFromSuperview];
    }
    customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
    customCtl.TitleLabel = @"로그아웃 하시겠습니까?";
    customCtl.mtype = Login_defualt;
    customCtl.confirmLabel = @"로그아웃";
    customCtl.cancelLabel = @"취소";
    [self.view addSubview:customCtl.view];
}


-(IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)PlarsticCardSetting:(id)sender
{
    if ([sender isOn])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SMART_CARD_TYPE"];
        [MobileCard setOn:NO];
        [PlarsticCard setOn:YES];
        [self SmartCardSettingAction:@"1"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SMART_CARD_TYPE"];
        [MobileCard setOn:YES ];
        [PlarsticCard setOn:NO];
        [self SmartCardSettingAction:@"2"];
    }
}

-(IBAction)MobileCardSetting:(id)sender
{
    if ([sender isOn])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SMART_CARD_TYPE"];
        [PlarsticCard setOn:NO animated:YES];
        [MobileCard setOn:YES animated:YES];
        [self SmartCardSettingAction:@"2"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SMART_CARD_TYPE"];
        [PlarsticCard setOn:YES animated:YES];
        [MobileCard setOn:NO animated:YES];
        [self SmartCardSettingAction:@"1"];
    }
}

-(IBAction)AutoLoginSetting:(id)sender
{
    if ([sender isOn])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"autoLoginState"];
    }
    else
    {
         [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
    }
}

-(IBAction)NotiSetting:(id)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            if ([self.view.subviews containsObject:customCtl.view])
            {
                [customCtl.view removeFromSuperview];
            }
            customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
            customCtl.TitleLabel = NotiSettingAlert;
            customCtl.mtype = Login_defualt;
            customCtl.confirmLabel = @"닫기";
            [self.view addSubview:customCtl.view];
        });
    });
}


- (void)SettingLogOutAction
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
    [param setObject:@"Logout" forKey:@"CMD"];
    
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

- (void)SmartCardSettingAction:(NSString *)value
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
    [param setObject:@"setCardType" forKey:@"CMD"];
    [param setObject:value forKey:@"card_type"];
    
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
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"Logout"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewChange" object:nil];
                
                [[self appDelegate] setMisLogin:NO];
                [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }
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

@end
