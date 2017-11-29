//
//  ImageScaleViewController.h
//  knu
//
//  Created by VineIT-iMac on 2016. 4. 7..
//  Copyright © 2016년 VineIT-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScaleViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong) UIImage *ImageData;
@property (nonatomic,strong) IBOutlet UIScrollView *ScaleScrollview;
@property (nonatomic,strong) IBOutlet UIImageView *Baseimage;

-(IBAction)Close:(id)sender;

@end
