//
//  BarItemOne.h
//  GraphDemoTest
//
//  Created by it-högskolan on 2015-03-16.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GKBarGraph.h>

@interface BarItemOne : NSObject
<GKBarGraphDataSource>

@property (nonatomic) NSArray *item;
@property (nonatomic) NSArray *titles;

@end
