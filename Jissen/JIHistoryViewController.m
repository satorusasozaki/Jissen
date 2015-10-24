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

#import "AppDelegate.h"

@interface JIHistoryViewController ()

//@property (nonatomic,strong) NSArray *searchHistoryArray;
@property (nonatomic,strong) NSArray *fetchedObjects;

@end

@implementation JIHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.tableView registerClass:[JIBaseCell class] forCellReuseIdentifier:@"historyCell"];
    self.tableView.dataSource = self;
    
    NSManagedObjectContext *context = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweet" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    self.fetchedObjects = fetchedObjects;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *historyCellIdentifier = @"historyCell";
    JIBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:historyCellIdentifier];
    
    if (cell == nil) {
        cell = [[JIBaseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:historyCellIdentifier];
    }
    
    Tweet *tweet = [self.fetchedObjects objectAtIndex:indexPath.row];
    cell.textLabel.text = tweet.text;
    cell.detailTextLabel.text = @"detail text label";
//    cell.detailTextLabel.text = tweet.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    //Optionally for time zone conversions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT-07:00"]];

    NSString *dateDisplay = [formatter stringFromDate:tweet.date];
    cell.detailTextLabel.text = dateDisplay;
    
                                 
                                 
//    cell.textLabel.text = [self.fetchedObjects objectAtIndex:indexPath];
    
    return cell;
}
@end
