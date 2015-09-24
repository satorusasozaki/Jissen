//
//  TableViewController.m
//  Jissen
//
//  Created by Satoru Sasozaki on 9/23/15.
//  Copyright © 2015 Satoru Sasozaki. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSArray *group1 = [[NSArray alloc] initWithObjects:@"abc", @"def", @"ghi", nil];
        NSArray *group2 = [[NSArray alloc] initWithObjects:@"jkl", @"mno", @"pqr", nil];
        NSArray *group3 = [[NSArray alloc] initWithObjects:@"stu", @"vw",@"xyz", nil];
        
        originalData = [[NSArray alloc] initWithObjects:group1, group2, group3, nil];
        searchData = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    /*the search bar widht must be > 1, the height must be at least 44
     (the real size of the search bar)*/
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    /*contents controller is the UITableViewController, this let you to reuse
     the same TableViewController Delegate method used for the main table.*/
    
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    //set the delegate = self. Previously declared in ViewController.h
    
    self.tableView.tableHeaderView = searchBar; //this line add the searchBar
    //on the top of tableView.
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
        sections = [originalData count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        sections = [searchData count];
    }
    return sections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger rows = 0;
    // Return the number of rows in the section.
    
    if (tableView == self.tableView) {
        rows = [[originalData objectAtIndex:section] count];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        rows = [[searchData objectAtIndex:section] count];
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
        cell.textLabel.text = [[originalData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if(tableView == self.searchDisplayController.searchResultsTableView){
        cell.textLabel.text = [[searchData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

/*
 This method is called every time you insert a new character in the searchBar, you will take the searchString, perform the search through the table elements and return YES.
 */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [searchData removeAllObjects];
    /*before starting the search is necessary to remove all elements from the
     array that will contain found items */
    
    NSArray *group;
    
    /* in this loop I search through every element (group) (see the code on top) in
     the "originalData" array, if the string match, the element will be added in a
     new array called newGroup. Then, if newGroup has 1 or more elements, it will be
     added in the "searchData" array. shortly, I recreated the structure of the
     original array "originalData". */
    
    for(group in originalData) //take the n group (eg. group1, group2, group3)
        //in the original data
    {
        NSMutableArray *newGroup = [[NSMutableArray alloc] init];
        NSString *element;
        
        for(element in group) //take the n element in the group
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
            [searchData addObject:newGroup];
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
