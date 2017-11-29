//
//  MessageBordTableViewCell.h
//  knu
//
//  Created by VineIT-iMac on 2015. 12. 14..
//  Copyright © 2015년 VineIT-iMac. All rights reserved.
//
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>

@interface MessageBordTableViewCell : UITableViewCell

@property (nonatomic,strong) AVPlayerViewController *avplayerCtl;
@property (nonatomic,strong) MPMoviePlayerController *playerCtl;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) UIImageView *Rich_Image;

@end
