//
//  SearchResultTableViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "SearchResultTableViewController.h"
#import "ItemDetail.h"
#import "SearchResultTableViewCell.h"
#import "AppDelegate.h"

@interface SearchResultTableViewController ()
@property (nonatomic) NSArray *filteredResult;
@property (nonatomic) NSMutableArray *itemDetails;
@property (nonatomic) NSMutableArray *foodItemNames;
@property (nonatomic) NSDictionary *item;
@property (nonatomic) NSIndexPath *indexItemClicked;
@property (nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *compareButton;
@end

@implementation SearchResultTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    
    self.delegate = [UIApplication sharedApplication].delegate;
    if(self.searchResult.count > 0) {
        self.delegate.searchResultForComparison = self.searchResult;
        self.compareButton.enabled = YES;
    } else {
        self.compareButton.enabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    SearchResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    label = (UILabel *)[cell.contentView viewWithTag:1];
    label.text = array[indexPath.row][@"name"];
    cell.itemNumber = array[indexPath.row][@"number"];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] contains[c] %@", searchText];
    self.filteredResult = [self.searchResult filteredArrayUsingPredicate:predicate];
    self.delegate.searchResultForComparison = self.filteredResult;
    NSLog(@"searchBarTextDidBeginEditing %lu", (unsigned long)self.delegate.searchResultForComparison.count);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.delegate.searchResultForComparison = self.searchResult;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 44.0f;
 }

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ItemDetail *detailView = [segue destinationViewController];
    SearchResultTableViewCell *cell = (SearchResultTableViewCell*)sender;
     if ([segue.identifier isEqualToString:@"ShowFoodItemDetail"] ) {
         detailView.itemNumber =  cell.itemNumber;
     } else if ([segue.identifier isEqualToString:@"ShowFilteredItemDetail"]) {
             detailView.itemNumber =  cell.itemNumber;
     } else if ([segue.identifier isEqualToString:@"ShowResultsForComparison"]){
     }else {
     NSLog(@"You forgot the segue %@",segue);
     }
}

@end
