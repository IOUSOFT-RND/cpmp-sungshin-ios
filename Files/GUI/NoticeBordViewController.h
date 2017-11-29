//
//  NoticeBordViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 13..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomActionSheetViewController;

@interface NoticeBordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSMutableArray *mTableData;
    NSMutableArray *mSeleteData;
    CustomActionSheetViewController *customCtl;

}
//@property (nonatomic,strong) IBOutlet UITableView *mNoticeTable;
@property (nonatomic,strong) IBOutlet UIWebView *mNoticWeb;

-(IBAction)back:(id)sender;
//-(IBAction)openBtnAction:(id)sender;

@end
