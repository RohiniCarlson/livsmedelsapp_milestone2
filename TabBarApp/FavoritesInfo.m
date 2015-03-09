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
@property (weak, nonatomic) IBOutlet UILabel *proteinLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fibreLabel;
@property (weak, nonatomic) IBOutlet UILabel *saltLabel;
@property (weak, nonatomic) IBOutlet UILabel *waterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodPhoto;

@end

@implementation FavoritesInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameLabel.text = self.foodItem.name;
    self.energyLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.energy];
    self.proteinLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.protein];
    self.fatLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.fat];
    self.carbsLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.carbs];
    self.fibreLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.fibre];
    self.saltLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.salt];
    self.waterLabel.text = [NSString stringWithFormat:@"%.2f", self.foodItem.water];
}


- (IBAction)takePhoto:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.foodPhoto setImage:image];
    [self dismissViewControllerAnimated:NO completion:nil];
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
