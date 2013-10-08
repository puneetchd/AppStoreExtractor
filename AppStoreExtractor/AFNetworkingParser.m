//
//  AFNetworkingParser.m
//  AppStoreExtractor
//
//  Created by Puneet's on 19/04/13.
//  Copyright (c) 2013 Puneet's. All rights reserved.
//

#import "AFNetworkingParser.h"
#import "NSString+SBJSON.h"

@implementation AFNetworkingParser
@synthesize delegate;

-(void)loginAtServerWithUsernameAndPassword:(NSString*)username :(NSString*)password
{
    [self showHUDwithText:@""];
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uuid = [NSString stringWithString:(NSString*)
                      uuidStringRef];
    CFRelease(uuidStringRef);
    
    NSString *deviceId= uuid;
    
    NSURL *postUrl = [NSURL URLWithString:@"http://www.fontli.com/"];
    
    
    AFHTTPClient *httpClient = [[[AFHTTPClient alloc] initWithBaseURL:postUrl] autorelease];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"puneets", @"username",
                            @"password", @"password",
                            deviceId,@"device_id",
                            nil];
    
    NSMutableURLRequest *mutableRequest = [httpClient requestWithMethod:@"POST" path:@"/api/signin" parameters:params];
    
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc]
                                          initWithRequest:mutableRequest] autorelease];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        if(delegate!=nil && [delegate respondsToSelector:@selector(AFRequestFinished:withResponseObject:urlString:)])
            [delegate AFRequestFinished:operation withResponseObject:[[operation responseString] JSONValue] urlString:[postUrl absoluteString]];
        if(hud)
            [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

-(void)getTopFreeApplications
{
    [self showHUDwithText:@""];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://itunes.apple.com/us/rss/topfreeapplications/limit=100/json"]];
    
    AFJSONRequestOperation *operation = [[[AFJSONRequestOperation alloc]initWithRequest:request] autorelease];
    [request release];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        if(delegate!=nil && [delegate respondsToSelector:@selector(AFRequestFinished:withResponseObject:urlString:)])
            [delegate AFRequestFinished:operation withResponseObject:JSON urlString:[[request URL] absoluteString]];
        if(hud)
            [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];
    [operation start];
}

-(void)getTopGrossingApplications
{
    [self showHUDwithText:@""];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://itunes.apple.com/us/rss/topgrossingapplications/limit=100/json"]];
    
    AFJSONRequestOperation *operation = [[[AFJSONRequestOperation alloc]initWithRequest:request] autorelease];
    [request release];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        if(delegate!=nil && [delegate respondsToSelector:@selector(AFRequestFinished:withResponseObject:urlString:)])
            [delegate AFRequestFinished:operation withResponseObject:JSON urlString:[[request URL] absoluteString]];
        if(hud)
            [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];
    [operation start];
}

-(void)getTopPaidApplications
{
    [self showHUDwithText:@""];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://itunes.apple.com/us/rss/toppaidapplications/limit=100/json"]];
    
    AFJSONRequestOperation *operation = [[[AFJSONRequestOperation alloc]initWithRequest:request] autorelease];
    [request release];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        if(delegate!=nil && [delegate respondsToSelector:@selector(AFRequestFinished:withResponseObject:urlString:)])
            [delegate AFRequestFinished:operation withResponseObject:JSON urlString:[[request URL] absoluteString]];
        if(hud)
            [hud hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed");
    }];
    [operation start];
}

#pragma mark -
#pragma mark SAProgressHUD delegate function

- (void)hudWasHidden
{
	NSLog(@"ConnectionManager : hudWasHidden");
	// Remove HUD from screen when the HUD was hidded
	if(hud)
	{
		[hud removeFromSuperview];
        hud.delegate = nil;
		[hud release];
		hud = nil;
	}
}

- (void)showHUDwithText:(NSString *)text
{
	if(!hud)
	{
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		hud = [[SAProgressHUD alloc] initWithWindow:window];
		// Add HUD to screen
		[window addSubview:hud];
		
		// Regisete for HUD callbacks so we can remove it from the window at the right time
		hud.delegate = self;
		
		// Show the HUD while the provided method executes in a new thread
		[hud show:YES];
		hud.labelText = text;
	}
}

@end
