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
@property (nonatomic) NSMutableArray *favoriteListArray;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *compareButton;

@end

@implementation FavoritesTableViewController

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *favoriteList = delegate.favoriteList;
   // NSArray *items = [favoriteList allValues];
    self.favoriteListArray = [NSMutableArray arrayWithArray:[favoriteList allValues]];
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
        self.compareButton.enabled = NO;
    } else {
        self.compareButton.enabled = YES;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    if (self.favoriteListArray.count>0) {
        self.compareButton.enabled = YES;
    } else {
        self.compareButton.enabled = NO;
    }
}

- (IBAction)onCompare:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"ShowFavoritesForComparison" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteListArray.count;
}

-(NSString*)cachePath:(NSString*)imageName {
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = dirs[0];
    NSString *completePath = [documentDirectory stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
    return completePath;
}

-(void) deleteImageFromCache:(NSString*)imageToBeDeleted{
    if (imageToBeDeleted != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        if(![fileManager removeItemAtPath:imageToBeDeleted error:&error]) {
            NSLog(@"Could not delete associated image: %@ ",[error localizedDescription]);
        } else {
            NSLog(@"image deleted successfully!");
        }
    } else {
        NSLog(@"No image exists!");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
    (NSIndexPath *)indexPath {
    FoodItem *foodItem = (FoodItem*)self.favoriteListArray[indexPath.row];
    NSString *cellIdentifier = @"FavoriteCell";
    UIImage *savedImage = [UIImage imageWithContentsOfFile:[self cachePath:foodItem.number]];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
   UIImageView *foodImage = (UIImageView*)[cell.contentView viewWithTag:2];
    if(savedImage) {
        foodImage.image = savedImage;
    } else {
        foodImage.image = [UIImage imageNamed:@"cutlery"];
    }
    UILabel *itemNameLabel = (UILabel*)[cell.contentView viewWithTag:3];
    UILabel *itemEnergyLabel = (UILabel*)[cell.contentView viewWithTag:4];
    
    itemNameLabel.text = foodItem.name;
    itemEnergyLabel.text = [NSString stringWithFormat:@"Innehåller %.2f kcal",foodItem.energy];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodItem *foodItem = (FoodItem*)self.favoriteListArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete associated image
        [self deleteImageFromCache:foodItem.imagePath];
        // Delete row from the data source
        [self.favoriteListArray removeObjectAtIndex:indexPath.row];
        // Delete row from NSUserDefaults
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [delegate.favoriteList removeObjectForKey:foodItem.number];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"Info"]){
        FavoritesInfo *infoView =
        [segue destinationViewController];
        infoView.foodItem = (FoodItem*)self.favoriteListArray[indexPath.row];
        [[[[infoView.tabBarController tabBar]items]objectAtIndex:3]setEnabled:YES];
    } else if ([segue.identifier isEqualToString:@"ShowFavoritesForComparison"]) {
        NSMutableArray *favoriteItems = [[NSMutableArray alloc]init];
        for (int i=0; i<self.favoriteListArray.count; i++) {
            NSDictionary *items = @{@"name":[self.favoriteListArray[i] name],@"number":[self.favoriteListArray[i]number]};
            [favoriteItems addObject:items];
        }
        NSLog(@"Num items favorites: %lu", (unsigned long)self.favoriteListArray.count);
        NSLog(@"Num items array: %lu", (unsigned long)favoriteItems.count);
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.searchResultForComparison = favoriteItems;
    }
    else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
