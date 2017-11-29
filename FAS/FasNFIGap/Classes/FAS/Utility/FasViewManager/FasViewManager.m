//
//  FasViewManager.m
//
//  Created by fasolution on 12. 12. 12..
//  Copyright 2012 F.A. Solutions. All rights reserved.
//
//  Javascript에서 Native호출 시 처리하는 함수들을 구현
//  모든 내용들이 기본변경사항이다.

#import "FasViewManager.h"

@implementation FasViewManager

@synthesize mMainView;
@synthesize mSubView;
@synthesize targetDelegate;
@synthesize targetSelector;

static FasViewManager *g_FasViewManager = nil;

- (id)init
{
	self = [super init];

	mMainView = nil;
    mSubView = nil;

    targetDelegate = nil;
    targetSelector = nil;

	return self;
}


- (void)dealloc
{
//	[super dealloc];
}


+ (FasViewManager*)getSharedInstance
{
	if (g_FasViewManager == nil)
	{
		@synchronized(self)
		{
			g_FasViewManager = [[self alloc] init];
		}
	}
	return g_FasViewManager;
}


- (void)setMainView:(id)aView
{
    mMainView = aView;
}


- (id)getMainView
{
    return mMainView;
}


- (void)setSubView:(UIView*)aUIView
{
    mSubView = aUIView;
}


- (UIView*)getSubView
{
    return mSubView;
}


- (void)removeSubView
{
    if(mSubView != nil) {
        [mSubView removeFromSuperview];
        //[mSubView release];
        mSubView = nil;
    }
}


- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    targetDelegate = aTarget;
    targetSelector = aSelector;
}


- (id)getTargetDelegate
{
	return targetDelegate;
}


- (SEL)getTargetSelector
{
	return targetSelector;
}


- (BOOL)isAvailableDelegate
{
	if(targetDelegate != nil && targetSelector != nil) return YES;
	else return NO;
}


@end
