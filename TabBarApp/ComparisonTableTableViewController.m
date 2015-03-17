//
//  ComparisonTableTableViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-13.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ComparisonTableTableViewController.h"
#import "SearchResultTableViewCell.h"
#import "AppDelegate.h"
#import "ComparisonResultViewController.h"
#import "FoodItem.h"

@interface ComparisonTableTableViewController ()
@property(nonatomic) NSArray *searchResultForComparison;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

//@property (nonatomic) NSArray *itemsForComparison;
@property(nonatomic) NSInteger *count;
@end

@implementation ComparisonTableTableViewController

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    if(delegate.searchResultForComparison > 0){
         self.searchResultForComparison = delegate.searchResultForComparison;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No food items available"
                                                        message:@"Please run a search for food items before comparison."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.doneButton.enabled = NO;
    self.tableView.allowsMultipleSelection = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)onDone:(id)sender {
    
    NSLog(@"onDone num rows selected: %lu", (unsigned long)self.tableView.indexPathsForSelectedRows.count);
        [self performSegueWithIdentifier:@"ShowComparisonResult" sender:nil];
    // Should deselect selected rows and disable button
    // [myTable deselectRowAtIndexPath:[myTable indexPathForSelectedRow] animated:YES];
}


-(FoodItem*)selectedItemDetails:(NSString*)itemNumber{
    FoodItem *item;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultForComparison.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"ComparisonSearchCell";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.itemNameForComparison.text = self.searchResultForComparison[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    if(tableView.indexPathsForSelectedRows.count == 2){
        self.doneButton.enabled = YES;
    }else{
        self.doneButton.enabled = NO;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    if(tableView.indexPathsForSelectedRows.count == 2){
        self.doneButton.enabled = YES;
    }else{
        self.doneButton.enabled = NO;
    }
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


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowComparisonResult"]){
        ComparisonResultViewController *resultView = [segue destinationViewController];
        
        NSIndexPath *indexPath1 = self.tableView.indexPathsForSelectedRows[0];
        NSIndexPath *indexPath2 = self.tableView.indexPathsForSelectedRows[1];
        resultView.itemsForComparison = @[self.searchResultForComparison[indexPath1.row],self.searchResultForComparison[indexPath2.row]];
    }  else {
        NSLog(@"You forgot the segue %@",segue);
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
