//
//  MessageTableViewCell.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell


@property (nonatomic,strong) NSString *mid;
@property (nonatomic,strong) NSString *mRow;
@property (nonatomic,strong) NSString *mCrrentTap;

@property (nonatomic,strong) IBOutlet UIImageView *TitleImage;
@property (nonatomic,strong) IBOutlet UILabel     *TitleLable;
@property (nonatomic,strong) IBOutlet UIButton    *BookmarkImage;
@property (nonatomic,strong) IBOutlet UILabel     *PlaceLable;
@property (nonatomic,strong) IBOutlet UILabel     *DateLable;
@property (nonatomic,strong) IBOutlet UITextView  *Messageview;
@property (nonatomic,strong) IBOutlet UIImageView *backgroundImg;
@property (nonatomic,strong) IBOutlet UIView      *infoview;
@property (nonatomic,strong) IBOutlet UIView      *cellTotalview;

@property (nonatomic,strong) UIImageView *Rich_Image;

@property (nonatomic,strong) IBOutlet UIView      *detailview;
@property (nonatomic,strong) IBOutlet UILabel     *detailLabel;
@property (nonatomic,strong) IBOutlet UIView      *detailLineview;
@property (nonatomic,strong) IBOutlet UIImageView *arrowImg;
@property (nonatomic,strong) IBOutlet UIButton    *detailBtn;
@property (nonatomic,strong) AVPlayerViewController *avplayerCtl;
@property (nonatomic,strong) MPMoviePlayerController *playerCtl;
@property (nonatomic,strong) AVPlayer *player;


-(void)BookMarkSelect;
-(void)detailViewAction;

@end
