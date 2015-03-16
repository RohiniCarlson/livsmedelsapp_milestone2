//
//  SearchResultTableViewCell.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-12.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *itemName;
@property (strong, nonatomic) IBOutlet UILabel *itemNameForComparison;
@property (nonatomic) NSString *itemNumber;
@end
