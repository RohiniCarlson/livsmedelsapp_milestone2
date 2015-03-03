//
//  FavoritesTableViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "AppDelegate.h"
#import "FoodItem.h"
#import "FavoritesInfo.h"

@interface FavoritesTableViewController ()

@property (nonatomic) NSArray *favoriteListArray;

@end

@implementation FavoritesTableViewController

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *favoriteList = delegate.favoriteList;
    self.favoriteListArray = [favoriteList allValues];
    NSLog(@"num items in array: %lu",(unsigned long)self.favoriteListArray.count);
    for (FoodItem *item in self.favoriteListArray) {
        NSLog(@"%@", item );
    }
    if (self.favoriteListArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No favorites"
                                                        message:@"Your favorite list is empty at the moment."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    
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
    return self.favoriteListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"FavoriteCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    // To be implemented!
   // UIImage *image = (UIImage*)[cell.contentView viewWithTag:2];
    UILabel *itemNameLabel = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *itemEnergyLabel = (UILabel*)[cell.contentView viewWithTag:4];
    FoodItem *foodItem = (FoodItem*)self.favoriteListArray[indexPath.row];
    itemNameLabel.text = foodItem.name;
    itemEnergyLabel.text = [NSString stringWithFormat:@"Innehåller %.2f kcal",foodItem.energy];
    return cell;
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"Info"]){
        FavoritesInfo *infoView =
        [segue destinationViewController];
        infoView.foodItem = (FoodItem*)self.favoriteListArray[indexPath.row];
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
