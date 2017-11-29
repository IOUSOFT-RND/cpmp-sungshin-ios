//
//  CardCellViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 12..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CardCellViewController.h"
#import "AppDelegate.h"
#import "ServerIndexEnum.h"
#import "NSData+AES.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"

#import "ServiceDb.h"
#import "Json.h"
#import "StringEnumDef.h"
#import "XTime.h"
#import "NSString+Escape.h"
#import "BusTableViewCell.h"
#import "ClassTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "MessageTableViewCell.h"
#import "FoodTableViewCell.h"

#import "AESHelper.h"
#import "Common.h"
#import "UserData.h"
#import "LogHelper.h"


@interface CardCellViewController ()
{
    int FoodTableCellIndex;
}

@end

@implementation CardCellViewController

@synthesize index,mTableView,mprewebView;

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mTableView.delegate = self;
    TableCellData = [[NSMutableArray alloc] init];
    WebViewHeights = [[NSMutableDictionary alloc] init];
    WebImages = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(busDetailAction:) name:@"BusBordAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BookmarkMessage:) name:@"BookmarkActionNoti" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CurrentViewReloadAction) name:@"CurrentViewReloadAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataload) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // Do any additional setup after loading the view.
    [self dataload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCellMedia" object:nil ];
}


-(void)CurrentViewReloadAction
{
    [self dataload];
}

-(void)dataload
{
    switch (index)
    {
        case 0:
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCellMedia" object:nil ];
            [self TapAction:@"getPastMainList"];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCellMedia" object:nil ];
            [self TapAction:@"getMainList"];
            break;
        case 2:
	    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageCellMedia" object:nil ];
            [self TapAction:@"getBookmarkMainList"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)DetailWebViewAction:(NSString *)url
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailWebviews"
                                                        object:nil
                                                      userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:url,@"URL",nil]];
}

- (void)busDetailAction:(NSNotification *) noti
{
    if ([TableCellData count] ==0) {
        return;
    }
    
    NSDictionary *info = [TableCellData objectAtIndex:[[[noti userInfo] objectForKey:@"Row"] intValue]];
    if (info == nil) {
        return;
    }
    NSDictionary *BusInfo = [[info objectForKey:@"BusInfos"] objectAtIndex:0];
    NSString *StoreString = nil;
    if (BusInfo == nil) {
        return;
    }
    
    if([BusInfo objectForKey:@"STOREURL"] != nil)
        StoreString = [BusInfo objectForKey:@"STOREURL"];
    
    [self ServiceExc:[BusInfo objectForKey:@"CONTENTTYPE"]
          ContentUrl:[BusInfo objectForKey:@"CONTENTURL"]
            StoreUrl:StoreString];
}

- (void)FoodDetailAction
{
    NSDictionary *info = [TableCellData objectAtIndex:FoodTableCellIndex];
    NSDictionary *FoodInfos = [[info objectForKey:@"FoodInfos"] objectAtIndex:0];
    NSString *StoreString = nil;
    
    if([FoodInfos objectForKey:@"STOREURL"] != nil)
        StoreString = [FoodInfos objectForKey:@"STOREURL"];
    
    [self ServiceExc:[FoodInfos objectForKey:@"CONTENTTYPE"]
          ContentUrl:[FoodInfos objectForKey:@"CONTENTURL"]
            StoreUrl:StoreString];
}


-(void)ServiceExc:(NSString *)contentType ContentUrl:(NSString *)contenUrl StoreUrl:(NSString *)storeUrl
{
    
    [[UserData sharedUserData] setUSER_ID:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
    [[UserData sharedUserData] setUSER_PASS:[[NSUserDefaults standardUserDefaults] objectForKey:@"pw"]];
    [[UserData sharedUserData] setUSER_TYPE:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_TYPE"]];
    
    NSString * newUrl;
    if (contentType == nil ||
        contenUrl == nil)
    {
        return;
    }
    if ([contentType isEqualToString:@"2"])
    {
        NSString *makeUrl = [self makeCONTENT_URL:contenUrl];
        newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        newUrl = [Common addressHttpCheck:newUrl];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebViewAction"
                                                            object:nil
                                                          userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:newUrl,@"URL",nil ,@"service",nil]];
        //웹뷰실행
    }
    else if ([contentType isEqualToString:@"1"])
    {
        NSString *makeUrl = [self makeCONTENT_URL:contenUrl];
        newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        NSLog(@"URL =  %@",newUrl);
        if ([Common boolAppYN:newUrl]) {
            [Common openURL:newUrl];
        }
        else
        {
            [Common openURL:storeUrl];
        }
    }
    else if ([contentType isEqualToString:@"3"])
    {
        NSString *makeUrl = [self makeCONTENT_URL:contenUrl];
        newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        newUrl = [Common addressHttpCheck:newUrl];
        //사파리실행
        [Common openURL:newUrl];
    }
    else
    {
        NSString *makeUrl = [self makeCONTENT_URL:contenUrl];
        newUrl = [Common getUrlStringWithApplyMetaData:makeUrl];
        //외부 실행
        [Common openURL:newUrl];
    }

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

- (void)TapAction:(NSString *)CMD
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

- (void)BookmarkMessage:(NSNotification *)noti
{
    if (index != [[noti.userInfo objectForKey:@"CrrentTap"] integerValue])
    {
        return;
    }
    
    mBookmarkRow = [[noti.userInfo objectForKey:@"Row"] intValue];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    
    NSString *base64ID,*base64PW, *plainID, *plainPW;
    
    
    plainID  = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
    base64ID = [plainID base64EncodedString];
    
    plainPW  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pw"];
    base64PW =[plainPW base64EncodedString];
    
    [param setObject:[noti.userInfo objectForKey:@"msgid"] forKey:@"MSG_ID"];
    [param setObject:[noti.userInfo objectForKey:@"msgtype"] forKey:@"MSG_TYPE"];
    [param setObject:[noti.userInfo objectForKey:@"bookmark"] forKey:@"IMP_YN"];
    [param setObject:base64ID forKey:@"id"];
    [param setObject:base64PW forKey:@"pw"];
    [param setObject:[[self appDelegate] getCno] forKey:@"cno"];
    [param setObject:APPCODE forKey:@"app_code"];
    [param setObject:@"bookmarkMessage" forKey:@"CMD"];
    
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
    if (![[self appDelegate] misLogin])
    {
        return;
    }
    
    
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
        

        NSLog(@"Data = \n%@",[NSString stringWithString:ConvertString]);
        NSDictionary *reponseData = [Json decode:[NSString stringWithString:ConvertString]];
        
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9109"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DoubleLoginAction" object:nil];
            
            return;
        }
        
        if ([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"9101"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerSyncFailAction" object:nil];
            return;
        }
        
        if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0300"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LossLoginAction" object:nil];
            
            return;
        }
        
        if ([[reponseData objectForKey:@"CMD"] isEqualToString:@"getPastMainList"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                [self proess:[reponseData objectForKey:@"DATA"]];
                [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getMainList"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
     
                [self proess:[reponseData objectForKey:@"DATA"]];
                [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"getBookmarkMainList"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                
                [self proess:[reponseData objectForKey:@"DATA"]];
                [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }
        else if([[reponseData objectForKey:@"CMD"] isEqualToString:@"bookmarkMessage"])
        {
            if([[reponseData objectForKey:@"RESULT_CODE"] isEqualToString:@"0000"])
            {
                if (index == 2)
                {
                    [self TapAction:@"getBookmarkMainList"];
                    [mTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                }
                else
                {
                    if (mBookmarkRow < 0)
                    {
                        return;
                    }
                    
                    NSMutableDictionary *info = [TableCellData objectAtIndex:mBookmarkRow];
                    if([[info objectForKey:@"bookmark"] isEqualToString:@"N"])
                    {
                        [info setObject:@"Y" forKey:@"bookmark"];
                    }
                    else
                    {
                        [info setObject:@"N" forKey:@"bookmark"];
                    }
                    [TableCellData replaceObjectAtIndex:mBookmarkRow withObject:info];
                    mBookmarkRow = -1;
                }
            }
        }
        
    }
    
}

                     
-(void)proess:(NSArray *)Data
{
    [TableCellData removeAllObjects];
    [WebViewHeights removeAllObjects];
    
    for(int i = 0; i <[Data count]; i++)
    {
        NSString *type = [[Data objectAtIndex:i] objectForKey:@"MSG_TYPE"];
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        
        if ([type intValue] == CardType_Message)
        {
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"MSG_ID"] forKey:@"id"];
            [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"WRITER"]] forKey:@"writer"];
            [dataDic setObject:[XTime getDateFormatChange:[[Data objectAtIndex:i] objectForKey:@"FW_DTTI"]] forKey:@"date"];
            [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"TXT_DTL_CN"]] forKey:@"message"];
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"IMP_YN"] forKey:@"bookmark"];
            [dataDic setObject:type forKey:@"type"];
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
                             [WebImages setObject:image forKey:str];
                         }
                     }];
                }
            }
            
            [TableCellData addObject:dataDic];
            
        }
        else if([type intValue] == CardType_lcecture)
        {
            NSMutableArray *classInfo = [[NSMutableArray alloc]init];
            NSArray *classData = [[Data objectAtIndex:i]objectForKey:@"DATA"];
            for (int i= 0; i < [classData count]; i++)
            {
                
                NSMutableDictionary *dataSubDic =[[NSMutableDictionary alloc] init];
                
                switch ([[[classData objectAtIndex:i] objectForKey:@"CONTENTTYPE"] intValue])
                {
                    case 1:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"IOSCONTENTURL"]] forKey:@"CONTENTURL"];
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"IOSSTOREURL"]] forKey:@"STOREURL"];
                        break;
                    case 2:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"WEBCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    case 3:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"BROWSERCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    default:
                        break;
                }
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"CONTENTTYPE"]] forKey:@"CONTENTTYPE"];
                
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"TIME"]] forKey:@"time"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"ROOM"]] forKey:@"room"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"PROF"]] forKey:@"prof"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[classData objectAtIndex:i] objectForKey:@"TITLE_CN"]] forKey:@"title"];
                [classInfo addObject:dataSubDic];
            }
            [dataDic setObject:classInfo forKey:@"classInfos"];
            [dataDic setObject:type forKey:@"type"];
            [TableCellData addObject:dataDic];
        }
        else if([type intValue] == CardType_Food)
        {
            NSMutableArray *FoodInfo = [[NSMutableArray alloc]init];
            NSArray *FoodData = [[Data objectAtIndex:i]objectForKey:@"DATA"];
            for (int i = 0; i < [FoodData count]; i++)
            {
                NSMutableDictionary *dataSubDic =[[NSMutableDictionary alloc] init];
                
                switch ([[[FoodData objectAtIndex:i] objectForKey:@"CONTENTTYPE"] intValue])
                {
                    case 1:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"IOSCONTENTURL"]] forKey:@"CONTENTURL"];
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"IOSSTOREURL"]] forKey:@"STOREURL"];
                        break;
                    case 2:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"WEBCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    case 3:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"BROWSERCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    default:
                        break;
                }
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"CONTENTTYPE"]] forKey:@"CONTENTTYPE"];
                

                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"TIME"]] forKey:@"time"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"MENU"]] forKey:@"menu"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"PRICE"]] forKey:@"price"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"POS"]] forKey:@"pos"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"CORNER"]] forKey:@"CORNER"];
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[FoodData objectAtIndex:i] objectForKey:@"TITLE_CN"]] forKey:@"title"];
                [FoodInfo addObject:dataSubDic];
            
            }
            [dataDic setObject:FoodInfo forKey:@"FoodInfos"];
            [dataDic setObject:type forKey:@"type"];
            [TableCellData addObject:dataDic];
        }
        else if([type intValue] == CardType_Bus)
        {
            
            NSMutableArray *BusInfo = [[NSMutableArray alloc]init];
            NSArray *BusData = [[Data objectAtIndex:i]objectForKey:@"DATA"];
            for (int i = 0; i < [BusData count]; i++)
            {
                
                NSMutableDictionary *dataSubDic =[[NSMutableDictionary alloc] init];
                
                switch ([[[BusData objectAtIndex:i] objectForKey:@"CONTENTTYPE"] intValue])
                {
                    case 1:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[BusData objectAtIndex:i] objectForKey:@"IOSCONTENTURL"]] forKey:@"CONTENTURL"];
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[BusData objectAtIndex:i] objectForKey:@"IOSSTOREURL"]] forKey:@"STOREURL"];
                        break;
                    case 2:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[BusData objectAtIndex:i] objectForKey:@"WEBCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    case 3:
                        [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[BusData objectAtIndex:i] objectForKey:@"BROWSERCONTENTURL"]] forKey:@"CONTENTURL"];
                        break;
                    default:
                        break;
                }
                [dataSubDic setObject:[NSString unescapeAddJavaUrldecode:[[BusData objectAtIndex:i] objectForKey:@"CONTENTTYPE"]] forKey:@"CONTENTTYPE"];
                
                NSMutableArray *BusDetailInfo = [[NSMutableArray alloc]init];
                NSArray *DetailData = [[BusData objectAtIndex:i] objectForKey:@"DETAIL"];
                for (int j = 0; j < [DetailData count] ; j++)
                {
                    NSMutableDictionary *DetailSubDic =[[NSMutableDictionary alloc] init];
                    if ([[DetailData objectAtIndex:j] objectForKey:@"NOSUNNAME"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"NOSUNNAME"]] forKey:@"NOSUNNAME"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"NOSUNNAME"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPNAME1"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPNAME1"]] forKey:@"STOPNAME1"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"NOSUNNAME"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPNAME2"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPNAME2"]] forKey:@"STOPNAME2"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"NOSUNNAME"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPNAME3"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPNAME3"]] forKey:@"STOPNAME3"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"NOSUNNAME"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPTIME1"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPTIME1"]] forKey:@"STOPTIME1"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"STOPTIME1"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPTIME2"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPTIME2"]] forKey:@"STOPTIME2"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"STOPTIME2"];
                    }
                    
                    if ([[DetailData objectAtIndex:j] objectForKey:@"STOPTIME3"])
                        [DetailSubDic setObject:[NSString unescapeAddJavaUrldecode:[[DetailData objectAtIndex:j] objectForKey:@"STOPTIME3"]] forKey:@"STOPTIME3"];
                    else
                    {
                        [DetailSubDic setObject:@"" forKey:@"STOPTIME3"];
                    }
                    
                    [BusDetailInfo addObject:DetailSubDic];
                }
                [dataSubDic setObject:BusDetailInfo forKey:@"DETAIL"];
                [BusInfo addObject:dataSubDic];
                
            }
            [dataDic setObject:BusInfo forKey:@"BusInfos"];
            [dataDic setObject:type forKey:@"type"];

            [TableCellData addObject:dataDic];
            
        }
        else if([type intValue] == CardType_Notic)
        {
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"MSG_ID"] forKey:@"id"];
            [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"TITLE_CN"]] forKey:@"title"];
            
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"WRITER"] forKey:@"writer"];
            [dataDic setObject:[XTime getDateFormatChange:[[Data objectAtIndex:i] objectForKey:@"DATE"]] forKey:@"date"];
            [dataDic setObject:[NSString unescapeAddJavaUrldecode:[[Data objectAtIndex:i] objectForKey:@"TXT_DTL_CN"]] forKey:@"message"];
            [dataDic setObject:[[Data objectAtIndex:i] objectForKey:@"IMP_YN"] forKey:@"bookmark"];
            [dataDic setObject:type forKey:@"type"];
            [TableCellData addObject:dataDic];
            [WebViewHeights setObject:[[NSNumber alloc] initWithFloat:0.0f] forKey: [[NSNumber alloc] initWithInt:i]];
        }
    }
}

#pragma mark -
#pragma mark Table view delegates
static CGFloat padding = 20.0;


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return TableCellData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *info = [TableCellData objectAtIndex:indexPath.row];
    NSString *type = [info objectForKey:@"type"];
    CGFloat height =0.0f;

    NSString *writer;
    NSInteger Classcount = 0,Buscount = 0 , SubTableHeight = 0;
    int Rich_content_Height = 0;
    CGRect Writerrect,MessageRect = CGRectZero;
    float PlaceWidth = 0.0f;
    
    switch ([type integerValue])
    {
        case 0:
            if ([[UIScreen mainScreen] bounds].size.height == 568.0)
            {
                height = 440.0f;
            }
            else if([[UIScreen mainScreen] bounds].size.height == 480.0)
            {
                height = 360.0f;
            }
            else if ([[UIScreen mainScreen] bounds].size.height == 667.0)
            {
                height = 540.0f;
            }
            else
            {
                height = 601.0f;
            }
            
            break;
            
        case 1:
           
            writer = [info objectForKey:@"writer"];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.width == 320.0)
                {
                    PlaceWidth = 158.0f;
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                    }
                    
                    
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(252.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                }
                else if([[UIScreen mainScreen] bounds].size.width == 375.0)
                {
                    PlaceWidth = 210.0f;
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                    }
                    
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(300.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                }
                else//414
                {
                    PlaceWidth = 240.0f;
                    
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                    }
                    
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(340.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                    
                }
            }
            
            height = 174.0f-28+MessageRect.size.height+padding+Rich_content_Height;
            
            Writerrect = [writer boundingRectWithSize:CGSizeMake(PlaceWidth,9999)
                                              options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                              context:nil];
            
            if (Writerrect.size.height > 20.0f)
            {
                height = height+14.0f;
            }
            break;
        case 2:
            height = 170-45;
            Classcount = [[info objectForKey:@"classInfos"] count];
            
            if (Classcount > 1)
            {
                height = 54*(Classcount-1)+height;
            }
            
            break;
        case 3:
            height = 210.0f;
            if ([[[[info objectForKey:@"FoodInfos"] objectAtIndex:0] objectForKey:@"CONTENTTYPE"] isEqualToString:@"4"])
            {
                height = height-45;
            }
            break;
        case 4:
            if ([[UIScreen mainScreen] bounds].size.width == 320.0)
            {
                height = 220.0f;
                SubTableHeight = 22;
            }
            else if([[UIScreen mainScreen] bounds].size.width == 375.0)
            {
                height = 225.0f;
                SubTableHeight = 32;
            }
            else//414
            {
                height = 225.0f;
                SubTableHeight = 32;
            }
            
            Buscount = [[[[info objectForKey:@"BusInfos"] objectAtIndex:0] objectForKey:@"DETAIL"] count];
            if ([[[[info objectForKey:@"BusInfos"] objectAtIndex:0] objectForKey:@"CONTENTTYPE"] isEqualToString:@"4"])
            {
                height = height-45;
            }
            
            if (Buscount > 2)
            {
                height = SubTableHeight*(Buscount-2)+height;
            }
            
            break;
        case 5:
            if ([[WebViewHeights objectForKey:[[NSNumber alloc] initWithInteger: indexPath.row]] floatValue] == 0.0f)
            {
                height = 1.0f;
            }
            else
            {
                height = 153.0f+[[WebViewHeights objectForKey:[[NSNumber alloc] initWithInteger: indexPath.row]] floatValue];
            }
            break;
        default:
            break;
    }

    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    BusTableViewCell *busCell;
    ClassTableViewCell *classCell;
    NoticeTableViewCell *noticCell;
    MessageTableViewCell *messageCell;
    
    NSDictionary *info = [TableCellData objectAtIndex:indexPath.row];
    NSString *type = [info objectForKey:@"type"];
    NSString *PosString = @"";
    CGSize size = CGSizeZero;
    int CardWidth = 0, infoWidth = 0, infoHeight = 0, BusSubCellHeight = 0, lectrueSubCellHeight = 0;
    int SubTableWidth = 0, SubTableHeight = 0, SubTableX = 0, SubTableY = 0;
    NSArray *FoodInfo,*BusInfo;
    UILabel *titleView, *posView, *timeView, *priceView, *menuView;
    UIButton *DetailBtn;
    int Rich_content_Height =0 , Rich_content_Width = 0;
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    CGRect Writerrect = CGRectZero, MessageRect = CGRectZero;
    float PlaceWidth = 0.0f;
    float Placeheight = 0.0f;
    CGRect StopPointRect1,StopPointRect2,StopPointRect3;
    NSString *StopPointName1, *StopPointName2, *StopPointName3;
    float busCenter = 0.0f, busPointX = 0.0f ,busPointY = 0.0f,busPointWidth = 0.0f;
    
    switch ([type integerValue])
    {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCard" forIndexPath:indexPath];;
            break;
            
        case 1:
            messageCell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.width == 320.0)
                {
                    CardWidth = 304;
                    infoWidth = 286;
                    PlaceWidth = 158.0f;
                    
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                        Rich_content_Width = 280;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                        Rich_content_Width = 0;
                    }
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(252.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                    
                }
                else if([[UIScreen mainScreen] bounds].size.width == 375.0)
                {
                    CardWidth = 359;
                    infoWidth = 337;
                    PlaceWidth = 210.0f;
                    
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                        Rich_content_Width = 330;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                        Rich_content_Width = 0;
                    }
                    
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(300.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                }
                else//414
                {
                    CardWidth = 398;
                    infoWidth = 368;
                    PlaceWidth = 240.0f;
                    
                    if ([info objectForKey:@"RICH_MSG_TYPE"] != nil)
                    {
                        Rich_content_Height = 210;
                        Rich_content_Width = 360;
                    }
                    else
                    {
                        Rich_content_Height = 0;
                        Rich_content_Width = 0;
                    }
                    
                    MessageRect = [[info objectForKey:@"message"] boundingRectWithSize:CGSizeMake(340.0f,9999)
                                                                               options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                            attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                               context:nil];
                }
            }
            
            Writerrect = [[info objectForKey:@"writer"] boundingRectWithSize:CGSizeMake(messageCell.PlaceLable.frame.size.width,9999)
                                                                     options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                  attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]}
                                                                     context:nil];
            
            if (Writerrect.size.height > 20.0f)
                Placeheight = 14.0f;
            else
                Placeheight = 0.0f;
            
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
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                messageCell.player = [AVPlayer playerWithURL:url];
                                messageCell.player.closedCaptionDisplayEnabled = NO;
                                [messageCell.avplayerCtl setPlayer:messageCell.player];
                                [messageCell.avplayerCtl.view setFrame:CGRectMake(5, 62, Rich_content_Width, Rich_content_Height-10)];
                                [messageCell.avplayerCtl setVideoGravity:AVLayerVideoGravityResizeAspect];
                                [messageCell.infoview addSubview:messageCell.avplayerCtl.view];
                                [[messageCell.avplayerCtl player] pause];
                            });
                        });
                    }
                    else
                    {
                        [messageCell.playerCtl setContentURL:url];
                        [messageCell.playerCtl.view setFrame:CGRectMake(5, 62, Rich_content_Width, Rich_content_Height-10) ];
                        [messageCell.infoview addSubview:messageCell.playerCtl.view];
                        messageCell.playerCtl.shouldAutoplay = NO;
                        messageCell.playerCtl.scalingMode = MPMovieScalingModeAspectFill;
                        [messageCell.infoview addSubview:messageCell.playerCtl.view];
                        [messageCell.playerCtl pause];
                    }
                    
                    [messageCell.Rich_Image removeFromSuperview];
                }
                else
                {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // 이 블럭은 위 작업이 완료되면 호출된다.
                            [messageCell.Rich_Image setFrame:CGRectMake(5,
                                                                        62+Placeheight,
                                                                        Rich_content_Width,
                                                                        Rich_content_Height-10)];
                            if ([WebImages objectForKey:str] != nil)
                            {
                                [messageCell.Rich_Image setImage:[WebImages objectForKey:str]];
                            }
                            else
                            {
                                [messageCell.Rich_Image setImage:[[UIImage alloc] init]];
                            }
                            [messageCell.Rich_Image setBackgroundColor:[UIColor clearColor]];
                            [messageCell.Rich_Image setContentMode:UIViewContentModeScaleAspectFit];
                            [messageCell.infoview addSubview:messageCell.Rich_Image];
                            [messageCell.avplayerCtl.view removeFromSuperview];
                            [messageCell.playerCtl.view removeFromSuperview];
                        });
                    });
                    
                    
                }
            }
            else
            {
                if ([systemVersion floatValue] >= 9.0)
                    [messageCell.avplayerCtl.view removeFromSuperview];
                else
                    [messageCell.playerCtl.view removeFromSuperview];
                
                [messageCell.Rich_Image removeFromSuperview];
            }
            
            
            
            
            
            [messageCell.TitleLable setText:@"메세지"];
            [messageCell.PlaceLable setText:[info objectForKey:@"writer"]];
            [messageCell.DateLable setText:[info objectForKey:@"date"]];
            [messageCell setMid:[info objectForKey:@"id"]];
            [messageCell setMCrrentTap:[NSString stringWithFormat:@"%d",(int)index]];
            [messageCell setMRow:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
            
            if ([[info objectForKey:@"bookmark"] isEqualToString:@"N"])
            {
                [messageCell.BookmarkImage setSelected:NO];
            }
            else
            {
                [messageCell.BookmarkImage setSelected:YES];
            }
            
            cell = messageCell;
            
            [messageCell.cellTotalview setFrame:CGRectMake(0, 8, CardWidth, 164+MessageRect.size.height+padding+Rich_content_Height+Placeheight)];
            [messageCell.infoview setFrame:CGRectMake(10, 19, infoWidth, 66+MessageRect.size.height+padding+Rich_content_Height+Placeheight)];
            
            [messageCell.detailview setFrame:CGRectMake(0, 92+MessageRect.size.height+padding+Rich_content_Height+Placeheight, CardWidth, 45+size.height+padding)];
            [messageCell.PlaceLable setFrame:CGRectMake(6, 37, PlaceWidth, 20.0f)];
            
            [messageCell.Messageview setFrame:CGRectMake(10, 62+Rich_content_Height+Placeheight, MessageRect.size.width+(padding*0.5), MessageRect.size.height+padding)];
            [messageCell.Messageview setText:[info objectForKey:@"message"]];
            [messageCell.Messageview setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]];
            [messageCell.backgroundImg setImage:[[UIImage imageNamed:@"bg_card_mesege.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 19, 40, 66) resizingMode:UIImageResizingModeStretch]];
            [messageCell.backgroundImg setFrame:CGRectMake(5,
                                                           62+Rich_content_Height+Placeheight,
                                                           MessageRect.size.width+padding,
                                                           MessageRect.size.height+padding)];
            
            break;
        case 2:
            classCell = [tableView dequeueReusableCellWithIdentifier:@"lectruescheduleCell" forIndexPath:indexPath];
            
            classCell.mTableData =[info objectForKey:@"classInfos"];
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.width == 320.0)
                {
                    CardWidth = 304;
                    SubTableWidth = 273;
                }
                else if([[UIScreen mainScreen] bounds].size.width == 375.0)
                {
                    CardWidth = 359;
                    SubTableWidth = 313;
                }
                else//414
                {
                    CardWidth = 398;
                    SubTableWidth = 365;
                    
                }
            }
            
            infoHeight = 117;
            if ([classCell.mTableData count] > 1)
            {
                lectrueSubCellHeight =  54*((int)[classCell.mTableData count]-1);
            }
            
            [classCell setChangViewIndex:[NSString stringWithFormat:@"%d",(int)indexPath.row]
                              InfoRect:CGRectMake(0, 8, CardWidth, infoHeight+lectrueSubCellHeight)
                            DetailRect:CGRectNull//CGRectMake(0, infoHeight+lectrueSubCellHeight, CardWidth, 45)
                             TableRect:CGRectMake(15, 58, SubTableWidth, lectrueSubCellHeight+54)];
            
            cell = classCell;
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:@"FoodSheduleCell" ];
            FoodTableCellIndex = (int)indexPath.row;
            
            FoodInfo = [info objectForKey:@"FoodInfos"];
            
            titleView = (UILabel*)[cell.contentView viewWithTag:11];
            [titleView setText:[[FoodInfo objectAtIndex:0] objectForKey:@"title"]];
            posView = (UILabel*)[cell.contentView viewWithTag:12];
            
            PosString = [NSString stringWithFormat:@"%@ %@",[[FoodInfo objectAtIndex:0] objectForKey:@"pos"],[[FoodInfo objectAtIndex:0] objectForKey:@"CORNER"]];
            
            [posView setText:PosString];
            timeView = (UILabel*)[cell.contentView viewWithTag:13];
            [timeView setText:[[FoodInfo objectAtIndex:0] objectForKey:@"time"]];
            priceView = (UILabel*)[cell.contentView viewWithTag:14];
            [priceView setText:[[FoodInfo objectAtIndex:0] objectForKey:@"price"]];
            
            menuView = (UILabel*)[cell.contentView viewWithTag:15];
            [menuView setText:[[FoodInfo objectAtIndex:0] objectForKey:@"menu"]];
            
//            totalView = (UIView *)[cell.contentView viewWithTag:2];
            
            if ([[[FoodInfo objectAtIndex:0] objectForKey:@"CONTENTTYPE"] isEqualToString:@"4"])
                [(UIView *)[cell.contentView viewWithTag:20] setHidden:YES];
            else
                [(UIView *)[cell.contentView viewWithTag:20] setHidden:NO];

            DetailBtn = (UIButton *)[cell.contentView viewWithTag:21];
            [DetailBtn addTarget:self action:@selector(FoodDetailAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView setNeedsDisplay];
            
            break;
        case 4:
            busCell = [tableView dequeueReusableCellWithIdentifier:@"BusSheduleCell" forIndexPath:indexPath];
            
            BusInfo = [[[info objectForKey:@"BusInfos"] objectAtIndex:0] objectForKey:@"DETAIL"];
            busCell.mTableData = [[NSMutableArray alloc] init];
            for (int i = 0; i < [BusInfo count]; i++)
            {
                if (i == 0)
                {
                    [(UILabel*)[busCell.contentView viewWithTag:30]  setText:[[BusInfo objectAtIndex:i] objectForKey:@"NOSUNNAME"]];
                    StopPointName1 = [[BusInfo objectAtIndex:i] objectForKey:@"STOPNAME1"];
                    StopPointName2 = [[BusInfo objectAtIndex:i] objectForKey:@"STOPNAME2"];
                    StopPointName3 = [[BusInfo objectAtIndex:i] objectForKey:@"STOPNAME3"];
                    
                }
                else
                    [busCell.mTableData addObject:[BusInfo objectAtIndex:i]];
            }
            
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                if ([[UIScreen mainScreen] bounds].size.width == 320.0)
                {
                    CardWidth = 304;
                    infoHeight = 167;
                    SubTableX = 15;
                    SubTableY = 138;
                    SubTableWidth = 271;
                    SubTableHeight = 22;
                    
                    busCenter = 16.5f;
                    busPointWidth = 98.0f;
                    busPointX = 38.0f;
                    busPointY = 85.0f;
                    
                }
                else if([[UIScreen mainScreen] bounds].size.width == 375.0)
                {
                    CardWidth = 359;
                    infoHeight = 172;
                    SubTableX = 23;
                    SubTableY = 138;
                    SubTableWidth = 309;
                    SubTableHeight = 32;
                    
                    busCenter = 20.0f;
                    busPointWidth = 120.0f;
                    busPointX = 38.0f;
                    busPointY = 81.0f;
                    
                }
                else//414
                {
                    CardWidth = 398;
                    infoHeight = 172;
                    SubTableX = 38;
                    SubTableY = 139;
                    SubTableWidth = 318;
                    SubTableHeight = 32;
                    
                    busCenter = 20.0f;
                    busPointWidth = 121.0f;
                    busPointX = 51.0f;
                    busPointY = 77.0f;
                    
                }
            }
            
            StopPointRect1 = [StopPointName1 boundingRectWithSize:CGSizeMake(91.0f,40.0f)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:12.0f]}
                                                          context:nil];
            StopPointRect2 = [StopPointName2 boundingRectWithSize:CGSizeMake(91.0f,40.0f)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:12.0f]}
                                                          context:nil];
            StopPointRect3 = [StopPointName3 boundingRectWithSize:CGSizeMake(91.0f,40.0f)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:12.0f]}
                                                          context:nil];
            
            
            if (StopPointRect1.size.height <= busCenter*2)
            {
                StopPointRect1.size.height = busCenter*2-10.0f;
            }
            
            if (StopPointRect2.size.height <= busCenter*2)
            {
                StopPointRect2.size.height = busCenter*2-10.0f;
            }
            
            if (StopPointRect3.size.height <= busCenter*2)
            {
                StopPointRect3.size.height = busCenter*2-10.0f;
            }
            
            [(UILabel*)[busCell.contentView viewWithTag:31]  setText:StopPointName1];
            [(UILabel*)[busCell.contentView viewWithTag:32]  setText:StopPointName2];
            [(UILabel*)[busCell.contentView viewWithTag:33]  setText:StopPointName3];
            [(UILabel*)[busCell.contentView viewWithTag:31]  setFrame:StopPointRect1];
            [(UILabel*)[busCell.contentView viewWithTag:31]  setCenter:CGPointMake(busPointX+busCenter, busCenter+busPointY)];
            [(UILabel*)[busCell.contentView viewWithTag:32]  setFrame:StopPointRect2];
            [(UILabel*)[busCell.contentView viewWithTag:32]  setCenter:CGPointMake(busPointX+busPointWidth+busCenter, busCenter+busPointY)];
            [(UILabel*)[busCell.contentView viewWithTag:33]  setFrame:StopPointRect3];
            [(UILabel*)[busCell.contentView viewWithTag:33]  setCenter:CGPointMake(busPointX+(busPointWidth*2)+busCenter, busCenter+busPointY)];
            [(UILabel*)[busCell.contentView viewWithTag:31]  setNeedsDisplay];
            [(UILabel*)[busCell.contentView viewWithTag:32]  setNeedsDisplay];
            [(UILabel*)[busCell.contentView viewWithTag:33]  setNeedsDisplay];
            
            [(UIImageView*)[busCell.contentView viewWithTag:21] setImage:[[UIImage imageNamed:@"bg_card_buspoint@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13 ) resizingMode:UIImageResizingModeStretch]];
            [(UIImageView*)[busCell.contentView viewWithTag:21]  setFrame:CGRectMake(0, 0, StopPointRect1.size.width+10.0f, StopPointRect3.size.height+10.0f)];
            [(UIImageView*)[busCell.contentView viewWithTag:21]  setCenter:CGPointMake(busPointX+busCenter, busCenter+busPointY)];
            [(UIImageView*)[busCell.contentView viewWithTag:21]  setNeedsDisplay];
            
            [(UIImageView*)[busCell.contentView viewWithTag:22] setImage:[[UIImage imageNamed:@"bg_card_buspoint@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13 ) resizingMode:UIImageResizingModeStretch]];
            [(UIImageView*)[busCell.contentView viewWithTag:22]  setFrame:CGRectMake(0, 0, StopPointRect2.size.width+10.0f, StopPointRect3.size.height+10.0f)];
            [(UIImageView*)[busCell.contentView viewWithTag:22]  setCenter:CGPointMake(busPointX+busPointWidth+busCenter, busCenter+busPointY)];
            [(UIImageView*)[busCell.contentView viewWithTag:22]  setNeedsDisplay];
            
            [(UIImageView*)[busCell.contentView viewWithTag:23] setImage:[[UIImage imageNamed:@"bg_card_buspoint@2x.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 13 ) resizingMode:UIImageResizingModeStretch]];
            [(UIImageView*)[busCell.contentView viewWithTag:23]  setFrame:CGRectMake(0, 0, StopPointRect3.size.width+10.0f, StopPointRect3.size.height+10.0f)];
            [(UIImageView*)[busCell.contentView viewWithTag:23]  setCenter:CGPointMake(busPointX+(busPointWidth*2)+busCenter, busCenter+busPointY)];
            [(UIImageView*)[busCell.contentView viewWithTag:23]  setNeedsDisplay];
            
            
            if ([BusInfo count] > 2)
            {
                BusSubCellHeight = SubTableHeight*((int)[BusInfo count]-2);
            }
            
            if ([[[[info objectForKey:@"BusInfos"] objectAtIndex:0] objectForKey:@"CONTENTTYPE"] isEqualToString:@"4"])
            {
                
                [busCell setChangViewIndex:[NSString stringWithFormat:@"%d",(int)indexPath.row]
                                  InfoRect:CGRectMake(0, 8, CardWidth, infoHeight+BusSubCellHeight)
                                DetailRect:CGRectNull
                                 TableRect:CGRectMake(SubTableX, SubTableY, SubTableWidth , BusSubCellHeight+SubTableHeight)];
                
            }
            else
            {
                [busCell setChangViewIndex:[NSString stringWithFormat:@"%d",(int)indexPath.row]
                                  InfoRect:CGRectMake(0, 8, CardWidth, infoHeight+BusSubCellHeight)
                                DetailRect:CGRectMake(0, 8+infoHeight+BusSubCellHeight, CardWidth, 40)
                                 TableRect:CGRectMake(SubTableX, SubTableY, SubTableWidth , BusSubCellHeight+SubTableHeight)];
                
                
            }
            
            cell = busCell;
            
            break;
        case 5:
            noticCell = [tableView dequeueReusableCellWithIdentifier:@"NoticeCell" forIndexPath:indexPath];
            [noticCell setMid:[info objectForKey:@"id"]];
            [noticCell setMCrrentTap:[NSString stringWithFormat:@"%d",(int)index]];
            [noticCell setMRow:[NSString stringWithFormat:@"%d",(int)indexPath.row]];
            [noticCell.mMessage setDelegate:self];
            if ([[info objectForKey:@"bookmark"] isEqualToString:@"N"])
            {
                [noticCell.BookmarkImage setSelected:NO];
            }
            else
            {
                [noticCell.BookmarkImage setSelected:YES];
            }
            
            [noticCell.mTitle setText:[info objectForKey:@"title"]];
            [noticCell.mTitle setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:18.0f]];
            [noticCell.mDate setText:[info objectForKey:@"date"]];
            [noticCell.mMessage setTag:(int)indexPath.row];
            [noticCell setWebViewloadHtml:[info objectForKey:@"message"]];
            
            //noticCell.sizeToFit
            
            [noticCell CellViewReload:[[WebViewHeights objectForKey:[[NSNumber alloc] initWithInteger:indexPath.row]] floatValue]];
            
            cell = noticCell;
            break;

        default:
            break;
    }
   
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark Webview delegates

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if([[WebViewHeights objectForKey:[[NSNumber alloc] initWithInteger: webView.tag]] floatValue] == webView.scrollView.contentSize.height)
        return;
    
    NSArray *arrayItems = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:webView.tag inSection:0], nil];
    [WebViewHeights setObject:[[NSNumber alloc] initWithFloat:webView.scrollView.contentSize.height] forKey:[[NSNumber alloc] initWithInteger: webView.tag]];
    
    [mTableView reloadRowsAtIndexPaths:arrayItems withRowAnimation:UITableViewRowAnimationNone];
    
}

@end
