//
//  SearchResultTableViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "ItemDetail.h"

@interface SearchResultTableViewController ()
@property (nonatomic) NSArray *filteredResult;
@property (nonatomic) NSMutableArray *itemDetails;
@property (nonatomic) NSMutableArray *foodItemNames;
@property (nonatomic) NSDictionary *item;
@property (nonatomic) NSIndexPath *indexItemClicked;

@end

@implementation SearchResultTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.searchResult.count;
    } else {
        return self.filteredResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *label;
    NSArray *array;
    NSString *cellIdentifier = @"";
    
    if (tableView == self.tableView) {
        array = self.searchResult;
        cellIdentifier = @"SearchResultCell";        
    } else {
        array = self.filteredResult;
        cellIdentifier = @"FilteredCell";
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    label = (UILabel *)[cell.contentView viewWithTag:1];
   label.text = array[indexPath.row][@"name"];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] contains[c] %@", searchText];
    self.filteredResult = [self.searchResult filteredArrayUsingPredicate:predicate];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 44.0f;
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


/*-(void)tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.tableView ) {
        // self.indexItemClicked = indexPath;
      //NSLog(@"tableview: %@",tableView);
        NSLog(@"index cliked: %d",(int)indexPath.row);
        [self performSegueWithIdentifier:@"ShowFilteredItemDetail" sender:indexPath];
    }
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath;
    ItemDetail *detailView = [segue destinationViewController];
    
    /*if ([segue.identifier isEqualToString:@"ShowFoodItemDetail"] ) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailView.item = self.searchResult[indexPath.row];
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }*/
    
 
     if ([segue.identifier isEqualToString:@"ShowFoodItemDetail"] ) {
         indexPath = [self.tableView indexPathForSelectedRow];
     detailView.item = self.searchResult[indexPath.row];
     } else if ([segue.identifier isEqualToString:@"ShowFilteredItemDetail"]) {
          indexPath = [self.tableView indexPathForSelectedRow];
         NSLog(@"prepareForSegue(): %d",(int)indexPath.row);
     detailView.item = self.filteredResult[indexPath.row];
         
     } else {
     NSLog(@"You forgot the segue %@",segue);
     }
}

@end
