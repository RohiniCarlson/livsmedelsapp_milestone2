//
//  FavoritesInfo.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-01.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "FavoritesInfo.h"

@interface FavoritesInfo ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;

@end

@implementation FavoritesInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.foodItem.name;
    self.energyLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.energy];
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
