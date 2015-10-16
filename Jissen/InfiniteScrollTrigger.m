//
//  InfiniteScrollTrigger.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/5/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "InfiniteScrollTrigger.h"

@implementation InfiniteScrollTrigger


- (BOOL)shouldLoadNext:(UITableView *)tableView {
    BOOL shouldLoadNext;
    if ( (!self.isLoading) && tableView.contentOffset.y >= (tableView.contentSize.height - tableView.bounds.size.height) ) {
        shouldLoadNext = YES;
    } else {
        shouldLoadNext = NO;
    }
    return shouldLoadNext;
}


@end
