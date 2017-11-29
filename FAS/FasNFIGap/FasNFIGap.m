//
//  FasNFIGap.m
//
//  Created by fasolution on 11. 1. 4..
//  Copyright 2011 F.A. Solutions. All rights reserved.
//
//  Javascript에서 Native호출 시 처리하는 함수들을 구현
//  모든 내용들이 기본변경사항이다.

#import "FasNFIGap.h"
#import "FasJSON.h"
#import "NFIPlugin.h"
#import "NFIParamPlugin.h"

@implementation FasNFIGap

static FasNFIGap* g_FasNFIGap = nil;

- (id)init
{
    self = [super init];

    mMainWebView = nil;
    mMainView    = nil;
    mWebView     = nil;
    mView        = nil;
    
    return self;
}

- (void)dealloc
{
//    [super dealloc];
}

+ (FasNFIGap*)getSharedInstance
{
    if (g_FasNFIGap == nil)
    {
        @synchronized(self)
        {
            g_FasNFIGap = [[self alloc] init];
        }
    }
    return g_FasNFIGap;
}

- (void)setWebView:(UIWebView*)aWebView nativeBridgeForWebView:(NSURLRequest*)request
{
#ifdef DEBUG
    NSLog(@"@FAS@|FasNFI setWebView,nativeBridgeForWebView");
#endif
    mWebView = aWebView;

    NSURL *url = [request URL];

#ifdef DEBUG
    NSLog(@"@FAS@|call url : %@",url);
#endif

    if ([[url scheme] isEqualToString:@"gap"]) {
        NSLog(@"@FAS@|call fas nfi gap!!!!");
        [self flushCommandQueueFromWebView:mWebView];
    } else if ([[url scheme] isEqualToString:@"fpms-url-link"]) {
        NSLog(@"@FAS@|call fpms-url-link!!!!");
    }
/*
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString isEqualToString:@"gap://fasnfiready"]) {
        NSLog(@"call urlString!!!!");
        [self flushCommandQueue];
    }
*/
}

/**
 * Repeatedly fetches and executes the command queue until it is empty.
 */
- (void)flushCommandQueueFromWebView:(UIWebView*)selWebView
{
#ifdef DEBUG
    NSLog(@"@FAS@|FasNFI flushCommandQueue");
#endif
    [selWebView stringByEvaluatingJavaScriptFromString:@"FasNFIGap.commandQueueFlushing = true"];
    
    // Keep executing the command queue until no commands get executed.
    // This ensures that commands that are queued while executing other
    // commands are executed as well.
    int numExecutedCommands = 0;
    do {
        numExecutedCommands = [self getExecuteQueuedCommandsFromWebView:selWebView];
    } while (numExecutedCommands != 0);
    
    [selWebView stringByEvaluatingJavaScriptFromString:@"FasNFIGap.commandQueueFlushing = false"];
}

/**
 * Fetches the command queue and executes each command. It is possible that the
 * queue will not be empty after this function has completed since the executed
 * commands may have run callbacks which queued more commands.
 *
 * Returns the number of executed commands.
 */
- (int)getExecuteQueuedCommandsFromWebView:(UIWebView*)selWebView
{
#ifdef DEBUG
    NSLog(@"@FAS@|FasNFI getExecuteQueuedCommandsFromWebView");
#endif
    // Grab all the queued commands from the JS side.
    NSString* queuedCommandsJSON = [selWebView stringByEvaluatingJavaScriptFromString:@"FasNFIGap.getAndClearQueuedCommands()"];

    // Parse the returned JSON array.
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    NSArray* queuedCommands = (NSArray*)[jsonParser objectWithString:queuedCommandsJSON error:NULL];
#ifdef DEBUG
    NSLog(@"@FAS@|queuedCommands length : %i",[queuedCommands count]);
#endif
    
    // Iterate over and execute all of the commands.
    for (NSString* commandJson in queuedCommands) {
#ifdef DEBUG
        NSDictionary *dic =(NSDictionary*)[jsonParser objectWithString:commandJson error:NULL];
        
        NSLog(@"@FAS@|command FullJson : %@",commandJson);
        NSLog(@"@FAS@|command id : %@",[dic objectForKey:@"id"]);
        NSLog(@"@FAS@|command rootcmd : %@",[dic objectForKey:@"rootcmd"]);
        NSLog(@"@FAS@|command custparam : %@",[dic objectForKey:@"custparam"]);
        NSLog(@"@FAS@|command cmd : %@",[dic objectForKey:@"cmd"]);
#endif
        [self parsingMessage:selWebView beforeParsingData:commandJson];
    }
    
//    [jsonParser release];
    
    return [queuedCommands count];
}

- (NFIMsg*)toNFIMsg:(NSDictionary*)dic
{
    NFIMsg* msg = [[NFIMsg alloc] init];
    [msg setId:[dic objectForKey:@"id"]];
    [msg setRootCommand:[dic objectForKey:@"rootcmd"]];
    [msg setCommand:[dic objectForKey:@"cmd"]];
    [msg setCallBack:[dic objectForKey:@"callback"]];
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
    
    [msg setCustParameter:[dic objectForKey:@"custparam"]];
    return msg;
}

- (void)processMessage:(UIWebView*)theWebView URLString:(NSString*)aUrl
{
    NSString* url = [aUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self parsingMessage:theWebView beforeParsingData:(NSString*)url];
//    [url release];
}

- (void)parsingMessage:(UIWebView*)theWebView beforeParsingData:(NSString*)aData
{
    FasSBJSON *jsonParser = [[FasSBJSON alloc] init];
    NSDictionary *dic =(NSDictionary*)[jsonParser objectWithString:aData error:NULL];
//    [jsonParser release];
    
#ifdef DEBUG
    for (NSString* key in dic)
        NSLog(@"@FAS@|key: %@, value : %@", key, [dic valueForKey:key]);
#endif
    
    //NFIMsg* msg = [self toNFIMsg:dic];
    [self parsingMessage:theWebView setNFIMsg:[self toNFIMsg:dic]];
}

- (void)parsingMessage:(UIWebView*)theWebView setNFIMsg:(NFIMsg*)msg {

    NSString* sPlugName = nil;
    
    if(![[msg getRootCommand] isEqualToString:@""]) {
        sPlugName = [NSString stringWithFormat:@"FNP%@", [msg getRootCommand]];
    }
    else {
        sPlugName = [NSString stringWithFormat:@"FNP%@", [msg getCommand]];
    }
    
#ifdef DEBUG
    NSLog(@"@FAS@|getCommand : %@",[msg getCommand]);
    NSLog(@"@FAS@|getRootCommand : %@",[msg getRootCommand]);
    NSLog(@"@FAS@|getCustParameter : %@",[msg getCustParameter]);
    NSLog(@"@FAS@|call plugin name : %@",sPlugName);
#endif

#ifdef DEBUG
    NSLog(@"@FAS@|getCustParam : %@",[msg getCustParameter]);
#endif
    if([msg getCustParameter] != nil) {
#ifdef DEBUG
        NSLog(@"@FAS@|call CustCommand Parameter");
#endif
        @try
        {
            Class klass = NSClassFromString([msg getCustParameter]);
            
            NFIParamPlugin* paramPlugin = (NFIParamPlugin*)[[klass alloc] init];
            [paramPlugin readyCustomParameter];
            
            [msg setCustArgDic:[paramPlugin getCustomDic]];
#ifdef DEBUG
            NSLog(@"@FAS@|CustCommand keys");
            for (NSString* key in [paramPlugin getCustomDic])
                NSLog(@"@FAS@|key: %@, vlaue : %@", key, [[paramPlugin getCustomDic] valueForKey:key]);
#endif
        }
        @catch (NSException *exception)
        {
            NSLog(@"@FAS@| caught exception : %@", exception);
        }
    }

    //NSLog(@"sPlugName : %@",sPlugName);
    @try
    {
        Class klass = NSClassFromString(sPlugName);
        NFIPlugin* plugin = (NFIPlugin*)[[klass alloc] init];
        //[plugin initNFI:self Msg:msg WebView:theWebView];
        [plugin setMsg:msg];
        
#ifdef DEBUG
        NSLog(@"@FAS@|call command : %@", [msg getCommand]);
#endif
        
        if(![[msg getRootCommand] isEqualToString:@""]) {
            [plugin performSelector:NSSelectorFromString([msg getCommand])];
        }
        else {
            [plugin execute];
        }
        
//        [msg release];
    }
    @catch (NSException *exception)
    {
        NSLog(@"@FAS@| caught exception : %@", exception);
    }
}

- (UIWebView*)getWebView
{
    return mWebView;
}


- (void)setMainWebView:(UIWebView*)aMainWebView
{
    mMainWebView = aMainWebView;
}

- (UIWebView*)getMainWebView
{
    return mMainWebView;
}

- (void)writeJavascriptFromMainWebView:(NSString*)jsFunc parameter:(NSString*)parameter
{
    if(mMainWebView != nil) {
        NSString* sUrl = [NSString stringWithFormat:@"%@('%@')", jsFunc, parameter];
        
        NSLog(@"@FAS@|CallBack String %@", sUrl);
        
        [mMainWebView stringByEvaluatingJavaScriptFromString:sUrl];
        
    }
    else {
        NSLog(@"@FAS@|not set main webview!");
    }
}

@end
