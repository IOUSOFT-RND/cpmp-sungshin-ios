//
//  Http.m
//  emdm
//
//  Created by kdsooi on 13. 7. 22..
//  Copyright (c) 2013년 kdsooi. All rights reserved.
//

#import "Http.h"
#import "Action+Type.h"
#import "Json.h"

#define CONTENT_TYPE_HDU_REQUEST @"application/slucore.request+json"


@implementation Http
@synthesize actionType;
@synthesize sessionId;
@synthesize url;
@synthesize request;
@synthesize responseData;
@synthesize connection;
@synthesize delegate;
@synthesize terminateThread;

- (id)initWithData:(id<HttpDelegate>)aDelegate :(ActionType)aAction :(NSString *)aSessionId
{
    self = [super init];
    if (!self)
        return nil;
    
    self.actionType = aAction;
    self.sessionId = aSessionId;
    self.delegate = aDelegate;
    
    return self;
}

- (id)initWithData:(id<HttpDelegate>)aDelegate
{
    self = [super init];
    if (!self)
        return nil;
    
    self.delegate = aDelegate;
    
    return self;
}

- (void)doSendRequest:(NSString *)aUrl :(NSData *)aData ContentType:(NSString *)contenttype
{
    NSLog(@"url : %@", aUrl);
 
    if (!aUrl)
    {
        NSLog(@"aUrl == nil");
        return;
    }
    
    url = [NSURL URLWithString:aUrl];
    
    request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:contenttype forHTTPHeaderField:@"Content-Type"];
    [request setValue:CONTENT_TYPE_HDU_REQUEST forHTTPHeaderField:@"Accept"];
    [request setValue:[url host] forHTTPHeaderField:@"Host"];
    [request setHTTPBody:aData];
    
    terminateThread = NO;
    
    NSThread* connectionThread = [[NSThread alloc] initWithTarget:self selector:@selector(connectionLoop:) object:request];
    [connectionThread start];
}

- (void)uploadImage:(UIImage *) image :(NSString*) filename :(NSString *)aUrl
{
	NSData *imageData = UIImageJPEGRepresentation(image, 1);
    url = [NSURL URLWithString:aUrl];
   	request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
    
	
	NSString *boundary = @"0xKhTmLbOuNdArY";  // important!!!
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	
	NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"images\"; filename=\"%@\"\r\n",filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[NSData dataWithData:imageData]];
	[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:body];
	
   	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	
    if([self stringFromContain:returnString :@"fail"])
    {
        NSLog(@"fail\n");
    }
}

- (void)connectionLoop:(NSMutableURLRequest*)aRequest
{
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    while (!terminateThread)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    NSLog(@"connection didReceiveResponse");
    NSLog(@"textEncodingName = %@",[response MIMEType]);
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    NSLog(@"connection didReceiveData");
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    NSLog(@"connection willCacheResponse");
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"connectionDidFinishLoading");
    
    if (delegate && [delegate respondsToSelector:@selector(Http:didFinish:)])
    {
        [delegate Http:self didFinish:responseData];
    }
    NSDictionary *responseDic = [Json decodeHttps:responseData];
    if ([responseDic objectForKey:@"RESULT_CODE"] )
    {
        NSLog(@"[Log]Data RESULT_CODE = %@",[responseDic objectForKey:@"RESULT_CODE"] );
    }
    
    terminateThread = YES;

}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return YES;
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"[https]didReceiveAuthenticationChallenge");
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"[https]willSendRequestForAuthenticationChallenge");
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"connection didFailWithError");
    
    if (delegate && [delegate respondsToSelector:@selector(Http:didFialWithError:)])
    {
        [delegate Http:self didFialWithError:error];
        
    }
    
    terminateThread = YES;
}


- (BOOL)stringFromContain:(NSString *) BaseString :(NSString *) serchString
{
    if([BaseString length] < 1)
    {
        return false;
    }
    
    NSRange textRangs = [BaseString rangeOfString:serchString];
    
    if (textRangs.location == NSNotFound)
    {
        return false;
    }
    
    return true;
}



@end
