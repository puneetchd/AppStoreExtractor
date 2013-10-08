//
//  FeedsTableCell.m
//  AppStoreExtractor
//
//  Created by Puneet's on 19/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import "FeedsTableCell.h"

@implementation FeedsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code        
        appImageView = [[AsyncImageView alloc]init];
        appImageView.frame = CGRectMake(10,20, 53, 53);
        [self addSubview:appImageView];
        
        appName = [[UILabel alloc]initWithFrame:CGRectMake(68, 5, 255,40)];
        appName.font = [UIFont boldSystemFontOfSize:14];
        appName.backgroundColor = [UIColor clearColor];
        appName.textColor = [UIColor blackColor];
        [self addSubview:appName];
        
        appDescription = [[UILabel alloc]initWithFrame:CGRectMake(68, 22, 255, 70)];
        appDescription.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
        appDescription.numberOfLines = 2;
        appDescription.backgroundColor = [UIColor clearColor];
        appDescription.textColor = [UIColor blackColor];
        [self addSubview:appDescription];
        
        appRightsLabel = [[UILabel alloc]initWithFrame:CGRectMake(68, 60, 200, 40)];
        appRightsLabel.backgroundColor = [UIColor clearColor];
        appRightsLabel.textColor = [UIColor grayColor];
        appRightsLabel.font = [UIFont fontWithName:@"Helvetica" size:8.0f];
        [self addSubview:appRightsLabel];
    }
    return self;
}

-(void)setObjectForCell:(DataStoreDetails*)dataObject
{
    [appImageView setImageURL:dataObject.imageUrl];
    appName.text = dataObject.name;
    appDescription.text = dataObject.summary;
    appRightsLabel.text = dataObject.rights;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [super dealloc];
    [appImageView release];
    [appName release];
    [appDescription release];
    [appRightsLabel release];
}

@end
