//
//  LogInViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "LogInViewController.h"
#import "AppDelegate.h"
#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "EnumDef.h"

#import "ServiceDb.h"
#import "Json.h"
#import "StringEnumDef.h"
#import "ServiceInfo.h"
#import "TermsAndEmailViewController.h"
#import "HomeViewController.h"
#import "WebViewController.h"
#import "NSString+Escape.h"
#import "CustomActionSheetViewController.h"

@interface LogInViewController ()
{
    UIViewController *IndicationCtl;
}
@end

@implementation LogInViewController
@synthesize IDFailLabel,IDTextFild,PasswordFailLabel,PasswordTextFild,AutoLoginCheckBox;
@synthesize mIsOverwrite,IDFailImage,PasswordFailImage;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *IDpaddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5,0)];
    UIView *PWpaddingTxtfieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5,0)];
    IDTextFild.delegate = self;
    IDTextFild.leftView = IDpaddingTxtfieldView;
    IDTextFild.leftViewMode = UITextFieldViewModeAlways;
    PasswordTextFild.delegate = self;
    PasswordTextFild.leftView = PWpaddingTxtfieldView;
    PasswordTextFild.leftViewMode = UITextFieldViewModeAlways;
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"es", nil] forKey:@"AppleLanguages"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OverWriteLogin) name:@"OverWriteLogin" object:nil];
    
    [IDTextFild setPlaceholder:@" ID"];
    [PasswordTextFild setPlaceholder:@" Password"];
}

-(void)OverWriteLogin
{
    mIsOverwrite= true;
    [self LoginAction];
    mIsOverwrite = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 리턴 키를 누를 때 실행
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)AutoLoginStateCheck:(id)sender
{
    if ([sender isSelected])
    {
        NSLog(@"isNormal");
        [sender setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateHighlighted];
        [sender setSelected:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
    }
    else
    {
        NSLog(@"isSelected");
        [sender setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateHighlighted];
        [sender setSelected:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"autoLoginState"];
    }
}

-(IBAction)LoginBtn:(id)sender
{
    if([IDTextFild.text length] <= 0 || [IDTextFild.text isEqualToString:@" "])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 이 블럭은 위 작업이 완료되면 호출된다.
                [IDFailLabel setHidden:NO];
                [IDFailImage setHidden:NO];
                [IDFailLabel setText:@"아이디를 입력해주세요."];
                [PasswordFailLabel setHidden:YES];
                [PasswordFailImage setHidden:YES];
            });
        });
        return;
    }
    
    if([PasswordTextFild.text length] <= 0 || [PasswordTextFild.text isEqualToString:@" "])
    {
        NSLog(@"Password가 비어 있습니다. 작성 해주세요.");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 이 블럭은 위 작업이 완료되면 호출된다.
                [IDFailLabel setHidden:YES];
                [IDFailImage setHidden:YES];
                [PasswordFailLabel setHidden:NO];
                [PasswordFailImage setHidden:NO];
                [PasswordFailLabel setText:@"비밀번호를 입력해주세요."];
                
            });
        });
        return;
    }
    [self AddIndicationCtl];
    [self LoginAction];
    
    if ([IDTextFild isEditing])
    {
        [IDTextFild resignFirstResponder];
    }
    else if ([PasswordTextFild isEditing])
    {
        [PasswordTextFild resignFirstResponder];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([IDTextFild isEditing])
    {
        [IDTextFild resignFirstResponder];
    }
    else if ([PasswordTextFild isEditing])
    {
        [PasswordTextFild resignFirstResponder];
    }
    
}

-(void)AddIndicationCtl
{
    IndicationCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"InticationView"];
    [self.view addSubview: IndicationCtl.view];
}


- (void)LoginAction
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    

    plainID  = [IDTextFild text];
    base64ID = [plainID base64EncodedString];
        
    plainPW  = [PasswordTextFild text];
    base64PW =[plainPW base64EncodedString];
    
    
    if ([plainID isEqualToString:@""] || [base64PW isEqualToString:@""])
    {
        return;
    }
    
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:@"login" forKey:@"CMD"];
    
    if ([AutoLoginCheckBox isSelected])
    {
        [param setObject:@"true" forKey:@"auto"];
        [[NSUserDefaults standardUserDefaults] setObject:@"true" forKey:@"autoLoginState"];
    }
    else
    {
        [param setObject:@"false" forKey:@"auto"];
        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
    }
    
    
    if (mIsOverwrite)
    {
        [param setObject:@"Y" forKey:@"overwrite"];
    }
    else
    {
        [param setObject:@"N" forKey:@"overwrite"];
    }
    
    
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
                [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Communication Error"
                                                                            message:@"We received error from server."
                                                                           delegate:self
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        [IndicationCtl.view removeFromSuperview];
                    });
                });

            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Server Not Connectable"
                                                                        message:@"We do not connect to the server."
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [IndicationCtl.view removeFromSuperview];
                });
            });
        }
    }];
    [uploadTask resume];
}

- (void)processResponse:(NSData *)aData
{
    NSLog(@"processResponse ");
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
                    [IndicationCtl.view removeFromSuperview];
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = @"단말 등록에 문제가 있습니다. 앱을 다시 시작하세요.";
                    actionSheetViewCtl.mtype = Login_defualt;
                    actionSheetViewCtl.confirmLabel = @"확인";
                    [self.view addSubview:actionSheetViewCtl.view];
                    [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                });
            });
        }
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"login"])
        {
            if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9107"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IDFailLabel setHidden:YES];
                        [IDFailImage setHidden:YES];
                        [PasswordFailLabel setText:@"비밀번호를 확인 후 다시 입력하세요."];
                        [PasswordFailLabel setHidden:NO];
                        [PasswordFailImage setHidden:NO];
                        [IndicationCtl.view removeFromSuperview];
                        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                        
                    });
                });
                
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9106"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [PasswordFailImage setHidden:YES];
                        [PasswordFailLabel setHidden:YES];
                        [IDFailLabel setText:@"구성원이 아닙니다."];
                        [IDFailImage setHidden:NO];
                        [IDFailLabel setHidden:NO];
                        [IndicationCtl.view removeFromSuperview];
                        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                    });
                });
                
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9104"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IndicationCtl.view removeFromSuperview];
                        if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                        {
                            [actionSheetViewCtl.view removeFromSuperview];
                        }
                        [[NSUserDefaults standardUserDefaults] setObject:@"false" forKey:@"autoLoginState"];
                        actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                        actionSheetViewCtl.TitleLabel = Double_Login_Title;
                        actionSheetViewCtl.mtype = Login_Retry;
                        actionSheetViewCtl.confirmLabel = @"확인";
                        actionSheetViewCtl.cancelLabel = @"취소";
                        [self.view addSubview:actionSheetViewCtl.view];
                    });
                });
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IDFailLabel setHidden:YES];
                        [IDFailImage setHidden:YES];
                        [PasswordFailLabel setHidden:YES];
                        [PasswordFailImage setHidden:YES];
                    });
                });

                
                [[NSUserDefaults standardUserDefaults] setObject:[IDTextFild text] forKey:@"id"];
                [[NSUserDefaults standardUserDefaults] setObject:[PasswordTextFild text] forKey:@"pw"];
                [[NSUserDefaults standardUserDefaults] setObject:[[IDTextFild text] base64EncodedString] forKey:@"base64id"];
                [[NSUserDefaults standardUserDefaults] setObject:[[PasswordTextFild text] base64EncodedString]forKey:@"base64pw"];

                
                //Setting 플라스틱 카드 변수
                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"SMARTID_TYPE"] forKey:@"SMARTID_TYPE"];
                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"USER_TYPE"] forKey:@"USER_TYPE"];
//                [[NSUserDefaults standardUserDefaults] setObject:[reponseData objectForKey:@"TEMPLATE_TYPE"] forKey:@"TEMPLATE_TYPE"];
                
                NSString *agree_key = [NSString stringWithFormat:@"agree_%@",[IDTextFild text]];
                NSString *email_key = [NSString stringWithFormat:@"email_%@",[IDTextFild text]];
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:agree_key] == nil)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:agree_key];
                }
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:email_key] == nil)
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:email_key];
                }
                
                [[self appDelegate] setMisLogin:YES];
                if ([[self appDelegate] mSimpleLogin])
                {
                    [[self appDelegate] openSimpleLoginViewController];
                }
                else
                    [self AppServiceAction];
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
            {
                [self OverWriteLogin];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getAppService"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSArray *Data = [reponseData objectForKey:@"DATA"];
                [ServiceDb AllDelete];
                [ServiceDb Transaction:Data];
                
                
                //[[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
                NSString *agree_key = [NSString stringWithFormat:@"agree_%@",[IDTextFild text]];
                NSString *email_key = [NSString stringWithFormat:@"email_%@",[IDTextFild text]];
                
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
                
                [IndicationCtl.view removeFromSuperview];
            }
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 이 블럭은 위 작업이 완료되면 호출된다.
                    [IndicationCtl.view removeFromSuperview];
                    if ([self.view.subviews containsObject:actionSheetViewCtl.view])
                    {
                        [actionSheetViewCtl.view removeFromSuperview];
                    }
                    actionSheetViewCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    actionSheetViewCtl.TitleLabel = @"서버와의 통신이 실패 하였습니다.";
                    actionSheetViewCtl.mtype = Login_defualt;
                    actionSheetViewCtl.confirmLabel = @"확인";
                    [self.view addSubview:actionSheetViewCtl.view];
                });
            });
        }
        
    }
}
- (void)TermsCtlGoing
{
    mTermsCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"TermsAndEmailViewController"];
    [self presentViewController:mTermsCtl animated:NO completion:nil];
}

- (IBAction)openUseInformation:(id)sender {
    WebViewController *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
    [wb LoadwebView:USE_INFORMATION_URL];
    [self appDelegate].webViewCtl = wb;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:wb animated:YES completion:nil];
        });
    });
    
}
- (IBAction)openFindPassword:(id)sender {
    WebViewController *wb = [self.storyboard instantiateViewControllerWithIdentifier:@"P_WEBVIEW"];
    [wb LoadwebView:FIND_PASSWORD_URL];
    [self appDelegate].webViewCtl = wb;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:wb animated:YES completion:nil];
        });
    });
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
