//
//  JITableViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//  http://useyourloaf.com/blog/searching-twitter-with-ios.html
//  http://useyourloaf.com/blog/migrating-to-the-new-twitter-search-api.html

#import <UIKit/UIKit.h>
#import "JIBaseTableViewController.h"

@interface JITableViewController : JIBaseTableViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;


@end
