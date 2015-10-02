//
//  JITableViewController.h
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JITableViewController : UITableViewController <UISearchBarDelegate,UITableViewDelegate>

@property (nonatomic,strong) UINavigationController *nvController;

@end
