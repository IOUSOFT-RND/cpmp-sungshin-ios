//
//  QRCodeReaderViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 5. 26..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "QRCodeReaderViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <ZXingObjC/ZXingObjC.h>

#import "ServerIndexEnum.h"
#import "StringEnumDef.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "Json.h"
#import "EnumDef.h"
#import "StringEnumDef.h"
#import "CustomActionSheetViewController.h"


@interface QRCodeReaderViewController ()
{
    id<ZXingDelegate> delegate;
    UIViewController *IndicationCtl;
}

@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, weak) IBOutlet UIView *titleView;
@property (nonatomic, weak) IBOutlet UIView *scanRectView;
@property (nonatomic, assign) id<ZXingDelegate> Zxingdelegate;

@end

@implementation QRCodeReaderViewController
@synthesize bResult,titleView,scanRectView;

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
    [super viewWillAppear:animated];
    [self AddIndicationCtl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)AddIndicationCtl
{
    IndicationCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"InticationView"];
    [self.view addSubview: IndicationCtl.view];
    [self LoginAction];
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
                
//                [IndicationCtl.view performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 이 블럭은 위 작업이 완료되면 호출된다.
                        [IndicationCtl.view removeFromSuperview];
                        bResult = false;
                        if (self.capture == nil )
                        {
                            self.capture = [[ZXCapture alloc] init];
                            self.capture.camera = self.capture.back;
                            self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
                            self.capture.rotation = 90.0f;
                            
                            self.capture.layer.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20.0f);
                        }
                        
                        self.capture.delegate = self;
                        self.capture.layer.frame = self.view.bounds;
                        CGAffineTransform captureSizeTransform = CGAffineTransformMake(0, 0, 0, 0, 0, 0);
                        
                        
                        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                        {
                            if ([[UIScreen mainScreen] bounds].size.height == 568.0)
                            {
                                captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 568 / self.view.frame.size.height);
                            }
                            else if([[UIScreen mainScreen] bounds].size.height == 480.0)
                            {
                                captureSizeTransform = CGAffineTransformMakeScale(320 / self.view.frame.size.width, 480 / self.view.frame.size.height);
                            }
                            else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
                            {
                                captureSizeTransform = CGAffineTransformMakeScale(375 / self.view.frame.size.width, 667 / self.view.frame.size.height);
                            }
                            else
                            {
                                captureSizeTransform = CGAffineTransformMakeScale(414 / self.view.frame.size.width, 736 / self.view.frame.size.height);
                            }
                        }
                        
                        self.capture.scanRect = CGRectApplyAffineTransform(self.scanRectView.frame, captureSizeTransform);
                        
                        if (!self.capture.running)
                        {
                            [self.view.layer performSelectorOnMainThread:@selector(addSublayer:) withObject:self.capture.layer waitUntilDone:YES];
                            [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.scanRectView waitUntilDone:YES];
                            [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.titleView waitUntilDone:YES];
                            [self.capture start];
                        }
                        
                        if (![[self.view subviews] containsObject:(UIView *)self.capture.layer])
                        {
                            [self.view.layer addSublayer:self.capture.layer];
                            [self.view bringSubviewToFront:self.scanRectView];
                            [self.view bringSubviewToFront:self.titleView];
//                            [self.view.layer performSelectorOnMainThread:@selector(addSublayer:) withObject:self.capture.layer waitUntilDone:YES];
//                            [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.scanRectView waitUntilDone:YES];
//                            [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.titleView waitUntilDone:YES];
                        }
                        
                        if (![self canUseCamera])
                        {
                            if ([self.view.subviews containsObject:customCtl.view])
                            {
                                [customCtl.view removeFromSuperview];
                            }
                            customCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomActionSheetViewController"];
                            customCtl.TitleLabel = @"카메라 접근을 허용 후 사용할 수 있습니다.";
                            customCtl.mtype = Login_defualt;
                            customCtl.confirmLabel = @"확인";
                            [self.view addSubview:customCtl.view];
                        }

                    });
                });
                
                
            }
        }
    }
    
}


- (BOOL)canUseCamera
{
    NSLog(@"[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]: %d", (int)[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        return NO;
    }else{
        return YES;
    }
    
}

- (void)captureInit
{
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
  
    self.capture.layer.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20.0f);
    
    NSLog(@"Camera  = %d",self.capture.captureDevice.isConnected);
    
    [self.view.layer performSelectorOnMainThread:@selector(addSublayer:) withObject:self.capture.layer waitUntilDone:YES];
    [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.scanRectView waitUntilDone:YES];
    [self.view performSelectorOnMainThread:@selector(bringSubviewToFront:) withObject:self.titleView waitUntilDone:YES];
}


- (void)setZingDelegate:(id<ZXingDelegate>)mdelegate
{
    self.Zxingdelegate=mdelegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

-(IBAction)Cancel:(id)sender
{
    [self.Zxingdelegate zxingControllerDidCancel:self];
    [self.capture stop];
}

- (void)vibrate
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory: AVAudioSessionCategoryPlayback  error:&err];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    if (bResult) return;
    
    //    We got a result. Display information about the result onscreen.
    //    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    //    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString,result.text ];
    // Vibrate
    bResult = true;
    
    [self.Zxingdelegate zxingController:self didScanResult:result.text];
    [capture stop];
    [self vibrate];
}

- (void)captureCameraIsReady:(ZXCapture *)capture
{
    NSLog(@"Camaer %i", capture.captureDevice.isConnected);
}

@end
