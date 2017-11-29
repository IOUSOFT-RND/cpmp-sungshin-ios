//
//  FNPLoadingBar.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 12. 14..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FNPLoadingBar.h"
#import "NFIParamPlugin.h"

@implementation FNPLoadingBar

- (void)execute
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPLoadingBar.execute");
#endif
	NSAssert(NO, @"NEVER CALLED THIS!!! MUST BE IMPLEMENTED!!!");
//	[self autorelease];
}


- (void)showLoadingBar
{
#ifdef DEBUG
    NSLog(@"@FAS@|FNPLoadingBar.showLoadingBar");
#endif
/*
	if (mWebView == nil) {
		return;
	}

	CGRect redFrame = [[UIScreen mainScreen] bounds];
	UIView *loadingView = [[UIView alloc] initWithFrame:redFrame];
	//loadingView.backgroundColor = [UIColor redColor];
	loadingView.tag = 999;

	UIImage *indImage = nil;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //indImage = BundleImage(@"indicator", @"png");
		indImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]] retain];
		
    } else {
        indImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]] retain];
    }

    UIImageView *indiView = [[UIImageView alloc] initWithImage:indImage];
    [indiView setCenter:loadingView.center];
	[loadingView addSubview:indiView];

	loadingView.opaque = NO;
	loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[mWebView addSubview:loadingView];

	UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    
    [activityIndicatorView setColor:[UIColor redColor]];
    
	[loadingView addSubview:activityIndicatorView];
	
	[activityIndicatorView startAnimating];
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;

    activityIndicatorRect.origin.x = indiView.frame.origin.x+83;
    activityIndicatorRect.origin.y = indiView.frame.origin.y+36;
    activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[mWebView layer] addAnimation:animation forKey:@"layerAnimation"];

	[loadingView release];
*/
	
	
	//[self loadingViewInView:mWebView];
	
	if (mMainView == nil) {
		return;
	}

	UIView *loadingView =
//	[[[UIView alloc] initWithFrame:[mMainView bounds]] autorelease];
	[[UIView alloc] initWithFrame:[mMainView bounds]];
	
	//loadingView.backgroundColor = [UIColor redColor];
	loadingView.tag = 999;

	/*
	 loadingView.boxLength = boxLength;
	 loadingView.strokeOpacity = strokeOpacity;
	 loadingView.backgroundOpacity = backgroundOpacity;
	 loadingView.strokeColor = strokeColor;
	 loadingView.fullScreen = fullScreen;
	 loadingView.bounceAnimation = bounceAnimation;
	 */
	UIImage *indImage = nil;
    
	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //indImage = BundleImage(@"indicator", @"png");
//		indImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]] retain];
		indImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]];
		
    } else {
//        indImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]] retain];
        indImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"indicator" ofType:@"png"]];
    }
	/*
	 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	 indImage = BundleImage(@"indicator", @"png");
	 } else {
	 indImage = BundleImage(@"indicator", @"png");
	 }
	 */
    UIImageView *indiView = [[UIImageView alloc] initWithImage:indImage];
    [indiView setCenter:loadingView.center];
	[loadingView addSubview:indiView];
	
	loadingView.opaque = NO;
	loadingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[mMainView addSubview:loadingView];
	/*
	 const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
	 const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	 CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	 
	 loadingView.textLabel = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	 loadingView.textLabel.text = labelText;
	 loadingView.textLabel.textColor = strokeColor;
	 loadingView.textLabel.backgroundColor = [UIColor clearColor];
	 loadingView.textLabel.textAlignment = UITextAlignmentCenter;
	 loadingView.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	 loadingView.textLabel.autoresizingMask =
	 UIViewAutoresizingFlexibleLeftMargin |
	 UIViewAutoresizingFlexibleRightMargin |
	 UIViewAutoresizingFlexibleTopMargin |
	 UIViewAutoresizingFlexibleBottomMargin;
	 
	 [loadingView addSubview:loadingView.textLabel];
	 */
//	UIActivityIndicatorView *activityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [activityIndicatorView setColor:[UIColor redColor]];
    
	[loadingView addSubview:activityIndicatorView];
	/*
	 activityIndicatorView.autoresizingMask =
	 UIViewAutoresizingFlexibleLeftMargin |
	 UIViewAutoresizingFlexibleRightMargin |
	 UIViewAutoresizingFlexibleTopMargin |
	 UIViewAutoresizingFlexibleBottomMargin;
     */
	[activityIndicatorView startAnimating];
	
    /*
	 CGFloat totalHeight = loadingView.textLabel.frame.size.height + activityIndicatorView.frame.size.height;
	 labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	 labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
	 loadingView.textLabel.frame = labelFrame;
	 */
    /*
	 CGRect activityIndicatorRect = activityIndicatorView.frame;
	 activityIndicatorRect.origin.x = 0.5 * (loadingView.frame.size.width - activityIndicatorRect.size.width);
	 activityIndicatorRect.origin.y = loadingView.textLabel.frame.origin.y + loadingView.textLabel.frame.size.height;
	 activityIndicatorView.frame = activityIndicatorRect;
     */
    
    CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.origin.x = indiView.frame.origin.x+83;
    activityIndicatorRect.origin.y = indiView.frame.origin.y+36;
    activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[mMainView layer] addAnimation:animation forKey:@"layerAnimation"];

	[self processCallBack];
}


- (void)hideLoadingBar
{
#ifdef DEBUG
    NSLog(@"@FAS@|FNPLoadingBar.hideLoadingBar");
#endif

	if(mMainView == nil) {
		return;
	}

	[[mMainView viewWithTag:999] removeFromSuperview];
	
	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[mMainView layer] addAnimation:animation forKey:@"layerAnimation"];

	[self processCallBack];
}


@end
