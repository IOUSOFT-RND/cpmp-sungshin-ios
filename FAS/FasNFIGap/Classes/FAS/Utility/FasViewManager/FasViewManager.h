//
//  FasViewManager.h
//
//  Created by fasolution on 12. 12. 12..
//  Copyright 2012 F.A. Solutions. All rights reserved.
//
//  메인뷰와 서브뷰 간의 처리를 관리하고 담당하는 cLASS

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FasViewManager : NSObject
{
//	id mMainView;
//	UIView *mSubView;

//	id targetDelegate;
	SEL targetSelector;
}

- (id)init;
- (void)dealloc;
+ (FasViewManager*)getSharedInstance;
- (void)setMainView:(id)aView;
- (id)getMainView;
- (void)setSubView:(UIView*)aUIView;
- (UIView*)getSubView;
- (void)removeSubView;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (id)getTargetDelegate;
- (SEL)getTargetSelector;
- (BOOL)isAvailableDelegate;

@property (nonatomic, assign) id mMainView;
@property (nonatomic, assign) UIView *mSubView;
@property (nonatomic, assign) id targetDelegate;
@property (nonatomic, assign) SEL targetSelector;

@end
