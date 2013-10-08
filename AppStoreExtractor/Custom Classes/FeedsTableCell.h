//
//  FeedsTableCell.h
//  AppStoreExtractor
//
//  Created by Puneet's on 19/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "DataStoreDetails.h"

@interface FeedsTableCell : UITableViewCell
{
    AsyncImageView *appImageView;
    UILabel *appDescription;
    UILabel *appName;
    UILabel *appRightsLabel;
}

-(void)setObjectForCell:(DataStoreDetails*)dataObject;

@end
