//
//  ClassTableViewCell.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 2..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell
@synthesize mRow, mTableData, mTableView;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setChangViewIndex:(NSString *)index InfoRect:(CGRect)rect1 DetailRect:(CGRect)rect2 TableRect:(CGRect)rect3
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 이 블럭은 위 작업이 완료되면 호출된다.
            mRow = index;
            
            [(UIView *)[self.contentView viewWithTag:40] setFrame:rect3];
            [(UIView *)[self.contentView viewWithTag:13] setFrame:rect1];
            if (CGRectIsNull(rect2))
            {
                [(UIView *)[self.contentView viewWithTag:12] setHidden:YES];
            }
            else
            {
                [(UIView *)[self.contentView viewWithTag:12] setHidden:NO];
                [(UIView *)[self.contentView viewWithTag:12] setFrame:rect2];
            }
            
            
            //            [(UIView *)[self.contentView viewWithTag:index] setFrame:rect];
            //            NSLog(@"View Tag = %f",[(UIView *)[self.contentView viewWithTag:index] frame].origin.y);
            //
            
            [(UIButton *)[self.contentView viewWithTag:21] addTarget:self action:@selector(detailViewAction) forControlEvents:UIControlEventTouchUpInside];
            [(UIButton *)[self.contentView viewWithTag:21] setNeedsDisplay];
            [mTableView reloadData];
            [self.contentView  setNeedsDisplay];
            
            
        });
    });
    
}

-(void)detailViewAction
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
    cell = [tableView dequeueReusableCellWithIdentifier:@"lectrueDetailCell" forIndexPath:indexPath];

    [(UILabel*)[cell.contentView viewWithTag:51]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [(UILabel*)[cell.contentView viewWithTag:52]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"prof"]];
    [(UILabel*)[cell.contentView viewWithTag:53]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"time"]];
    [(UILabel*)[cell.contentView viewWithTag:54]  setText:[[mTableData objectAtIndex:indexPath.row] objectForKey:@"room"]];
    
    if ([[[mTableData objectAtIndex:indexPath.row] objectForKey:@"time"] length] > 0)
        [(UIView*)[cell.contentView viewWithTag:61] setHidden:NO];
    else
        [(UIView*)[cell.contentView viewWithTag:61] setHidden:YES];
    
    if ([[[mTableData objectAtIndex:indexPath.row] objectForKey:@"room"] length] > 0)
        [(UIView*)[cell.contentView viewWithTag:62] setHidden:NO];
    else
        [(UIView*)[cell.contentView viewWithTag:62] setHidden:YES];
        
    
    
    if (indexPath.row == [mTableData count]-1)
    {
        [(UIView*)[cell.contentView viewWithTag:72]  setHidden:YES];
    }

    return cell;
}

@end
