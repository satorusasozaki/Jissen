//
//  JIBaseTableViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/6/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIBaseTableViewController.h"

@interface JIBaseTableViewController ()

@end

@implementation JIBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[self.view bounds]];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

@end
