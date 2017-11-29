//
//  NFIParamPlugin.m
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 22..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import "NFIParamPlugin.h"

@implementation NFIParamPlugin

- (id)init
{
	self = [super init];

	//customDic = nil;
	customDic = [[NSMutableDictionary alloc] init];

	return self;
}

- (void)dealloc
{
//	if (customDic != nil)
//		[customDic release];
//	[super dealloc];
}

- (id)getParameter:(NSString*)aKey
{
	return [customDic objectForKey:aKey];
}

- (void)setParameter:(NSString*)aKey value:(id)aValue
{
	[customDic setValue:aValue forKey:aKey];
}

- (NSDictionary*)getCustomDic
{
	return customDic;
}

- (void)readyCustomParameter
{
	NSAssert(NO, @"NEVER CALLED THIS!!! MUST BE IMPLEMENTED!!!");
}

@end
