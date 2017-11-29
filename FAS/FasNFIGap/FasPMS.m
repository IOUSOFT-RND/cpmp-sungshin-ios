//
//  FasPMS.h
//
//  Created by fasolution on 12. 12. 12..
//  Copyright 2011 F.A. Solutions. All rights reserved.
//
//  IOS Native에서 NFI Native호출 시 처리하는 함수들을 선언
//  모든 내용들이 기본변경사항이다.

#import "FasNFIGap.h"
#import "FasPMS.h"
#import "NFIMsg.h"

@implementation FasPMS

- (id)init
{
    self = [super init];
    
    return self;
}


- (void)dealloc
{
//    [super dealloc];
}


- (void)startView
{
	/*
	{"id":"FPNS","rootcmd":"PushBox","cmd":"startView"
		,"custparam":"FASPushBoxCustomParam"
		,"param":{"url":"push/html/cardPushbox.html",
			"callbackFunction":"pushboxCallback"
			,"AndroidClassName":"com.financeallsolution.push.PushActivity"
			,"custparam":"FASPushBoxCustomParam"}}
	
	*/
	
	
	NFIMsg* msg = [[NFIMsg alloc] init];
	[msg setId:@"FPNS"];                  // id
	[msg setRootCommand:@"PushBox"];      // rootcmd
	[msg setCommand:@"startView"];        // cmd

	[msg setCallBack:nil];        // callback
	[msg setCustParameter:@"custparam"];  // custparam

/*
	NSDictionary* param = (NSDictionary*)[dic objectForKey:@"param"];
	for (NSString* key in param)
	{
		if ([key compare:@"poi"] == 0)
		{
			[msg setArg:key value:[param objectForKey:@"poi"]];
		}
		else
		{
			[msg setArg:key value:[param objectForKey:key]];
		}
	}
*/
//	NSMutableDictionary* param = [[[NSMutableDictionary alloc] init] autorelease];
	NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
		
	[param setObject:@"push/html/cardPushbox.html"   forKey:@"url"];
	[param setObject:@"pushboxCallback"   forKey:@"callbackFunction"];
	//[param setObject:@"FASPushBoxCustomParam"   forKey:@"custparam"];

	for (NSString* key in param)
	{
		if ([key compare:@"poi"] == 0)
		{
			[msg setArg:key value:[param objectForKey:@"poi"]];
		}
		else
		{
			[msg setArg:key value:[param objectForKey:key]];
		}
	}
	
	
	
	NSLog(@"--------------------------1");
    //[[FasNFIGap getSharedInstance] parsingMessage:nil setNFIMsg:msg];
	NSLog(@"--------------------------2");
}



@end
