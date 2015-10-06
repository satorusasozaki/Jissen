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
#import "JITableViewCell.h"
#import "JIModel.h"


typedef NS_ENUM(NSUInteger, UYLTwitterSearchState) {
    UYLTwitterSearchStateLoading = 0,
    UYLTwitterSearchStateNotFound,
    UYLTwitterSearchStateRefused,
    UYLTwitterSearchStateFailed
};

@interface JITableViewController ()

@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *buffer;
@property (nonatomic,strong) NSMutableArray *results;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,assign) UYLTwitterSearchState searchState;
@property (nonatomic,strong) NSString *query;
@property (nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic,weak) JITableViewCell *cell;
@property (nonatomic,strong) NSString *tweet;
@property (nonatomic,strong) NSString *max_id;

@property (nonatomic,strong) JIModel *flagModel;
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResultCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LoadingCell"];
    self.tableView.delegate = self;

    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 50)];
    self.searchBar = searchBar;
    self.results = [[NSMutableArray alloc] init];
    self.searchBar.delegate = self;
    [self.tableView.tableHeaderView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = self.searchBar;

    [self.navigationController.view addSubview:self.tableView];
    self.title = @"Search";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

    self.flagModel = [[JIModel alloc] init];
}

#pragma mark - <Table view data source>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.results count];
    return count > 0 ? count : 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ResultCellIdentifier = @"ResultCell";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [self.results count];
    if ((count == 0) && (indexPath.row == 0))
    {
        JITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        self.cell = cell;
        cell.textLabel.text = [self searchMessageForState:self.searchState];
        return cell;
    }
    
    JITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    self.cell = cell;
    NSDictionary *tweetDic = (self.results)[indexPath.row];
    NSString *tweet = tweetDic[@"text"];

    NSString *dots = @"...";
    if (tweet.length > 10) {
        NSString *limitedTweet = [tweet substringToIndex:10];
        NSString *combinedTweet = [NSString stringWithFormat:@"%@%@", limitedTweet, dots];
        cell.textLabel.text = combinedTweet;
    } else {
        cell.textLabel.text = tweet;
    }
    
    if (indexPath.row == [self.results count] - 1) {
        self.max_id = tweetDic[@"id"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JIDetailViewController *detailViewController = [JIDetailViewController new];
    detailViewController.title = @"Detail";
    if([self.cell.reuseIdentifier isEqual:@"ResultCell"]) {
    NSDictionary *tweetDic = (self.results)[indexPath.row];
    NSString *tweetText = tweetDic[@"text"];
    self.tweet = tweetText;
    detailViewController.tweet = self.tweet;
    [self.navigationController pushViewController:detailViewController animated:YES];
    }
}


#pragma mark - API call
#define RESULTS_PERPAGE @"20"

- (void)loadQuery
{
    self.flagModel.isFinished = NO;
    self.searchState = UYLTwitterSearchStateLoading;
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
    [bufferResults removeObjectAtIndex:0];
    
    [self.results addObjectsFromArray:bufferResults];
    
    if ([self.results count] == 0)
    {
        NSArray *errors = jsonResults[@"errors"];
        if ([errors count])
        {
            self.searchState = UYLTwitterSearchStateFailed;
        }
        else
        {
            self.searchState = UYLTwitterSearchStateNotFound;
        }
    }
    
    self.buffer = nil;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    self.flagModel.isFinished = YES;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    self.buffer = nil;
    [self.refreshControl endRefreshing];
    self.searchState = UYLTwitterSearchStateFailed;
    
    [self handleError:error];
    [self.tableView reloadData];
}

- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)cancelConnection {
    if (self.connection != nil)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.connection cancel];
        self.connection = nil;
        self.buffer = nil;
    }
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
    self.query = self.searchBar.text;
    [self loadQuery];
    [self cancelConnection];
}

#pragma mark - Refresh Control

- (void)handleRefresh:(id)sender {
    [self loadQuery];
    [self cancelConnection];
}

#pragma mark - Scroll
// http://nonbiri-tereka.hatenablog.com/entry/2014/03/02/092414
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if([self.flagModel shouldLoadNext:self.tableView]){
        [self loadQuery];
        [self.tableView reloadData];
    }
}

@end
