//
//  FeedDetailsViewController.h
//  AppStoreExtractor
//
//  Created by Puneet's on 28/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "DataStoreDetails.h"

@interface FeedDetailsViewController : UIViewController{
    IBOutlet AsyncImageView *appImageView;
    IBOutlet UILabel *appNameLabel;
    IBOutlet UITextView *description;
    
    NSURL *imageUrl;
    NSString *appName;
    NSString *appDescription;
    DataStoreDetails *dataObject;
}


@property (nonatomic, retain) IBOutlet AsyncImageView *appImageView;
@property (nonatomic, retain) IBOutlet UILabel *appNameLabel;
@property (nonatomic, retain) IBOutlet UITextView *description;

@property (nonatomic, assign) DataStoreDetails *dataObject;

@property (nonatomic,assign) NSURL *imageUrl;
@property (nonatomic,assign) NSString *appName;
@property (nonatomic,assign) NSString *appDescription;

@end
