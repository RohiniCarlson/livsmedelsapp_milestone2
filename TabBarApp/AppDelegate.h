//
//  AppDelegate.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic) NSMutableArray *detailQueries;

@property(nonatomic) NSMutableDictionary *favoriteList;

@property(nonatomic) int numResults;

@property(nonatomic) NSArray *searchResultForComparison;

@property(nonatomic) BOOL searchBarActive;


@end

