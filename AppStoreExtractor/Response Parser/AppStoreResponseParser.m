//
//  AppStoreResponseParser.m
//  AppStoreExtractor
//
//  Created by Puneet's on 15/04/13.
//  Copyright (c) 2013 Puneet's. All rights reserved.
//

#import "AppStoreResponseParser.h"
#import "DataStoreDetails.h"
#import "SBJSON.h"

@implementation AppStoreResponseParser

+(NSArray*)parseAppStoreResponse:(NSDictionary*)response
{    
    NSMutableArray *dataArray = [[[NSMutableArray alloc]init] autorelease];
    NSDictionary* parsedDataArray = [response objectForKey:@"entry"];
    
    if([parsedDataArray count] > 0)
    {
        for(int i = 0; i < [parsedDataArray count]; i++)
        {
            DataStoreDetails *data = [[DataStoreDetails alloc]init];
            NSDictionary *dict = (NSDictionary*)[parsedDataArray objectAtIndex:i];
            data.name = [[dict objectForKey:@"im:name"] objectForKey:@"label"];
            data.summary = [[dict objectForKey:@"summary"] objectForKey:@"label"];
            data.imageUrl = [NSURL URLWithString:[[[dict objectForKey:@"im:image"] objectAtIndex:2] objectForKey:@"label"]];
            data.largeImageUrl = [NSURL URLWithString:[[[dict objectForKey:@"im:image"] objectAtIndex:1] objectForKey:@"label"]];
            data.rights = [[dict objectForKey:@"rights"] objectForKey:@"label"];
            
            [dataArray addObject:data];
            [data release];
        }
        return (NSArray *)dataArray;
    }
    else
    {
        return nil;
    }
}

@end
