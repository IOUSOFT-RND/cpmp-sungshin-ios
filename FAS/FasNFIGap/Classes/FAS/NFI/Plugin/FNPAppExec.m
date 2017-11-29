//
//  FNPAppExec.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 12. 14..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FNPAppExec.h"
#import "NFIParamPlugin.h"
#import "FasPushControl.h"

@implementation FNPAppExec


- (void)execute
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPAppExec.execute");
#endif
	NSAssert(NO, @"NEVER CALLED THIS!!! MUST BE IMPLEMENTED!!!");
//	[self autorelease];
}


- (void)appExec
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPAppExec.appExec");
#endif
    NSString* className = [mMsg getArg:@"classname"];
    
    if (className != nil && [className length] != 0)
    {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:className]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:className]];
            [self setReturnVal:@"succ"];
        }
        else
        {
            [self setReturnVal:@"error"];
            [self setReturnMsg:@"not exist"];
        }
        [self processCallBack];
        return;
    }
}


- (void)openBrowser
{
#ifdef DEBUG
	NSLog(@"@FAS@|FNPAppExec.openBrowser");
#endif

    NSString* url = [mMsg getArg:@"url"];

    if(![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"]) {
        url = [@"http://" stringByAppendingString:url];
    }

    if (url != nil && [url length] != 0)
    {
        /*
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            [self setReturnVal:@"succ"];
            [self processCallBack];
            return;
        }
         */
        
        FasPushControl* fasPushControl = [FasPushControl getSharedInstance];
        [fasPushControl moveToLandingUrl:url];
        
    } else {
        NSLog(@"@FAS@|FNPAppExec.openBrowser : cannot move to url");
    }
    
    /*

	[self setReturnVal:@"error"];
    [self setReturnMsg:@"url is empty"];
    [self processCallBack];
     */
}


@end
