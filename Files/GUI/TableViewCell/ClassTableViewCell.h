//
//  ClassTableViewCell.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSString *mRow;
@property (nonatomic,retain) NSMutableArray *mTableData;

@property (nonatomic,retain) IBOutlet UITableView *mTableView;

-(void)setChangViewIndex:(NSString *)index InfoRect:(CGRect)rect1 DetailRect:(CGRect)rect2 TableRect:(CGRect)rect3;

@end
