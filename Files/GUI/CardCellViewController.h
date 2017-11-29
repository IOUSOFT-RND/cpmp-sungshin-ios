//
//  CardCellViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 12..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageTableViewCell,NoticeTableViewCell,BusTableViewCell,FoodTableViewCell,ClassTableViewCell;

@interface CardCellViewController : UIViewController<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *TableCellData;
    NSMutableDictionary *WebViewHeights;
    NSMutableDictionary *WebImages;
    int mBookmarkRow;

}

@property (nonatomic,retain) IBOutlet UITableView *mTableView;
@property (nonatomic,retain) IBOutlet UIWebView *mprewebView;

@property (nonatomic,assign) NSInteger index;

@end
