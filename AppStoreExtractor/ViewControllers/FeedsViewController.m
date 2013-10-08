//
//  FeedsViewController.m
//  AppStoreExtractor
//
//  Created by Puneet's on 12/12/12.
//  Copyright (c) 2012 Puneet's. All rights reserved.
//

#import "FeedsViewController.h"
#import "TBXML.h"
#import "TBXML+HTTP.h"
#import "DataStoreDetails.h"
#import "FeedsTableCell.h"
#import "Utils.h"
#import "NSString+HTML.h"
#import "NSString+SBJSON.h"
#import "GTMNSString+HTML.h"
#import "FeedDetailsViewController.h"
#import "AFNetworking.h"
#import "AppStoreResponseParser.h"

@interface FeedsViewController ()

@end

@implementation FeedsViewController

@synthesize feedsTableView;
@synthesize leftbarButton,rightBarButton;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"2-blue-background.jpg"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"2-blue-menu-bar.png"] forBarMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    UIButton *btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(20, 0, 40, 40);
    [btnSettings setBackgroundImage:[UIImage imageNamed:@"2-blue-settings-button.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *settingsBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnSettings];
    self.navigationItem.rightBarButtonItem = settingsBarButton;
    [settingsBarButton release];
    
    feedsObjectArray = [[NSMutableArray alloc]init];
    
    afParser = [[AFNetworkingParser alloc]init];
    afParser.delegate = self;
    //[afParser loginAtServerWithUsernameAndPassword:@"puneets" :@"password"];
    [afParser getTopFreeApplications];
}

#pragma mark - AFNetworkingParserDelegate

-(void)AFRequestFailed:(AFHTTPClient *)request withErrorDescription:(NSString *)error
{
    NSLog(@"Delegate request failed with error %@",error);
}

-(void)AFRequestFinished:(AFHTTPRequestOperation*)request withResponseObject:(NSDictionary*)responseDict urlString:(NSString *)baseURL
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSLog(@"Response : %@",responseDict);
    if ([baseURL isEqualToString:@"http://www.fontli.com/"]) {
    }
    else
    {
        [feedsObjectArray removeAllObjects];
        [feedsObjectArray addObjectsFromArray:[AppStoreResponseParser parseAppStoreResponse:[responseDict objectForKey:@"feed"]]];
        [feedsTableView reloadData];
    }
}

#pragma mark - XMl Data Parsing

-(void)traverseElement:(TBXMLElement*)element
{
    do {
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        if ([[TBXML elementName:element] isEqualToString:@"entry"]) {
            TBXMLElement *summary = [TBXML childElementNamed:@"summary" parentElement:element];
            TBXMLElement *name = [TBXML childElementNamed:@"im:name" parentElement:element];
            TBXMLElement *imageUrl = [TBXML childElementNamed:@"im:image" parentElement:element];
            TBXMLElement *imageUrlCursive = [TBXML nextSiblingNamed:@"im:image" searchFromElement:imageUrl];
            TBXMLElement *imageUrlLarge100  = [TBXML nextSiblingNamed:@"im:image" searchFromElement:imageUrlCursive];
            
            TBXMLElement *appRights = [TBXML childElementNamed:@"rights" parentElement:element];
            
            DataStoreDetails *dataStores = [[DataStoreDetails alloc]init];
            dataStores.summary = [[TBXML textForElement:summary] stringByConvertingHTMLToPlainText];
            dataStores.name = [[TBXML textForElement:name] stringByConvertingHTMLToPlainText];
            dataStores.imageUrl = [NSURL URLWithString:[TBXML textForElement:imageUrl]];
            dataStores.largeImageUrl = [NSURL URLWithString:[TBXML textForElement:imageUrlLarge100]];
            dataStores.rights = [[TBXML textForElement:appRights] stringByConvertingHTMLToPlainText];
            NSLog(@"Large Image Url %@",dataStores.largeImageUrl);
            
            [feedsObjectArray addObject:dataStores];
            [dataStores release];
            
        }
    } while ((element = element->nextSibling));
    
    [feedsTableView reloadData];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}

-(IBAction)getCurrentApps:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [afParser getTopPaidApplications];
}

-(IBAction)getTopGrossing:(id)sender
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [afParser getTopGrossingApplications];
}

#pragma mark - UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [feedsObjectArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"FeedsMenuTableViewCell";
	
	FeedsTableCell *cell = (FeedsTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
        cell = [[[FeedsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    if (indexPath.row < feedsObjectArray.count) {
        [cell setObjectForCell:[feedsObjectArray objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    objToPass = [feedsObjectArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"FeedDetailsSegue" sender:objToPass];
}

#pragma mark- UIStoryBoard Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FeedDetailsSegue"]) {
        FeedDetailsViewController *feedDetailsController = segue.destinationViewController;
        feedDetailsController.dataObject = sender;
    }
}

- (void)didReceiveMemoryWarning
{
    [feedsObjectArray release];
    feedsObjectArray = nil;
    [feedsTableView release];
    feedsTableView = nil;
    [objToPass release];
    leftbarButton = nil;
    rightBarButton = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [feedsTableView release];
    [feedsObjectArray release];
    [objToPass release];
    [leftbarButton release];
    [rightBarButton release];
    [super dealloc];
}

@end
