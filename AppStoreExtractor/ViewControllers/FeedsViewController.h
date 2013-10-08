//
//  FeedsViewController.h
//  AppStoreExtractor
//
//  Created by Puneet's on 12/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStoreDetails.h"
#import "AFNetworkingParser.h"

@interface FeedsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AFNetworkingParserDelegate>{
    IBOutlet UITableView *feedsTableView;
    IBOutlet UIBarButtonItem *leftbarButton;
    IBOutlet UIBarButtonItem *rightBarButton;
    NSMutableArray *feedsObjectArray;
    DataStoreDetails *objToPass;
    AFNetworkingParser *afParser;
}

@property (nonatomic, retain) IBOutlet UITableView *feedsTableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *leftbarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *rightBarButton;

-(IBAction)getCurrentApps:(id)sender;
-(IBAction)getTopGrossing:(id)sender;

@end
