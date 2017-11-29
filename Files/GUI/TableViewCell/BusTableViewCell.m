//
//  BusTableViewCell.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "BusTableViewCell.h"

@implementation BusTableViewCell
@synthesize mTableData,TimeList,mRow,mdetailBtn,minfoView,mDetailView,mTitle;

- (void)awakeFromNib {
    // Initialization code
    [self.TimeList setDelegate:self];
    [self.TimeList setDataSource:self];
}


-(void)setChangViewIndex:(NSString *)index InfoRect:(CGRect)rect1 DetailRect:(CGRect)rect2 TableRect:(CGRect)rect3
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            mRow = index;
            [self.minfoView setFrame:rect1];
            [self.TimeList setFrame:rect3];
            
            [self.TimeList setNeedsDisplay];
            [self.minfoView setNeedsDisplay];
            
            if (CGRectIsNull(rect2))
            {
                [self.mDetailView setHidden:YES];
            }
            else
            {
                [self.mDetailView setHidden:NO];
                [self.mDetailView setFrame:rect2];
            }
            
            [self.mdetailBtn addTarget:self action:@selector(BusdetailViewAction) forControlEvents:UIControlEventTouchUpInside];
            [self.mdetailBtn setNeedsDisplay];
            [self.TimeList reloadData];
            [self.contentView  setNeedsDisplay];
            [self setNeedsDisplay];
            
            
        });
    });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)BusRefreshAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BusRefreshAction" object:nil];
}

-(void)BusdetailViewAction
{
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:mRow,@"Row", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BusBordAction" object:nil userInfo:userInfo];
}

#pragma mark -
#pragma mark Table view delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [mTableData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"busTimeCell" forIndexPath:indexPath];
    
    [(UILabel*)[cell.contentView viewWithTag:41]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"STOPTIME1"]];
    [(UILabel*)[cell.contentView viewWithTag:42]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"STOPTIME2"]];
    [(UILabel*)[cell.contentView viewWithTag:43]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"STOPTIME3"]];
    
    return cell;
}
@end
