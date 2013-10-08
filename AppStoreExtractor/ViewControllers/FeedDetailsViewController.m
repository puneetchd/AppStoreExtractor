//
//  FeedDetailsViewController.m
//  AppStoreExtractor
//
//  Created by Puneet's on 28/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import "FeedDetailsViewController.h"

@interface FeedDetailsViewController ()

@end

@implementation FeedDetailsViewController
@synthesize appImageView,appNameLabel,description;
@synthesize imageUrl,appName,appDescription;
@synthesize dataObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2-blue-menu-bar.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(20, 0, 53, 32);
    [btnBack setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    btnBack.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [btnBack addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setTitle:@"Back" forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageNamed:@"2-blue-back-button.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.leftBarButtonItem = backBarButton;
    [backBarButton release];
    self.navigationItem.backBarButtonItem = backBarButton;
    
    appImageView.imageURL = dataObject.largeImageUrl;
    appNameLabel.text = dataObject.name;
    appNameLabel.font = [UIFont fontWithName:@"BanglaSangamMN-Bold" size:22.0f];
    description.text = dataObject.summary;
}

-(void)backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    appImageView = nil;
    appNameLabel = nil;
    description = nil;
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [appImageView release];
    [appNameLabel release];
    [description release];
    [super dealloc];
}

@end
