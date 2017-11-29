//
//  NFIParamPlugin.h
//
//  Created by 최창권(ckchoi@fasol.co.kr) on 12. 10. 22..
//  Copyright (c) 2012 F.A. Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFIParamPlugin : NSObject
{
	NSDictionary* customDic;
}

- (id)init;
- (void)dealloc;
- (id)getParameter:(NSString*)aKey;
- (void)setParameter:(NSString*)aKey value:(id)aValue;
- (NSDictionary*)getCustomDic;
- (void)readyCustomParameter;

@end
