//
//  JIHistoryViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 10/6/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JIHistoryViewController.h"
#import "JIBaseCell.h"
#import "Tweet.h"

@interface JIHistoryViewController ()

//@property (nonatomic,strong) NSArray *searchHistoryArray;
@property (nonatomic,strong) NSArray *fetchedObjects;

@end

@implementation JIHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[JIBaseCell class] forCellReuseIdentifier:@"historyCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.searchHistoryArray = [[NSUserDefaults standardUserDefaults] arrayForKey:@"searchedText"];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.fetchedObjects = fetchedObjects;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *historyCellIdentifier = @"historyCell";
    JIBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier];
    
    Tweet *tweet = [self.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet.text;
//    cell.textLabel.text = [self.fetchedObjects objectAtIndex:indexPath];
    
    return cell;
}
@end
