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

@interface ComparisonTableTableViewController ()
@property(nonatomic) NSArray *searchResultForComparison;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property(nonatomic) NSInteger *count;
@end

@implementation ComparisonTableTableViewController

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.searchResultForComparison = delegate.searchResultForComparison;
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
    self.doneButton.enabled = NO;
    [self performSegueWithIdentifier:@"ShowComparisonResult" sender:nil];
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
    cell.selected = NO;
    cell.accessoryType = UITableViewCellAccessoryNone;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return 44;
 }

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
}


@end
