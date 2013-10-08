//
//  DataStoreDetails.h
//  AppStoreExtractor
//
//  Created by Puneet's on 17/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStoreDetails : NSObject
{
    NSString *name;
    NSString *summary;
    NSURL *imageUrl;
    NSURL *largeImageUrl;
    NSString *rights;
}

@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *summary;
@property (nonatomic,retain)NSURL *imageUrl;
@property (nonatomic,retain)NSURL *largeImageUrl;
@property (nonatomic,retain)NSString *rights;

@end
