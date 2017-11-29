//
//  SimpleLoginViewController.h
//  SmartLauncherSharedCode
//
//  Created by kwangsik.shin on 2014. 11. 4..
//  Copyright (c) 2014년 Arewith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@class CustomActionSheetViewController;

@interface SimpleLoginViewController : UIViewController
{
    CustomActionSheetViewController *customCtl;
}
@property (nonatomic, strong) ServiceInfo * addon;

@property (nonatomic, weak) IBOutlet UIImageView * nameImageView;
@property (nonatomic, weak) IBOutlet UILabel * nameLabel;
@property (nonatomic, weak) IBOutlet UILabel * nameDetailLabel;
@property (nonatomic, weak) IBOutlet UILabel * idLabel;
@property (nonatomic, weak) IBOutlet UIButton * button;

- (IBAction) tapStart:(id)sender;
- (IBAction) tapOutside:(id)sender;

@end
