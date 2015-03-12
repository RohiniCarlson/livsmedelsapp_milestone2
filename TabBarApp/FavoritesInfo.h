//
//  FavoritesInfo.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-01.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodItem.h"

@interface FavoritesInfo : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) FoodItem *foodItem;

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;

@end
