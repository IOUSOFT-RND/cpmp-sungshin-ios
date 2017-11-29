//
//  NFIMsg.m
//
//  Created by 원준 김 on 12. 4. 10..
//  Copyright (c) 2012년 kaskaki@chollian.net. All rights reserved.
//

#import "NFIMsg.h"

@implementation NFIMsg

- (id)init
{
	mId = @"";
	mRootCommand = @"";
	mCommand = @"";
	mCallBack = @"";
	mArgs = [[NSMutableDictionary alloc] init];
	mPois = [[NSMutableArray alloc] init];
	
	mCustParameter = nil;
	mCustArgs = [[NSMutableDictionary alloc] init];
	self = [super init];
	
	return self;
}

- (void)dealloc
{
//	[mId release];
//	[mRootCommand release];
//	[mCommand release];
//	[mCallBack release];
//	[mArgs release];
//	[mPois release];
//	[super dealloc];
}

- (NSString*)getId
{
	return mId;
}

- (void)setId:(NSString*)aId
{
	mId = [[aId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString*)getRootCommand
{
	return mRootCommand;
}

- (void)setRootCommand:(NSString*)aRootCommand
{
	mRootCommand = [[aRootCommand stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString*)getCommand
{
	return mCommand;
}

- (void)setCommand:(NSString*)aCommand
{
	mCommand = [[aCommand stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSString*)getCallBack
{
	return mCallBack;
}

- (void)setCallBack:(NSString*)aCallBack
{
	mCallBack = [[aCallBack stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSDictionary*)getArgList
{
	return mArgs;
}

- (void)setArgList:(NSDictionary*)aList
{
//	[mArgs release];
	mArgs = [aList copy];
}

- (id)getArg:(NSString*)aKey
{
	return [mArgs objectForKey:aKey];
}

- (void)setArg:(NSString*)aKey value:(id)aValue
{
	[mArgs setValue:aValue forKey:aKey];
}

- (NSString*)getCustParameter
{
	return mCustParameter;
}

- (void)setCustParameter:(NSString*)aCustParameter
{
	mCustParameter = [[aCustParameter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] copy];
}

- (NSDictionary*)getCustArgDic
{
	return mCustArgs;
}

- (void)setCustArgDic:(NSDictionary*)aDic;
{
//	[mCustArgs release];
	mCustArgs = [aDic copy];
}

- (id)getCustArg:(NSString*)aKey
{
	return [mCustArgs objectForKey:aKey];
}

- (void)setCustArg:(NSString*)aKey value:(id)aValue
{
	[mCustArgs setValue:aValue forKey:aKey];
}

@end
