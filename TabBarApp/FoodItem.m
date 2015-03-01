//
//  FoodItem.m
//  Livsmedelsapp
//
//  Created by it-högskolan on 2015-02-20.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "FoodItem.h"

@implementation FoodItem

-(instancetype)initWithNumber:(NSString*)number name:(NSString*)name energy:(float)energy protein:(float)protein fat:(float)fat carbs:(float)carbs fibre:(float)fibre salt:(float)salt water:(float)water {
    self = [super init];
    if(self) {
        self.number = number;
        self.name = name;
        self.energy = energy;
        self.protein = protein;
        self.fat = fat;
        self.carbs = carbs;
        self.fibre = fibre;
        self.salt = salt;
        self.water = water;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.number forKey:@"number"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeFloat:self.energy forKey:@"energy"];
    [encoder encodeFloat:self.protein forKey:@"potein"];
    [encoder encodeFloat:self.fat forKey:@"fat"];
    [encoder encodeFloat:self.carbs forKey:@"carbs"];
    [encoder encodeFloat:self.fibre forKey:@"fibre"];
    [encoder encodeFloat:self.salt forKey:@"salt"];
    [encoder encodeFloat:self.water forKey:@"water"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.number = [decoder decodeObjectForKey:@"number"];
        self.name = [decoder decodeObjectForKey:@"name"];
        self.energy = [decoder decodeFloatForKey:@"energy"];
        self.protein = [decoder decodeFloatForKey:@"protein"];
        self.fat = [decoder decodeFloatForKey:@"fat"];
        self.carbs = [decoder decodeFloatForKey:@"carbs"];
        self.fibre = [decoder decodeFloatForKey:@"fibre"];
        self.salt = [decoder decodeFloatForKey:@"salt"];
        self.water = [decoder decodeFloatForKey:@"water"];
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@            fetthalt: %f", self.name, self.fat];
}

@end
