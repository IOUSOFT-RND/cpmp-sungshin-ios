//
//  MessageBordTableViewCell.m
//  knu
//
//  Created by VineIT-iMac on 2015. 12. 14..
//  Copyright © 2015년 VineIT-iMac. All rights reserved.
//

#import "MessageBordTableViewCell.h"

@implementation MessageBordTableViewCell
@synthesize avplayerCtl,playerCtl,player,Rich_Image;

- (void)awakeFromNib {
    // Initialization code
    avplayerCtl = [[AVPlayerViewController alloc] init];
    playerCtl= [[MPMoviePlayerController alloc] init];
    Rich_Image = [[UIImageView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
