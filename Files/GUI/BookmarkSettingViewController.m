//
//  BookmarkSettingViewController.m
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import "BookmarkSettingViewController.h"
#import "ServiceBookmark.h"
#import "ServiceDb.h"

@interface BookmarkSettingViewController ()

@end

@implementation BookmarkSettingViewController
@synthesize mlistView;

- (void)viewDidLoad {
    [super viewDidLoad];
    ViewItem = [[NSMutableArray alloc] init];
    selectItem = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ViewItem setArray:[ServiceDb getMenuAll]];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"CustomBookmark"] == nil ||
        [[[NSUserDefaults standardUserDefaults] objectForKey:@"CustomBookmark"] isEqualToString:@"NO"])
    {
        startSelectItem = [ServiceDb getBookmarkServiceInfo];
    }
    else
    {
        startSelectItem = [[NSMutableArray alloc] initWithArray:[ServiceBookmark getAll]];
    }

    
    
    [mlistView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)BaseSave:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"CustomBookmark"];
    [ServiceBookmark AllDelete];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)currentSave:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"CustomBookmark"];
    NSMutableArray *item = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [startSelectItem count]; i++)
    {
        ServiceInfo *info = [startSelectItem objectAtIndex:i];
        [item addObject:info];
    }
    [ServiceBookmark AllDelete];
    [ServiceBookmark Transaction:item];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ViewItem count];
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 재사용 큐에 셀을 가져온다
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    ServiceInfo *info = [ViewItem objectAtIndex:indexPath.row];
    
    
    
    // 표시할 이미지 설정
    UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
    if (imgView)
    {
        NSURL *url = [NSURL URLWithString:[info.mIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        imgView.image = image;
    }
    
    UILabel* LabelView = (UILabel*)[cell.contentView viewWithTag:11];
    [LabelView setTextColor:[UIColor whiteColor]];
    
    if (LabelView)
        LabelView.text = info.name;
    
    
    for (int i =0; i < [startSelectItem count]; i++)
    {
        ServiceInfo *startInfo = [startSelectItem objectAtIndex:i];
        if([info.Id isEqualToString:startInfo.Id] )
        {            
            UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
            [(UILabel*)[cell.contentView viewWithTag:11] setTextColor:[UIColor whiteColor]];
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
            cell.layer.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:50.0f/255.0f blue:49.0f/255.0f alpha:1.0f].CGColor;
            
            [LabelView setTextColor:[UIColor whiteColor]];
            [info setMTableIndex:indexPath];
            [startSelectItem replaceObjectAtIndex:i withObject:info];
        }
    }

    
    return cell;
}

//====================================================================================================//
#pragma mark - UICollectionViewDelegate

// 선택
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//	return YES;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];

    ServiceInfo *SelectInfo = [ViewItem objectAtIndex:indexPath.row];
    [SelectInfo setMTableIndex:indexPath];
    
    BOOL findState = false;
    
    if ([startSelectItem containsObject:SelectInfo])
    {
        NSLog(@"find Item");
        for (int i =0; i < [startSelectItem count]; i++)
        {
            ServiceInfo *info = [startSelectItem objectAtIndex:i];
            if (info.mTableIndex.row  == indexPath.row)
            {
                findState = true;
                cell = [collectionView cellForItemAtIndexPath:info.mTableIndex];
                [(UILabel*)[cell.contentView viewWithTag:11] setTextColor:[UIColor whiteColor]];
                UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
                if (imgView)
                {
                    NSURL *url = [NSURL URLWithString:[((ServiceInfo *)[ViewItem objectAtIndex:indexPath.row]).mIcon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
                    imgView.image = image;
                }
                

                cell.layer.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:54.0f/255.0f blue:54.0f/255.0f alpha:1.0f].CGColor;
                continue;
            }
            
            if (findState)
            {
                cell = [collectionView cellForItemAtIndexPath:info.mTableIndex];
                [(UILabel*)[cell.contentView viewWithTag:11] setTextColor:[UIColor whiteColor]];
                UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i]];
                cell.layer.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:50.0f/255.0f blue:49.0f/255.0f alpha:1.0f].CGColor;
            }
            else
            {
                cell = [collectionView cellForItemAtIndexPath:info.mTableIndex];
                [(UILabel*)[cell.contentView viewWithTag:11] setTextColor:[UIColor whiteColor]];
                UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
                imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",i+1]];
                cell.layer.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:50.0f/255.0f blue:49.0f/255.0f alpha:1.0f].CGColor;
            }
            
        }
        
        [startSelectItem removeObject:SelectInfo];
    }
    else
    {
        if ([selectItem count] >= 9)
        {
            return;
        }
        
        [SelectInfo setMTableIndex:indexPath];
        [startSelectItem addObject:SelectInfo];
        
        [(UILabel*)[cell.contentView viewWithTag:11] setTextColor:[UIColor whiteColor]];
        UIImageView* imgView = (UIImageView*)[cell.contentView viewWithTag:10];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",(int)[startSelectItem count]]];
        UILabel* LabelView = (UILabel*)[cell.contentView viewWithTag:11];
        [LabelView setTextColor:[UIColor whiteColor]];
        cell.layer.backgroundColor = [UIColor colorWithRed:214.0f/255.0f green:50.0f/255.0f blue:49.0f/255.0f alpha:1.0f].CGColor;
    }

}



// 셀이 삭제되거나 보이지 않는 영역으로 이동했을때
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
