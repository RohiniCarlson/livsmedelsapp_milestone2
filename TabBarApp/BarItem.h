//
//  BarItem.h
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-19.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GKBarGraph.h>

@interface BarItem : NSObject<GKBarGraphDataSource>

@property (nonatomic) NSArray *item;
@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *colors;

@end
