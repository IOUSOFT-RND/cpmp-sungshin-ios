//
//  ImageScaleViewController.m
//  knu
//
//  Created by VineIT-iMac on 2016. 4. 7..
//  Copyright © 2016년 VineIT-iMac. All rights reserved.
//

#import "ImageScaleViewController.h"

@interface ImageScaleViewController ()

@end

@implementation ImageScaleViewController
@synthesize ImageData,Baseimage,ScaleScrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [ScaleScrollview setZoomScale:1.0f];
    [self.Baseimage setImage:ImageData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ScaleScrollview setZoomScale:1.0f];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [ScaleScrollview setZoomScale:1.0f];
    if (ImageData == nil)
    {
        [self.Baseimage setImage:ImageData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.Baseimage;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view
{
    NSLog(@"scrollViewWillBeginZooming");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    if (scale < 1.0)
    {
        [self.Baseimage setCenter:scrollView.center];
    }
    else
    {
        [self.Baseimage setCenter:CGPointMake(scrollView.center.x*scale, scrollView.center.y*scale)];
    }
    
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidZoom");
    if (scrollView.zoomScale < 1.0)
    {
        [self.Baseimage setCenter:scrollView.center];
    }
    else
    {
        [self.Baseimage setCenter:CGPointMake(scrollView.center.x*scrollView.zoomScale , scrollView.center.y*scrollView.zoomScale )];
    }
}

-(IBAction)Close:(id)sender
{
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

@end
