//
//  TableViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UITableViewController
{
    NSArray *originalData;
    NSMutableArray *searchData;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
}

@end
