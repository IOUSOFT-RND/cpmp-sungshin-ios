//
//  NoticeTableViewCell.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "NoticeTableViewCell.h"

@implementation NoticeTableViewCell
@synthesize mMessage,mTitle,mDate,mDetailView,mBackgroundView,BookmarkImage,mid,mCrrentTap;
@synthesize mRow,mDateIcon;

- (void)awakeFromNib {
    // Initialization code
    mMessage.delegate = self;
    mTitle.delegate = self;
}

-(IBAction)BookMarkSelect:(id)sender
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

-(IBAction)detailViewAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeBordAction" object:nil];
}

- (void)BookMarkAction:(NSString *)state
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:mRow,@"Row",mCrrentTap,@"CrrentTap",mid,@"msgid",@"05",@"msgtype",state,@"bookmark", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BookmarkActionNoti" object:nil userInfo:userInfo];
    
}

-(void)setWebViewloadHtml:(NSString *)url
{
    NSString *headerString = @"<head><style>img{max-width:100%; width:auto; height:auto;}</style></head>";
    
    [self.mMessage loadHTMLString:[NSString stringWithFormat:@"<html>%@<body>%@</body></html>",headerString,url] baseURL:nil ];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellViewReload:(float)Height
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.width == 320.0)
        {
            cardWidth = 304;
            mMesssageWidth = 282;
        }
        else if([[UIScreen mainScreen] bounds].size.width == 375.0)
        {
            cardWidth = 359;
            mMesssageWidth = 337;
            
        }
        else//414
        {
            cardWidth = 398.0f;
            mMesssageWidth = 363.0f;
        }
    }

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mBackgroundView setFrame:CGRectMake(0, 8, cardWidth, 145.0f+Height)];
            [self.mMessage setFrame:CGRectMake(0, 58, mMesssageWidth, Height)];
            [self.mDate setFrame:CGRectMake(21, 66+Height, 115, 15)];
            [self.mDateIcon setFrame:CGRectMake(0, 66+Height, 15, 15)];
            
            [self.mBackgroundView setNeedsDisplay];
            [self.mMessage setNeedsDisplay];
            [self.mDate setNeedsDisplay];
            [self.mDateIcon setNeedsDisplay];
            [self.contentView setNeedsDisplay];
            [self setNeedsDisplay];
            
            [self.mDetailView setFrame:CGRectMake(0, 108.0f+Height, cardWidth, 45)];
            
            [self.mDetailView setNeedsDisplay];
            [self bringSubviewToFront:self.mDetailView];
            [self.contentView setNeedsDisplay];
            [self setNeedsDisplay];
            
        });
    });
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
}



@end
