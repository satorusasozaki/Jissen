//
//  JIHistoryViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/6/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JIBaseTableViewController.h"

@interface JIHistoryViewController : JIBaseTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) NSUserDefaults *searchHistory;

@end
