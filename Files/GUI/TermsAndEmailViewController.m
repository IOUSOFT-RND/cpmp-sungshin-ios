//
//  TermsAndEmailViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 10..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "TermsAndEmailViewController.h"
#import "AppDelegate.h"
#import "HomeViewController.h"

#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "EnumDef.h"

#import "ServiceDb.h"
#import "Json.h"
#import "StringEnumDef.h"
#import "CustomActionSheetViewController.h"

@interface TermsAndEmailViewController ()

@end

@implementation TermsAndEmailViewController

@synthesize EmailTextFild,termsAgreeCheckBox1,termsAgreeCheckBox2,AgreeBtn;
@synthesize termsAgreeView,NextBtnView;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [termsAgreeView setHidden:YES];
//    [NextBtnView setHidden:NO];
    
    
//    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"agree_%@",mid]] isEqualToString:@"YES"])
//    {
//        [termsAgreeView setHidden:YES];
//        [NextBtnView setHidden:NO];
//    }
//    else
//    {
//        [AgreeBtn setBackgroundColor:[UIColor lightGrayColor]];
//        [termsAgreeView setHidden:NO];
//        [NextBtnView setHidden:YES];
//    }
    
    [AgreeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [AgreeBtn setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([EmailTextFild isEditing])
    {
        [EmailTextFild resignFirstResponder];
    }
    
}

// 리턴 키를 누를 때 실행
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)back:(id)sender
{
    exit(0);
}

- (IBAction)termsAgreeCheck1:(id)sender
{
    if ([sender isSelected])
    {
        NSLog(@"isNormal");
        [sender setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateHighlighted];
        [sender setSelected:NO];
        [AgreeBtn setBackgroundColor:[UIColor lightGrayColor]];
        [AgreeBtn setEnabled:NO];
    }
    else
    {
        NSLog(@"isSelected");
        [sender setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateHighlighted];
        [sender setSelected:YES];
        if ([termsAgreeCheckBox2 isSelected])
        {
             [AgreeBtn setBackgroundColor:[UIColor colorWithRed:137.0f/255.0f green:177.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
             [AgreeBtn setEnabled:YES];
        }
    }
}

- (IBAction)termsAgreeCheck2:(id)sender
{
    if ([sender isSelected])
    {
        NSLog(@"isNormal");
        [sender setImage:[UIImage imageNamed:@"check_round_on.png"] forState:UIControlStateHighlighted];
        [sender setSelected:NO];
        [AgreeBtn setBackgroundColor:[UIColor lightGrayColor]];
        [AgreeBtn setEnabled:NO];
    }
    else
    {
        NSLog(@"isSelected");
        [sender setImage:[UIImage imageNamed:@"check_round_off.png"] forState:UIControlStateHighlighted];
        [sender setSelected:YES];
        if ([termsAgreeCheckBox1 isSelected])
        {
            [AgreeBtn setBackgroundColor:[UIColor colorWithRed:137.0f/255.0f green:177.0f/255.0f blue:195.0f/255.0f alpha:1.0f]];
            [AgreeBtn setEnabled:YES];
        }
    }
}

- (IBAction)AgressBtn:(id)sender
{
    NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"agree_%@",mid]];
    
    if ([self EmailTextFileCheck])
    {
        [self EmailAction:EmailTextFild.text];
    }
    else
    {
        [[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
    }
}

- (BOOL)EmailTextFileCheck
{
    if ([EmailTextFild text].length == 0 ||
        [[EmailTextFild text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0)
        return NO;
    
//    if ([[EmailTextFild text] rangeOfString:@"@"].location ==NSNotFound)
//        return NO;
    
    return YES;
}

- (IBAction)EmailConfirm:(id)sender
{
    if ([self EmailTextFileCheck])
    {
        if ([EmailTextFild isEditing])
        {
            [EmailTextFild resignFirstResponder];
        }
        
        [self EmailAction:EmailTextFild.text];
        
    }
    else if(EmailTextFild.text.length == 0)
    {
        if ([EmailTextFild isEditing])
        {
            [EmailTextFild resignFirstResponder];
        }
        
        [[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
    }
//    else
//    {
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 이 블럭은 위 작업이 완료되면 호출된다.
//                customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
//                customCtl.TitleLabel = @"Email을 다시 입력해주세요.";
//                customCtl.mtype = Login_defualt;
//                customCtl.confirmLabel = @"확인";
//                [self.view addSubview:customCtl.view];
//            });
//        });
//    }
}

- (void)EmailAction:(NSString *)Email
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    
    
    plainID  = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    base64ID = [plainID base64EncodedString];
    
    plainPW  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
    base64PW = [plainPW base64EncodedString];
    
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:@"email" forKey:@"CMD"];
    
    [param setObject:Email forKey:@"email"];
    
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
                    customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                    customCtl.TitleLabel = Loss_Login_Title;
                    customCtl.mtype = Login_Page_move;
                    customCtl.confirmLabel = @"확인";
                    [self.view addSubview:customCtl.view];
                });
            });
            
            return;
        }
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"email"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                NSString *mid = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:[NSString stringWithFormat:@"email_%@",mid]];
                [[self appDelegate] performSelectorOnMainThread:@selector(windowRootViewChange) withObject:nil waitUntilDone:YES];
            }
            else
            {
                UIAlertView *failalert= [[UIAlertView alloc] initWithTitle:@"알림"
                                                                   message:@"Email등록이 실패하였습니다. 다시 시도해주세요."
                                                                  delegate:self
                                                         cancelButtonTitle:@"확인"
                                                         otherButtonTitles:nil];
                [failalert show];
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
