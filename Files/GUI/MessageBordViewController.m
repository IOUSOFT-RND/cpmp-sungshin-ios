//
//  MessageBordViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 13..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageBordViewController.h"
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
#import "MessageBordTableViewCell.h"
#import "ImageScaleViewController.h"

@interface MessageBordViewController ()
{
    NSMutableArray *playAVPlist;
}
@end

@implementation MessageBordViewController
@synthesize mMessageTable;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ImageScaleCtl = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageScaleViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage) name:@"NotificationEnter" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (mTableData == nil)
    {
        mImageDic = [[NSMutableDictionary alloc] init];
        mTableData = [[NSMutableArray alloc] init];
    }
    [self getMessage];
    [mMessageTable reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageBordMedia" object:nil ];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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


- (void)getMessage
{
    [self CMDAction:@"getList": nil];
}

- (void)DeleteMessage :(NSString *)mID
{
    [self CMDAction:@"deleteMessage":mID];
}

- (void)CMDAction:(NSString *)CMD :(NSString *)msgId
{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    
    
    if (msgId != nil)
    {
        [param setObject:msgId forKey:@"msg_id"];
    }
    
    plainID  = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    base64ID = [plainID base64EncodedString];
    
    plainPW  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
    base64PW =[plainPW base64EncodedString];
    
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:CMD forKey:@"CMD"];
    
    
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
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"getList"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [self proess:[reponseData objectForKey:@"DATA"]];
                [mMessageTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            else if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9101"])
            {
                
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"deleteMessage"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [mTableData removeObjectAtIndex:mdeleteID];
                [mMessageTable performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
            else if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9101"])
            {
                
            }
        }
        
    }
    
}


-(void)proess:(NSArray *)Data
{
    [mTableData removeAllObjects];
    for(int i = 0; i <[Data count]; i++)
    {
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        
        [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"MSG_ID"] forKey:@"id"];
        [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"WRITER"]] forKey:@"writer"];
        [dataDic setObject:[XTime getDateFormatChange:[[Data objectAtIndex:i] objectForKey:@"FW_DTTI"]] forKey:@"date"];
        [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"TITLE_CN"]] forKey:@"title"];
        [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"TXT_DTL_CN"]] forKey:@"message"];
        
        if ([[Data objectAtIndex:i] objectForKey:@"RICH_MSG_TYPE"] != nil)
        {
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"RICH_MSG_TYPE"] forKey:@"RICH_MSG_TYPE"];
            [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"RICH_MSG_CN"]] forKey:@"RICH_MSG_CN"];
            if ([[[Data objectAtIndex:i] objectForKey:@"RICH_MSG_TYPE"] isEqualToString:@"1"])
            {
                NSString *str = [dataDic objectForKey:@"RICH_MSG_CN"];
                NSURL *url = [NSURL URLWithString:str];
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 
                 {
                     
                     
                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                     
                     if(image){
                         [mImageDic setObject:image forKey:str];
                         [mMessageTable reloadData];
                     }
                 }];
            }
        }
        
        [mTableData addObject:dataDic];
        
    }
}

-(void)ImagetapDetected:(UIGestureRecognizer *)sender
{
    [ImageScaleCtl setImageData:[(UIImageView *)sender.view image]];
    [self presentViewController:ImageScaleCtl animated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mTableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [mTableData objectAtIndex:indexPath.row];
    CGFloat height;
    NSString *msg;
    NSString *title;
    int Rich_content_Height = 0;
    
    title = [info objectForKey:@"title"];
    msg = [info objectForKey:@"message"];
    
    int baseHeight = 90;
    float PlaceWidth=0.0f;
    CGRect Writerrect,titleRect,MessageRect;
    int writeLableHeight = 0;
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.width == 320.0)
        {
            baseHeight = 90;
            PlaceWidth = 172.0f;
            writeLableHeight = 17.0f;
            
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 210;
            }
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(290.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(290.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                     context:nil];
            
        }
        else if([[UIScreen mainScreen] bounds].size.width == 375.0)
        {
            baseHeight = 100;
            PlaceWidth = 212.0f;
            writeLableHeight = 20.0f;
            
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 300;
            }
            
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(353.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(353.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                     context:nil];
           
        }
        else//414
        {
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 320;
            }
            
            baseHeight = 101;
            PlaceWidth = 230.0f;
            writeLableHeight = 20.0f;
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(392.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(392.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                     context:nil];
            
        }
    }
    
    
    
    if (Writerrect.size.height > writeLableHeight)
        height = baseHeight+MessageRect.size.height+titleRect.size.height+Rich_content_Height + writeLableHeight;
    else
        height = baseHeight+MessageRect.size.height+titleRect.size.height+Rich_content_Height;
    
    
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageBordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoticeBordCell" forIndexPath:indexPath];
    NSDictionary *info = [mTableData objectAtIndex:indexPath.row];
    NSString *MessageString = [info objectForKey:@"message"];
    NSString *titleString = [info objectForKey:@"title"];
    UILabel *writer = (UILabel *)[cell viewWithTag:10];
    writer.text = [info objectForKey:@"writer"];
    UILabel *date = (UILabel *)[cell.contentView viewWithTag:11];
    date.text = [info objectForKey:@"date"];
    UILabel *title = (UILabel *)[cell.contentView viewWithTag:12];
    title.text = titleString;
    UILabel *Msg = (UILabel *)[cell.contentView viewWithTag:13];
    Msg.text = MessageString;
    int lineNum = 0;
    int LableXPos = 0;
    int LableYPos = 0;
    int lineYPos = 0;
    
    int writeLableXPos = 0;
    int writeLableYPos = 0;
    int writeLableHeight = 0;
    
    int titlelineNum = 0;
    int titleLableXPos = 0;
    int titleLableYPos = 0;
    
    int Rich_content_Height = 0;
    int Rich_content_Width = 0;
    
    CGRect Writerrect = CGRectZero,titleRect = CGRectZero,MessageRect = CGRectZero;
    float PlaceWidth = 0.0f;
    
    
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    [writer setNumberOfLines:2];
    
    if ([self stringFromContain:titleString :@"\r\n"])
    {
        titlelineNum = (int)[[titleString componentsSeparatedByString:@"\r\n"] count];
    }
    
    if ([self stringFromContain:MessageString :@"\r\n"])
    {
        lineNum = (int)[[MessageString componentsSeparatedByString:@"\r\n"] count];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.width == 320.0)
        {
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 210;
                Rich_content_Width = 300;
            }
            
            lineYPos = 89+Rich_content_Height;
            
            writeLableXPos = 15;
            writeLableYPos = 14;
            
            titleLableXPos = 15;
            titleLableYPos = 45;
            LableXPos = 15;
            LableYPos = 65+Rich_content_Height;
            PlaceWidth = 172.0;
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(290.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(290.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular"  size:14.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                     context:nil];
            
            if (Writerrect.size.height > 17.0f)
            {
                writeLableHeight = 34.0f;
            }
            else
                writeLableHeight = 17.0f;
            
        }
        else if([[UIScreen mainScreen] bounds].size.width == 375.0)
        {
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 300;
                Rich_content_Width = 340;
            }
            
            lineYPos = 99+Rich_content_Height;
            
            writeLableXPos = 17;
            writeLableYPos = 18;
            
            titleLableXPos = 15;
            titleLableYPos = 48;
            LableXPos = 17;
            LableYPos = 71+Rich_content_Height;
            PlaceWidth = 212.0f;
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(353.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(353.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                     context:nil];
            
            if (Writerrect.size.height > 20.0f)
            {
                writeLableHeight = 40.0f;
            }
            else
                writeLableHeight = 20.0f;
            
        }
        else//414
        {
            if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
            {
                Rich_content_Height = 320;
                Rich_content_Width = 380;
            }
            
            lineYPos = 100+Rich_content_Height;
            
            writeLableXPos = 17;
            writeLableYPos = 18;
            
            titleLableXPos = 17;
            titleLableYPos = 50;
            LableXPos = 17;
            LableYPos = 74+Rich_content_Height;
            PlaceWidth = 230.0f;
            
            titleRect = [[info objectForKey:@"title"] boundingRectWithSize:CGSizeMake(392.0f,9999)
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                   context:nil];
            
            MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(392.0f,9999)
                                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                    attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                       context:nil];
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16.0f]}
                                                                     context:nil];
            if (Writerrect.size.height > 20.0f)
            {
                writeLableHeight = 40.0f;
            }
            else
                writeLableHeight = 20.0f;
        }
    }
    
    if (Writerrect.size.height> 20)
    {
        titleLableYPos = titleLableYPos +20.0f;
    }
    
    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
    {
#ifdef DEBUG
        NSLog(@"Url = %@",[info objectForKey:@"RICH_MSG_CN"]);
#endif
        
        NSString *str = [info objectForKey:@"RICH_MSG_CN"];
        NSURL *url = [NSURL URLWithString:str];
        if ([[info objectForKey:@"RICH_MSG_TYPE"] isEqualToString:@"2"])
        {
            if ([systemVersion floatValue] >= 9.0)
            {
                cell.player = [AVPlayer playerWithURL:url];
                cell.player.closedCaptionDisplayEnabled = NO;
                [cell.avplayerCtl setPlayer:cell.player];
                [cell.avplayerCtl.view setFrame:CGRectMake(titleLableXPos, titleLableYPos+titleRect.size.height+3, Rich_content_Width, Rich_content_Height-10)];
                [cell.avplayerCtl setVideoGravity:AVLayerVideoGravityResizeAspect];
                [cell addSubview:cell.avplayerCtl.view];
                [[cell.avplayerCtl player] pause];
            }
            else
            {
                
                [cell.playerCtl setContentURL:url];
                [cell.playerCtl.view setFrame:CGRectMake(titleLableXPos, titleLableYPos+titleRect.size.height+3, Rich_content_Width, Rich_content_Height-10) ];
                cell.playerCtl.shouldAutoplay = NO;
                cell.playerCtl.scalingMode = MPMovieScalingModeAspectFill;
                [cell addSubview:cell.playerCtl.view];
                [cell.playerCtl stop];
            }
            [cell.Rich_Image removeFromSuperview];
        }
        else
        {
            [cell.Rich_Image setFrame:CGRectMake(10,titleLableYPos+titleRect.size.height+3,Rich_content_Width,Rich_content_Height)];
            [cell.Rich_Image setBackgroundColor:[UIColor clearColor]];
            [cell.Rich_Image setContentMode:UIViewContentModeScaleAspectFit];
            [cell.Rich_Image sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:str]]];
            if ([mImageDic objectForKey:str] != nil)
            {
                [cell.Rich_Image setImage:[mImageDic objectForKey:str]];
            }
            else
            {
                [cell.Rich_Image setImage:[[UIImage alloc] init]];
            }
            [cell.Rich_Image setUserInteractionEnabled:YES];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImagetapDetected:)];
            singleTap.numberOfTapsRequired = 1;
            [cell.Rich_Image addGestureRecognizer:singleTap];
            
            [cell addSubview:cell.Rich_Image];
            [cell bringSubviewToFront:cell.Rich_Image];
            [cell.avplayerCtl.view removeFromSuperview];
            [cell.playerCtl.view removeFromSuperview];
        }
    }
    else
    {
        if ([systemVersion floatValue] >= 9.0)
            [cell.avplayerCtl.view removeFromSuperview];
        else
            [cell.playerCtl.view removeFromSuperview];
        
        [cell.Rich_Image removeFromSuperview];
    }
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [writer setFrame: CGRectMake(writeLableXPos, writeLableYPos, PlaceWidth, writeLableHeight)];
            [title setFrame:CGRectMake(titleLableXPos, titleLableYPos, titleRect.size.width, titleRect.size.height)];
            [Msg setFrame:CGRectMake(LableXPos, LableYPos+titleRect.size.height, MessageRect.size.width, MessageRect.size.height)];
            UIView *line = (UIView *)[cell.contentView viewWithTag:14];
            [line setFrame:CGRectMake(0, lineYPos+MessageRect.size.height+titleRect.size.height, [[UIScreen mainScreen] bounds].size.width , 1)];
        });
    });
    
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *userInfo = [[NSDictionary alloc] init];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 여기서 항목 삭제
    mdeleteID = indexPath.row;
    NSDictionary *info = [mTableData objectAtIndex:indexPath.row];
    [self DeleteMessage:[info objectForKey:@"id"]];
    if ([mImageDic objectForKey:[info objectForKey:@"RICH_MSG_CN"]] != nil)
    {
        [mImageDic removeObjectForKey:[info objectForKey:@"RICH_MSG_CN"]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"삭제";
}

@end