//
//  ComparisonSearchViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-13.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ComparisonSearchViewController.h"
#import "ComparisonTableTableViewController.h"
#import "AppDelegate.h"

@interface ComparisonSearchViewController ()

@property(nonatomic) int numResults;

@end

@implementation ComparisonSearchViewController

- (void)viewWillAppear:(BOOL)animated {

     AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.numResults = delegate.numResults;
    if(self.numResults > 0){
        delegate.numResults = 0;
        [self performSegueWithIdentifier:@"ShowComparisonSelection" sender:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ComparisonTableTableViewController *tableView = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowComparisonSelection"]){
        if(self.numResults > 0) {
            tableView.numResults = self.numResults;
        }
    } else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end
