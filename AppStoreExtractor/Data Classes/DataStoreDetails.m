//
//  DataStoreDetails.m
//  AppStoreExtractor
//
//  Created by Puneet's on 17/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import "DataStoreDetails.h"

@implementation DataStoreDetails

@synthesize name,summary,imageUrl,largeImageUrl,rights;

-(void)dealloc
{
    [super dealloc];
    [name release];
    [summary release];
    [imageUrl release];
    [largeImageUrl release];
    [rights release];
}

@end
