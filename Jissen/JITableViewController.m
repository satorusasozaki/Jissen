//
//  JITableViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "JITableViewController.h"

@interface JITableViewController ()

@end

@implementation JITableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray *group1 = @[@"abc", @"def", @"ghi"];
        NSArray *group2 = @[@"jkl", @"mno", @"pqr"];
        NSArray *group3 = @[@"stu", @"vw",@"xyz"];
        
        self.originalData = [[NSArray alloc] initWithObjects:group1, group2, group3, nil];
        self.searchData = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar = searchBar;
    
    /*the search bar widht must be > 1, the height must be at least 44
     (the real size of the search bar)*/
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;    //on the top of tableView.
    self.definesPresentationContext = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger sections = 0;
    // Return the number of sections.
    
    if (tableView == self.tableView) {
        // the case of tableView (before searching)
        sections = [self.originalData count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        sections = [self.searchData count];
    }
    return sections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = 0;
    // Return the number of rows in the section.
    
    if (tableView == self.tableView) {
        rows = [[self.originalData objectAtIndex:section] count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        rows = [[self.searchData objectAtIndex:section] count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    // Configure the cell...
    if (tableView == self.tableView) {
        cell.textLabel.text = [[self.originalData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [[self.searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
 This method is called every time you insert a new character in the searchBar, you will take the searchString, perform the search through the table elements and return YES.
 */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self.searchData removeAllObjects];
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
    
    for (NSArray *group in self.originalData) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
        
        for (NSString *element in group) //take the n element in the group
        {                    //(eg. @"Napoli, @"Milan" etc.)
            
            // http://d.hatena.ne.jp/tanaponchikidun/20120814/1344916945
            // NSRangeはlocation（位置）とlength（長さ）の2つを持つ、"範囲"を表す構造体です。
            NSRange range = [element rangeOfString:searchString
                                           options:NSCaseInsensitiveSearch];
            
            if (range.length > 0) { //if the substring match
                [newGroup addObject:element]; //add the element to group
            }
        }
        
        if ([newGroup count] > 0) {
            [self.searchData addObject:newGroup];
        }
        
    }
    
    return YES;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
