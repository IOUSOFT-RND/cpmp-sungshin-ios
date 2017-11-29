//
//  NFIMsg.h
//
//  Created by 원준 김 on 12. 4. 10..
//  Copyright (c) 2012년 kaskaki@chollian.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFIMsg : NSObject
{
	NSString* mId;
	NSString* mRootCommand;
	NSString* mCommand;
	NSString* mCallBack;
	NSDictionary* mArgs;
	NSMutableArray* mPois;
	NSString* mCustParameter;
	NSDictionary* mCustArgs;
}

- (id)init;
- (void)dealloc;
- (NSString*)getId;
- (void)setId:(NSString*)aId;
- (NSString*)getRootCommand;
- (void)setRootCommand:(NSString*)aRootCommand;
- (NSString*)getCommand;
- (void)setCommand:(NSString*)aCommand;
- (NSString*)getCallBack;
- (void)setCallBack:(NSString*)aCallBack;
- (NSDictionary*)getArgList;
- (void)setArgList:(NSDictionary*)aList;
- (id)getArg:(NSString*)aKey;
- (void)setArg:(NSString*)aKey value:(id)aValue;
- (NSString*)getCustParameter;
- (void)setCustParameter:(NSString*)aCustParameter;
- (NSDictionary*)getCustArgDic;
- (void)setCustArgDic:(NSDictionary*)aDic;
- (id)getCustArg:(NSString*)aKey;
- (void)setCustArg:(NSString*)aKey value:(id)aValue;

@end
