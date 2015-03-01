//
//  SearchResultTableViewController.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic) NSArray *searchResult;

@end
