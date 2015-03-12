//
//  FoodItem.h
//  Livsmedelsapp
//
//  Created by it-högskolan on 2015-02-20.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodItem : NSObject<NSCoding>

@property (nonatomic) NSString *number;
@property (nonatomic) NSString *name;
@property (nonatomic) float energy;
@property (nonatomic) float protein;
@property (nonatomic) float fat;
@property (nonatomic) float carbs;
@property (nonatomic) float fibre;
@property (nonatomic) float salt;
@property (nonatomic) float water;
@property (nonatomic) NSString *imagePath;

-(instancetype)initWithNumber:(NSString*)number name:(NSString*)name energy:(float)energy protein:(float)protein fat:(float)fat carbs:(float)carbs fibre:(float)fibre salt:(float)salt water:(float)water;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (id)initWithCoder:(NSCoder *)decoder;

@end
