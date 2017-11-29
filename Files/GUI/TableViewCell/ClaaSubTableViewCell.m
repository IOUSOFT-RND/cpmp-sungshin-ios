//
//  ClaaSubTableViewCell.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 5..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "ClaaSubTableViewCell.h"

@implementation ClaaSubTableViewCell
@synthesize mImage1,mImage2,mPlace,mTime,mTitle;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
}

@end
