//
//  ItemDetail.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-27.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ItemDetail.h"
#import "AppDelegate.h"
#import "FoodItem.h"

@interface ItemDetail ()

@property (weak, nonatomic) IBOutlet UILabel *foodItemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *energy;
@property (weak, nonatomic) IBOutlet UILabel *protein;
@property (weak, nonatomic) IBOutlet UILabel *fat;
@property (weak, nonatomic) IBOutlet UILabel *carbs;
@property (weak, nonatomic) IBOutlet UILabel *fibre;
@property (weak, nonatomic) IBOutlet UILabel *salt;
@property (weak, nonatomic) IBOutlet UILabel *water;
@property (nonatomic) NSDictionary *searchResult;
@property (nonatomic) NSDictionary *nutrientValues;
@property (nonatomic) NSMutableDictionary *favoriteList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addToFavoritesButton;

@property UIDynamicAnimator *animator;
@property UIGravityBehavior *gravity;
@property UICollisionBehavior* collisionBehavior;
@property UIDynamicItemBehavior *elasticityBehavior;

@end

@implementation ItemDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
     NSString *searchKey = [NSString stringWithFormat:@"%@", self.itemNumber];
    self.favoriteList = delegate.favoriteList;
    if ([self.favoriteList valueForKey:searchKey] == nil) {
        self.addToFavoritesButton.enabled = YES;
        self.addToFavoritesButton.title = @"Add To Favorites";
    } else {
        self.addToFavoritesButton.enabled = NO;
        self.addToFavoritesButton.title = @"";
    }
    
    // Need to check for saved queries as well.
    
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%@", self.itemNumber];
    NSLog(@"%@",searchString);
    NSURL *url = [NSURL URLWithString:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSLog(@"Error in reponse: %@", error);
            return;
        }
        NSError *parsingError = nil;
        self.searchResult =[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parsingError];
        if(!parsingError) {
            if(self.searchResult > 0) {
                self.nutrientValues = self.searchResult[@"nutrientValues"];
                 NSLog(@"num nutrient values: %lu",(unsigned long)self.nutrientValues.count);
                if (self.nutrientValues > 0) {
                    // update GUI
                    dispatch_async(dispatch_get_main_queue(),^{
                        self.foodItemNameLabel.text = self.searchResult[@"name"];
                        NSLog(@"float value: %.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"energyKcal"]]floatValue]);
                        if (self.nutrientValues[@"energyKcal"] != nil) {
                            self.energy.text =
                            [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"energyKcal"]]floatValue]];
                        } else {
                           self.energy.text = @"Not found";
                        }
                        if (self.nutrientValues[@"protein"] != nil) {
                            self.protein.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"protein"]]floatValue]];
                        } else {
                            self.protein.text = @"Not found";
                        }
                        if (self.nutrientValues[@"fat"] != nil) {
                            self.fat.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fat"]]floatValue]];
                        } else {
                            self.fat.text = @"Not found";
                        }
                        if (self.nutrientValues[@"carbohydrates"] != nil) {
                            self.carbs.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"carbohydrates"]]floatValue]];
                        } else {
                            self.carbs.text = @"Not found";
                        }
                        if (self.nutrientValues[@"fibres"] != nil) {
                            self.fibre.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fibres"]]floatValue]];
                        } else {
                            self.fibre.text = @"Not found";
                        }
                        if (self.nutrientValues[@"salt"] != nil) {
                            self.salt.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"salt"]]floatValue]];
                        } else {
                            self.salt.text = @"Not found";
                        }
                        if (self.nutrientValues[@"water"] != nil) {
                            self.water.text = [NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"water"]]floatValue]];
                        } else {
                            self.water.text = @"Not found";
                        }
                    });
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No details found"
                     message:@"Sorry! No nutritional details found for the selected food item."
                     delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
                     [alert show];
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No details found"
                                                                message:@"Sorry! No nutritional details found for the selected food item."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        } else {
            NSLog(@"Couldn't parse json: %@", parsingError);
        }
    }];
    [task resume];
    
    UIView *labelFrame = [[UIView alloc] initWithFrame:
                          CGRectMake(16, 20, 200, 100)];
    [self.view addSubview:labelFrame];
    
    UILabel *labelText = [[UILabel alloc] initWithFrame:
                          CGRectMake(16, 20, 200, 25)];
    labelText.text = @"Näringsinnehåll";
    labelText.font = [UIFont fontWithName:@"Verdana-Bold" size:18];
    labelText.textColor = [UIColor blueColor];
    [labelFrame addSubview:labelText];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:labelFrame];
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[labelText]];
    [self.animator addBehavior:self.gravity];
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[labelText]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collisionBehavior];
    self.elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[labelText]];
    self.elasticityBehavior.elasticity = 0.7f;
    [self.animator addBehavior:self.elasticityBehavior];
}


- (IBAction)onAddToFavorites:(UIBarButtonItem *)sender {
    NSString *number = [NSString stringWithFormat:@"%@",self.itemNumber];
    NSString *name = self.foodItemNameLabel.text;
    float energy = [self.energy.text floatValue];
    float protein = [self.protein.text floatValue];
    float fat = [self.fat.text floatValue];
    float carbs = [self.carbs.text floatValue];
    float fibre = [self.fibre.text floatValue];
    float salt = [self.salt.text floatValue];
    float water = [self.water.text floatValue];
    FoodItem *foodItem;
    foodItem = [[FoodItem alloc] initWithNumber:number name:name energy:energy protein:protein fat:fat carbs:carbs fibre:fibre salt:salt water:water];
    NSLog(@"Item created: %@",foodItem);
    self.favoriteList[number] = foodItem;
    if ([self.favoriteList valueForKey:number] != nil) {
        NSLog(@"item added to favorites: %@",self.favoriteList[number]);
        NSLog(@"Num items in favorite list: %lu", (unsigned long)self.favoriteList.count);
    }
    self.addToFavoritesButton.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
