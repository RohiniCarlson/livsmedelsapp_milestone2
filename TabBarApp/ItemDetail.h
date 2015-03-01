//
//  ItemDetail.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-27.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetail : UIViewController

@property (nonatomic) NSDictionary *item;
@property (nonatomic) NSArray *mainSearchResult;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToFavoritesButton;

@end
