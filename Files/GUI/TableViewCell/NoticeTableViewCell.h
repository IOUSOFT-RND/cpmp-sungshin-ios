//
//  NoticeTableViewCell.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell<UIWebViewDelegate,UITextViewDelegate>
{
    float cardWidth;
    float mMesssageWidth;
}
@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *mRow;
@property (nonatomic,strong) NSString *mCrrentTap;

@property (nonatomic,retain) IBOutlet UITextView *mTitle;
@property (nonatomic,retain) IBOutlet UIWebView *mMessage;
@property (nonatomic,retain) IBOutlet UILabel *mDate;
@property (nonatomic,retain) IBOutlet UIImageView *mDateIcon;
@property (nonatomic,retain) IBOutlet UIView *mBackgroundView;
@property (nonatomic,retain) IBOutlet UIView *mDetailView;
@property (nonatomic,strong) IBOutlet UIButton    *BookmarkImage;

-(void)setWebViewloadHtml:(NSString *)url;
-(void)CellViewReload:(float)Height;
-(void)BookMarkSelect:(id)sender;
-(IBAction)detailViewAction:(id)sender;

@end
