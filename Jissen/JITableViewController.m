//
//  JITableViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//  http://useyourloaf.com/blog/searching-twitter-with-ios.html
//  http://useyourloaf.com/blog/migrating-to-the-new-twitter-search-api.html
#import "JITableViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "JIDetailViewController.h"
#import "JIBaseCell.h"
#import "JITweetCell.h"
#import "ISComponents.h"
#import "JIHistoryViewController.h"
#import "JITweetCell.h"

// For connection statuts
typedef NS_ENUM(NSUInteger, UYLTwitterSearchState) {
    UYLTwitterSearchStateLoading = 0,
    UYLTwitterSearchStateNotFound,
    UYLTwitterSearchStateRefused,
    UYLTwitterSearchStateFailed
};

@interface JITableViewController ()

@property (nonatomic,weak) UIRefreshControl *refreshControl;

// Properties used for API connection
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *buffer;
@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,assign) UYLTwitterSearchState searchState;
@property (nonatomic,strong) NSString *query;

// UI components
@property (nonatomic,weak) UISearchBar *searchBar;

// The ID of last tweet from one API call
// This ID will be the first ID of tweet in the next API call
// Used to decide where to start for next API call
@property (nonatomic,strong) NSString *max_id;

// Used to know when API call is finished
// To load next set of tweets
@property (nonatomic,strong) ISComponents *infiniteScrollComponents;

@property (nonatomic,strong) NSMutableArray *searchHistoryArray;

@property (nonatomic) BOOL didLeaveCurrentViewController;
@property (nonatomic) BOOL didEndEditingText;

@end

@implementation JITableViewController

- (ACAccountStore *)accountStore {
    if (_accountStore == nil)
    {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (NSString *)searchMessageForState:(UYLTwitterSearchState)state {
    switch (state)
    {
        case UYLTwitterSearchStateLoading:
            return @"Loading...";
            break;
        case UYLTwitterSearchStateNotFound:
            return @"No results found";
            break;
        case UYLTwitterSearchStateRefused:
            return @"Twitter Access Refused";
            break;
        default:
            return @"Not Available";
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[JITweetCell class] forCellReuseIdentifier:@"ResultCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LoadingCell"];

    // Do not forget to designate delegate and dataSource to self
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 50)];
    self.searchBar = searchBar;
    
    // Do not use alloc and init
    self.results = [NSMutableArray array];
    self.searchBar.delegate = self;
    [self.tableView.tableHeaderView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = self.searchBar;

    // Set title in each elements of the navigation controller
    self.title = @"Search";
    
    //
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    
    // RefreshControl is only for tableView. Do not add it to UIViewController
    // https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIRefreshControl_class/#//apple_ref/occ/instm/UIRefreshControl/init
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;

    // Do not forget to instanciate any object properties
    self.infiniteScrollComponents = [[ISComponents alloc] init];
    
    // UIButton
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIBarButtonItem *buttonToHistory = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonToHistory;
    
    // http://stackoverflow.com/questions/2848055/add-button-to-navigationbar-programatically
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(goToHistory:)];
//    [myButton addTarget:self
//                 action:@selector(myAction)
//       forControlEvents:UIControlEventTouchUpInside];
    
    
    NSMutableArray *searchHistoryArray = [NSMutableArray array];
    self.searchHistoryArray = searchHistoryArray;
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.didLeaveCurrentViewController = NO;
}


- (void)goToHistory:(id)sender {
    JIHistoryViewController *historyViewController = [[JIHistoryViewController alloc] init];
//    historyViewController.searchHistory = self.searchHistory;
    self.didLeaveCurrentViewController = YES;
    [self.navigationController pushViewController:historyViewController animated:YES];
}


#pragma mark - <Table view data source>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if ([self.results count] > 0) {
        count = [self.results count];
    } else if (self.infiniteScrollComponents.isLoading) {
        count = 1;
    } else {
        count = 0;
    }
    return count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // static is used so that both idenrifiers do not have to be assigned again after they got assigned
    // Write "registerClass" in viewDidLoad or
    // Write if statement to initialize cell when it is nil
    // "registerClass" is preferred
    static NSString *ResultCellIdentifier = @"ResultCell";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    JIBaseCell *cell = nil;
    JITweetCell *tweetCell = nil;
    
    // Needed to return plain cell just after viewDidLoad, because self.results is empty and cannot return anything since API call has not happen yet
    // Since self.result is 0, numberOfRowsInsection returns just 1 and one cell will be displayed
    NSUInteger count = [self.results count];
    if ((count == 0) && (indexPath.row == 0)) {
        cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
    } else {
        tweetCell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
//    cell.tweet = [Tweet tweetWithDictionary:self.results[indexPath.row]];
    }

    
    if (([cell reuseIdentifier] == LoadCellIdentifier) && self.infiniteScrollComponents.isLoading) {
        cell.textLabel.text = [self searchMessageForState:UYLTwitterSearchStateLoading];
    } else {
        // Pick up the one JSON data set on "indexPath.row"th from self.results
        // How can you know the
        
        // Pick up one tweet from self.results in which whole JSON data is stored
        // NSDictionary object can contain some lines holding keys and values
        NSDictionary *tweetDic = self.results[indexPath.row];
        

        // Pick up the value whose key is "text" from the lines
        NSString *tweet = tweetDic[@"text"];
        
        // Display tweet texts with specified length
        if (tweet.length > 10) {
            tweet = [NSString stringWithFormat:@"%@%@", [tweet substringToIndex:10], @"..."];
        }
        tweetCell.tweet.text = tweet;
        
        // indexPath.row always starts with 0, although the size of the array obtained from count method is counted from 1
        // Thus, -1 needed
        if (indexPath.row == [self.results count] - 1) {
            // self.max_id will unexpectedly be nill, when @"id" used
            self.max_id = tweetDic[@"id_str"];
        }
    }
    
    return cell? cell : tweetCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    // Avoid to go to detailView when the dummy cell which is created before API call tapped
      if([[[self tableView:tableView cellForRowAtIndexPath:indexPath] reuseIdentifier] isEqual:@"ResultCell"]) {
        JIDetailViewController *detailViewController = [[JIDetailViewController alloc] init];
        detailViewController.title = @"Detail";
        self.didLeaveCurrentViewController = YES;
        
        // Create NSDictionary object so that you can specifiy the key to pick a value
        NSDictionary *tweetDic = self.results[indexPath.row];
        NSString *tweetText = tweetDic[@"text"];
        
        // Assign whole tweet text to tweet property in detailViewController
        detailViewController.tweet = tweetText;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


#pragma mark - API call
#define RESULTS_PERPAGE @"5"

- (void)loadQuery
{
    // isFinished turned NO, since API call starts here
    self.infiniteScrollComponents.isLoading = YES;
    self.searchState = UYLTwitterSearchStateLoading;
    
    // Need to research: what is percentEscapes?
    NSString *encodedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             if (self.max_id == nil) {
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 NSDictionary *parameters = @{@"count" : RESULTS_PERPAGE, @"q" : encodedQuery};
        
                 SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                           requestMethod:SLRequestMethodGET
                                                                     URL:url
                                                              parameters:parameters];
                 
                 NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                 slRequest.account = [accounts lastObject];
                 NSURLRequest *request = [slRequest preparedURLRequest];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 });
             } else {
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                 NSDictionary *parameters = @{@"count" : RESULTS_PERPAGE, @"q" : encodedQuery, @"max_id" : self.max_id};
                 
                 SLRequest *slRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                           requestMethod:SLRequestMethodGET
                                                                     URL:url
                                                              parameters:parameters];
                 
                 NSArray *accounts = [self.accountStore accountsWithAccountType:accountType];
                 slRequest.account = [accounts lastObject];
                 NSURLRequest *request = [slRequest preparedURLRequest];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                 });
             }
         }
         else
         {
             self.searchState = UYLTwitterSearchStateRefused;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }
     }];
}

#pragma mark - Connection Control

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    NSMutableArray *bufferResults = [jsonResults[@"statuses"] mutableCopy];
    if ( ([bufferResults count] > 1) && self.didEndEditingText == NO) {
        [bufferResults removeObjectAtIndex:0];
    }
    [self.results addObjectsFromArray:bufferResults];
    
    if ([self.results count] == 0)
    {
            self.searchState = UYLTwitterSearchStateNotFound;
    }
    
    self.buffer = nil;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    self.didEndEditingText = NO;
    self.infiniteScrollComponents.isLoading = NO;
}

#pragma mark - Search Bar Control
    
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    [self.results removeAllObjects];
    
    NSMutableArray *arrayFromUserDefaults = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"searchedText"]];
    [arrayFromUserDefaults addObject:self.searchBar.text];
    [[NSUserDefaults standardUserDefaults] setObject:arrayFromUserDefaults forKey:@"searchedText"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.query = self.searchBar.text;
    self.didEndEditingText = YES;
    [self loadQuery];
}

#pragma mark - Refresh Control

- (void)handleRefresh:(id)sender {
    [self.results removeAllObjects];
    [self loadQuery];
    [self.tableView reloadData];
}

#pragma mark - Scroll
// http://nonbiri-tereka.hatenablog.com/entry/2014/03/02/092414
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([self.infiniteScrollComponents shouldLoadNext:self.tableView] && !self.didLeaveCurrentViewController){
        [self loadQuery];
        [self.tableView reloadData];
    }
}



@end
