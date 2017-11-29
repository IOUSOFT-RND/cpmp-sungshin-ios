//
//  MessageTableViewCell.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
@synthesize backgroundImg,Messageview,infoview,detailview,cellTotalview;
@synthesize TitleImage,TitleLable,PlaceLable,DateLable,BookmarkImage,Rich_Image;
@synthesize detailBtn,detailLineview,detailLabel,arrowImg;
@synthesize mid,mCrrentTap,mRow;
@synthesize playerCtl,player,avplayerCtl;


- (void)awakeFromNib {
    // Initialization code
    int CardWidth = 0;
    int infoWidth = 0;
    int bookmark = 0;
    int DateXPos = 0;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.width == 320.0)
        {
            CardWidth = 300;
            infoWidth = 286;
            bookmark = 255;
            DateXPos = 162;
        }
        else if([[UIScreen mainScreen] bounds].size.width == 375.0)
        {
            CardWidth = 355;
            infoWidth = 337;
            bookmark = 307;
            DateXPos = 217;

        }
        else//414
        {
            CardWidth = 388;
            infoWidth = 368;
            bookmark = 338;
            DateXPos = 248;
        }
    }

    cellTotalview = [[UIView alloc] initWithFrame:CGRectZero];
    infoview = [[UIView alloc] initWithFrame:CGRectMake(10, 19, infoWidth, 100)];
    detailview = [[UIView alloc] initWithFrame:CGRectMake(0, 119, CardWidth, 45)];
    
    backgroundImg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 400, 50, 28)];
    Messageview = [[UITextView alloc] initWithFrame:CGRectMake(10, 62, 20, 20)];
    [Messageview setEditable:NO];
    [Messageview setSelectable:NO];
    [Messageview setScrollEnabled:NO];
    Rich_Image = [[UIImageView alloc] init];
    
    TitleLable = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 216, 21)];
    [TitleLable setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:20.0f]];
    
    TitleImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [TitleImage setImage:[UIImage imageNamed:@"ico_card_bullet05.png"]];
    
    PlaceLable = [[UILabel alloc] initWithFrame:CGRectMake(6, 37, 144, 20)];
    [PlaceLable setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f]];
    
    DateLable = [[UILabel alloc] initWithFrame:CGRectMake(DateXPos, 39, 112, 16)];
    [DateLable setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:13.0f]];
    [DateLable setTextAlignment:NSTextAlignmentRight];
    
    BookmarkImage = [[UIButton alloc] initWithFrame:CGRectMake(bookmark, 0, 50, 50)];
    [BookmarkImage setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [BookmarkImage setImage:[UIImage imageNamed:@"ico_card_fav_off.png"] forState:UIControlStateNormal];
    [BookmarkImage setImage:[UIImage imageNamed:@"ico_card_fav_on.png"] forState:UIControlStateSelected];
    [BookmarkImage addTarget:self action:@selector(BookMarkSelect) forControlEvents:UIControlEventTouchUpInside];

    detailLineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CardWidth, 1)];
    detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CardWidth, 45)];
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 11, 70, 24)];
    [detailLabel setText:@"상세보기"];
    [detailLabel setFont:[UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:20.0f]];
    [detailLabel setTextColor:[UIColor colorWithRed:240.0f/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:1.0f]];
    
    arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(93, 15, 15, 15)];
    [arrowImg setImage:[UIImage imageNamed:@"ico_card_link.png"]];
    
    [cellTotalview setBackgroundColor:[UIColor whiteColor]];
    [infoview setBackgroundColor:[UIColor clearColor]];
    [backgroundImg setBackgroundColor:[UIColor clearColor]];
    [Messageview setBackgroundColor:[UIColor clearColor]];
    [TitleLable setBackgroundColor:[UIColor clearColor]];
    [TitleImage setBackgroundColor:[UIColor clearColor]];
    [PlaceLable setBackgroundColor:[UIColor clearColor]];
    [DateLable setBackgroundColor:[UIColor clearColor]];
    [BookmarkImage setBackgroundColor:[UIColor clearColor]];
    [detailview setBackgroundColor:[UIColor clearColor]];
    [detailLineview setBackgroundColor:[UIColor colorWithRed:224.0f/255.0f green:224.0f/255.0f blue:225.0f/255.0f alpha:1.0f]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [arrowImg setBackgroundColor:[UIColor clearColor]];
    [detailBtn setBackgroundColor:[UIColor clearColor]];
    
    [detailBtn addTarget:self action:@selector(detailViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    avplayerCtl = [[AVPlayerViewController alloc] init];
    playerCtl = [[MPMoviePlayerController alloc] init];
    Rich_Image = [[UIImageView alloc] init];
    
    [self addSubview:cellTotalview];
    [self.cellTotalview addSubview:infoview];
    [self.cellTotalview addSubview:BookmarkImage];
    [self.infoview addSubview:TitleLable];
    [self.infoview addSubview:TitleImage];
    [self.infoview addSubview:PlaceLable];
    [self.infoview addSubview:DateLable];
    
    [self.infoview addSubview:backgroundImg];
    [self.infoview addSubview:Messageview];
    [self.cellTotalview addSubview:detailview];
    [self.detailview addSubview:detailLineview];
    [self.detailview addSubview:detailLabel];
    [self.detailview addSubview:arrowImg];
    [self.detailview addSubview:detailBtn];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)BookMarkSelect
{
    NSString *isSelect = @"N";
    if ([BookmarkImage isSelected])
    {
        NSLog(@"isNormal");
        [BookmarkImage setImage:[UIImage imageNamed:@"ico_card_fav_on.png"] forState:UIControlStateHighlighted];
        [BookmarkImage setSelected:NO];
        isSelect = @"N";
    }
    else
    {
        NSLog(@"isSelected");
        [BookmarkImage setImage:[UIImage imageNamed:@"ico_card_fav_off.png"] forState:UIControlStateHighlighted];
        [BookmarkImage setSelected:YES];
         isSelect = @"Y";
    }
    [self BookMarkAction:isSelect];
}


-(void)detailViewAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageBordAction" object:nil];
}

- (void)BookMarkAction:(NSString *)state
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:mRow,@"Row",mCrrentTap,@"CrrentTap",mid,@"msgid",@"01",@"msgtype",state,@"bookmark", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BookmarkActionNoti" object:nil userInfo:userInfo];
    
}

@end
