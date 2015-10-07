//
//  JIBaseTableViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/6/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JIBaseTableViewController : UIViewController // <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@end
