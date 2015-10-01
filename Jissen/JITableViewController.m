//
//  JITableViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JITableViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

typedef NS_ENUM(NSUInteger, UYLTwitterSearchState)
{
    UYLTwitterSearchStateLoading,
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
@property (nonatomic,weak) NSString *query;

@property(nonatomic,weak)UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;




@end

@implementation JITableViewController


- (ACAccountStore *)accountStore
{
    if (_accountStore == nil)
    {
        _accountStore = [[ACAccountStore alloc] init];
    }
    return _accountStore;
}

- (NSString *)searchMessageForState:(UYLTwitterSearchState)state
{
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
/*
- (IBAction)refreshSearchResults
{
    [self cancelConnection];
    [self loadQuery];
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [UITableView new];
    self.tableView = tableView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ResultCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LoadingCell"];


    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 10)];
    self.searchBar = searchBar;

    NSMutableArray *results = [NSMutableArray new];
    self.results = results;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;


    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.results count];
    return count > 0 ? count : 1;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ResultCellIdentifier = @"ResultCell";
    static NSString *LoadCellIdentifier = @"LoadingCell";
    
    NSUInteger count = [self.results count];
    if ((count == 0) && (indexPath.row == 0))
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadCellIdentifier];
        cell.textLabel.text = [self searchMessageForState:self.searchState];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    NSDictionary *tweet = (self.results)[indexPath.row];
    cell.textLabel.text = tweet[@"text"];
    return cell;
}

 
/*
 This method is called every time you insert a new character in the searchBar, you will take the searchString, perform the search through the table elements and return YES.
 */
/*

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    // Set searchString equal to what's typed into the searchbar
    NSString *query;
    self.query = query;
    self.query = self.searchController.searchBar.text;

}
 */






#pragma mark - Private methods




#define RESULTS_PERPAGE @"20"

- (void)loadQuery
{
    self.searchState = UYLTwitterSearchStateLoading;
    NSString *encodedQuery = [self.query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
  
             NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
             NSDictionary *parameters = @{@"count" : RESULTS_PERPAGE,
                                          @"q" : encodedQuery};
             
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
         else
         {
             self.searchState = UYLTwitterSearchStateRefused;
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }
     }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.buffer = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    
    NSError *jsonParsingError = nil;
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:self.buffer options:0 error:&jsonParsingError];
    
    self.results = jsonResults[@"statuses"];
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
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.connection = nil;
    self.buffer = nil;
    [self.refreshControl endRefreshing];
    self.searchState = UYLTwitterSearchStateFailed;
    
    [self handleError:error];
    [self.tableView reloadData];
}

- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)cancelConnection
{
    if (self.connection != nil)
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.connection cancel];
        self.connection = nil;
        self.buffer = nil;
    }
}

/*
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    
    NSString *query;
    self.query = query;
    self.query = self.searchController.searchBar.text;
    [self loadQuery];
    [self cancelConnection];
    
}



*/

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *query;
    self.query = query;
    self.query = self.searchController.searchBar.text;
    [self loadQuery];
    [self cancelConnection];
}

@end
