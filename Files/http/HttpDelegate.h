//
//  HttpDelegate.h
//  emdm
//
//  Created by kdsooi on 13. 8. 2..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Http;

@protocol HttpDelegate <NSObject>

- (void)Http:(Http *)aHttp didFinish:(NSMutableData *)aData;
- (void)Http:(Http *)aHttp didFialWithError:(NSError *)aError;

@end
