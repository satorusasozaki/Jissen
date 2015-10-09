//
//  JIHistoryViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/6/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIHistoryViewController.h"
#import "JITableViewCell.h"

@interface JIHistoryViewController ()

@property (nonatomic,strong) NSArray *searchHistoryArray;

@end

@implementation JIHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[JITableViewCell class] forCellReuseIdentifier:@"historyCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchHistoryArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"searchedText"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.searchHistoryArray count];
    return count > 0 ? count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *historyCellIdentifier = @"historyCell";
    JITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier];
    cell.textLabel.text = [self.searchHistoryArray objectAtIndex:indexPath.row];
    return cell;
}
@end
