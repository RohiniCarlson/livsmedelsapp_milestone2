//
//  ComparisonResultViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-16.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
#import <GKBarGraph.h>
#import "ComparisonResultViewController.h"

@interface ComparisonResultViewController ()
@property (strong, nonatomic) IBOutlet UILabel *itemOneLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphOne;
@property (strong, nonatomic) IBOutlet UILabel *itemTwoLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphTwo;
@end

@implementation ComparisonResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemOneLabel.text = self.itemsForComparison[0][@"name"];
    self.itemTwoLabel.text = self.itemsForComparison[1][@"name"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
