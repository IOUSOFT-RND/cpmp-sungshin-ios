//
//  FoodTableViewCell.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *mTitle;
@property (nonatomic,retain) IBOutlet UILabel *mPlace;
@property (nonatomic,retain) IBOutlet UILabel *mTime;
@property (nonatomic,retain) IBOutlet UILabel *mPrice;
@property (nonatomic,retain) IBOutlet UILabel *mMenuList;

@end
