//
//  BookmarkSettingViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 7. 11..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookmarkSettingViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *selectItem;
    NSMutableArray *ViewItem;
    NSMutableArray *startSelectItem;
}

@property (nonatomic) IBOutlet UICollectionView *mlistView;

-(IBAction)back:(id)sender;
-(IBAction)BaseSave:(id)sender;
-(IBAction)currentSave:(id)sender;


@end
