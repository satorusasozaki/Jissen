//
//  JITableViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JITableViewController : UITableViewController <UISearchBarDelegate, UISearchResultsUpdating>

@property(nonatomic,strong) NSArray *originalData;
@property(nonatomic,strong) NSMutableArray *searchData;
@property(nonatomic,weak)UISearchBar *searchBar;


@property (strong, nonatomic) UISearchController *searchController;

@end
