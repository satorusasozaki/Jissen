//
//  JIModel.h
//  Jissen
//
//  Created by Satoru Sasozaki on 10/5/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JITableViewController.h"

@interface JIModel : NSObject

@property BOOL isFinished;

- (BOOL)shouldLoadNext:(UITableView *)tableView;

@end
