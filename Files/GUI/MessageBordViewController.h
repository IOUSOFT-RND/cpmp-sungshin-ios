//
//  MessageBordViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 13..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class CustomActionSheetViewController,ImageScaleViewController;

@interface MessageBordViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVPlayerViewControllerDelegate>
{
    NSMutableArray *mTableData;
    NSUInteger mdeleteID;
    CustomActionSheetViewController *customCtl;
    ImageScaleViewController *ImageScaleCtl;
    NSMutableDictionary *mImageDic;
    NSMutableDictionary *ImageFailCell;
}

@property (nonatomic,strong) IBOutlet UITableView *mMessageTable;

-(IBAction)back:(id)sender;

@end
