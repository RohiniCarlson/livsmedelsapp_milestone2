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
    
    UIImage *image = [UIImage imageWithContentsOfFile:[self cachePath:self.foodItem.number]];
    if (image) {
        self.foodPhoto.image = image;
    } else {
        self.foodPhoto.image = [UIImage imageNamed:@"apple"];
        NSLog(@"Failed to fetch image %@ from file system", [self cachePath:self.foodItem.number] );
    }
}

-(NSString*)cachePath:(NSString*)imageName {
    
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = dirs[0];
    NSString *completePath = [documentDirectory stringByAppendingPathComponent:[imageName stringByAppendingString:@".png"]];
    return completePath;
}

-(void) saveImageToCache:(UIImage*)image withName:(NSString*)imageName{
    NSString *imagePath = [self cachePath:imageName];
    NSData *data = UIImagePNGRepresentation(self.foodPhoto.image);
    BOOL success =[data writeToFile:imagePath atomically:YES];
    if (!success) {
        NSLog(@"Failed to save image to cache");
    } else {
        self.foodItem.imagePath = imagePath;
    }
}


- (IBAction)takePhoto:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.foodPhoto.image = image;
    [self saveImageToCache:image withName:self.foodItem.number];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
