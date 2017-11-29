//
//  TotalServiceViewController.h
//  SmartHandong
//
//  Created by VineIT-iMac on 2015. 6. 9..
//  Copyright (c) 2015년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewController,CustomActionSheetViewController;

@interface TotalServiceViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *ViewItem;
    CustomActionSheetViewController *customCtl;
}

@property (nonatomic) IBOutlet UICollectionView *mlistView;

-(IBAction)back:(id)sender;

@end
