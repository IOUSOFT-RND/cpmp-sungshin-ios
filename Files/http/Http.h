//
//  Http.h
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumDef.h"
#import "HttpDelegate.h"

@interface Http : NSObject <NSURLConnectionDelegate,UIAlertViewDelegate>
{
    @private
    ActionType actionType;
    NSString *sessionId;
    NSURL *url;
    NSMutableURLRequest *request;
    NSMutableData *responseData;
    NSURLConnection *connection;
    id<HttpDelegate> delegate;
    BOOL terminateThread;
}

@property (nonatomic) ActionType actionType;
@property (nonatomic) NSString *sessionId;
@property (nonatomic) NSURL *url;
@property (nonatomic) NSMutableURLRequest *request;
@property (nonatomic) NSMutableData *responseData;
@property (nonatomic) NSURLConnection *connection;
@property (nonatomic) id<HttpDelegate> delegate;
@property (nonatomic) BOOL terminateThread;

- (id)initWithData:(id<HttpDelegate>)aDelegate;
- (id)initWithData:(id<HttpDelegate>) aDelegate :(ActionType)aAction :(NSString *)aSessionId;
- (void)doSendRequest:(NSString *)aUrl :(NSData *)aData ContentType:(NSString *)contenttype;
- (void)uploadImage:(UIImage *) image :(NSString*) filename :(NSString *)aUrl;

@end
