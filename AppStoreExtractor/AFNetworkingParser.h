//
//  AFNetworkingParser.h
//  AppStoreExtractor
//
//  Created by Puneet's on 19/04/13.
//  Copyright (c) 2013 Puneet's. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "SAProgressHUD.h"

@protocol AFNetworkingParserDelegate;

@interface AFNetworkingParser : NSObject<SAProgressHUDDelegate>
{
    @public
    id <AFNetworkingParserDelegate> delegate;
    SAProgressHUD* hud;
}

@property(nonatomic, assign)id <AFNetworkingParserDelegate> delegate;

-(void)loginAtServerWithUsernameAndPassword:(NSString*)username :(NSString*)password;
-(void)getTopFreeApplications;
-(void)getTopGrossingApplications;
-(void)getTopPaidApplications;

@end

@protocol AFNetworkingParserDelegate <NSObject>

-(void)AFRequestFinished:(AFHTTPRequestOperation*)request withResponseObject:(NSDictionary*)responseDict urlString:(NSString*)baseURL;
-(void)AFRequestFailed:(AFHTTPRequestOperation*)request withErrorDescription:(NSString*)error;

@end
