//
//  BarItem.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-19.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//

#import "BarItem.h"

@implementation BarItem
- (NSInteger)numberOfBars{
    return 5;
}
- (NSNumber *)valueForBarAtIndex:(NSInteger)index{
    return self.item[index];
}

- (UIColor *)colorForBarAtIndex:(NSInteger)index{
    //return [UIColor colorWithHue:(float)index/5.0f saturation:1.0f brightness:1.0f alpha:1.0f];
    return self.colors[index];
}

- (UIColor *)colorForBarBackgroundAtIndex:(NSInteger)index{
    return [UIColor colorWithWhite:0.0f alpha:0.0f];
    //return [UIColor whiteColor];
}
- (CFTimeInterval)animationDurationForBarAtIndex:(NSInteger)index{
    return 0.5f;
}

- (NSString *)titleForBarAtIndex:(NSInteger)index{
    return self.titles[index];
}

@end
