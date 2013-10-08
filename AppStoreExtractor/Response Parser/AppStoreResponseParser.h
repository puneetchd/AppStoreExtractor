//
//  AppStoreResponseParser.h
//  AppStoreExtractor
//
//  Created by Puneet's on 15/04/13.
//  Copyright (c) 2013 Puneet's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreResponseParser : NSObject

+(NSArray*)parseAppStoreResponse:(NSDictionary*)response;

@end
