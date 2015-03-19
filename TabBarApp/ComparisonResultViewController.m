//
//  ComparisonResultViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-03-16.
//  Copyright (c) 2015 it-h&#246;gskolan. All rights reserved.
//
#import <GKBarGraph.h>
#import "ComparisonResultViewController.h"
#import "FoodItem.h"
#import "BarItemOne.h"
#import "BarItemTwo.h"

@interface ComparisonResultViewController ()
@property (strong, nonatomic) IBOutlet UILabel *itemOneLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphOne;
@property (strong, nonatomic) IBOutlet UILabel *itemTwoLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphTwo;
@property (nonatomic) NSDictionary *searchResult;
@property (nonatomic) NSDictionary *nutrientValues;
@property (nonatomic) NSArray *titles;
@end

@implementation ComparisonResultViewController

- (void)viewWillAppear:(BOOL)animated {
    
    NSString *itemNameOne = self.itemsForComparison[0][@"name"];
    NSString *itemNameTwo = self.itemsForComparison[1][@"name"];
    if (itemNameOne.length > 15) {
        itemNameOne = [[itemNameOne substringToIndex:15]stringByAppendingString:@"..."];
    }
    if (itemNameTwo.length > 15) {
        itemNameTwo = [[itemNameTwo substringToIndex:15]stringByAppendingString:@"..."];
    }
    NSString *updatedTitle = [NSString stringWithFormat:@"%@/%@",itemNameOne,itemNameTwo];
    self.title = updatedTitle;
    [self getItemOneDetails:self.itemsForComparison[0][@"number"]];
    [self getItemTwoDetails:self.itemsForComparison[1][@"number"]];
    }

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemOneLabel.text = self.itemsForComparison[0][@"name"];
    self.itemTwoLabel.text = self.itemsForComparison[1][@"name"];
    self.titles = @[@"Protein",@"Fett",@"Kolhy.",@"Fibre",@"Vatten"];
}

-(void)getItemOneDetails:(NSString*)itemNumber{
    NSMutableArray *itemDetails = [[NSMutableArray alloc] init];
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%@", itemNumber];
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
                if(self.nutrientValues.count > 0) {
                    float proteinContent, fatContent, carbContent, fibreContent, waterContent;
                    if (self.nutrientValues[@"protein"] != nil) {
                        proteinContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"protein"]]floatValue]]floatValue];
                    } else {
                        proteinContent = 0.0f;
                    }
                    if (self.nutrientValues[@"fat"] != nil) {
                        fatContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fat"]]floatValue]]floatValue];
                    } else {
                        fatContent = 0.0f;
                    }
                    if (self.nutrientValues[@"carbohydrates"] != nil) {
                        carbContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"carbohydrates"]]floatValue]]floatValue];
                    } else {
                        carbContent = 0.0f;
                    }
                    if (self.nutrientValues[@"fibres"] != nil) {
                        fibreContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fibres"]]floatValue]]floatValue];
                    } else {
                        fibreContent = 0.0f;
                    }
                    if (self.nutrientValues[@"water"] != nil) {
                        waterContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"water"]]floatValue]]floatValue];
                    } else {
                        waterContent = 0.0f;
                    }
                    [itemDetails addObject:@(proteinContent)];
                    [itemDetails addObject:@(fatContent)];
                    [itemDetails addObject:@(carbContent)];
                    [itemDetails addObject:@(fibreContent)];
                    [itemDetails addObject:@(waterContent)];
                    dispatch_async(dispatch_get_main_queue(),^{
                        BarItemOne *itemOne = [[BarItemOne alloc]init];
                        itemOne.item = itemDetails;
                        itemOne.titles = self.titles;
                        self.barGraphOne.dataSource = itemOne;
                       /* self.barGraphOne.barWidth=10.0f;
                        self.barGraphOne.marginBar = 20.0f;*/
                        [self.barGraphOne draw ];
                        
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
}

-(void)getItemTwoDetails:(NSString*)itemNumber{
    NSMutableArray *itemDetails = [[NSMutableArray alloc] init];
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%@", itemNumber];
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
                if(self.nutrientValues.count > 0) {
                    float proteinContent, fatContent, carbContent, fibreContent, waterContent;
                    if (self.nutrientValues[@"protein"] != nil) {
                        proteinContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"protein"]]floatValue]]floatValue];
                    } else {
                        proteinContent = 0.0f;
                    }
                    if (self.nutrientValues[@"fat"] != nil) {
                        fatContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fat"]]floatValue]]floatValue];
                    } else {
                        fatContent = 0.0f;
                    }
                    if (self.nutrientValues[@"carbohydrates"] != nil) {
                        carbContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"carbohydrates"]]floatValue]]floatValue];
                    } else {
                        carbContent = 0.0f;
                    }
                    if (self.nutrientValues[@"fibres"] != nil) {
                        fibreContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"fibres"]]floatValue]]floatValue];
                    } else {
                        fibreContent = 0.0f;
                    }
                    if (self.nutrientValues[@"water"] != nil) {
                        waterContent = [[NSString stringWithFormat:@"%.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"water"]]floatValue]]floatValue];
                    } else {
                        waterContent = 0.0f;
                    }
                    [itemDetails addObject:@(proteinContent)];
                    [itemDetails addObject:@(fatContent)];
                    [itemDetails addObject:@(carbContent)];
                    [itemDetails addObject:@(fibreContent)];
                    [itemDetails addObject:@(waterContent)];
                    dispatch_async(dispatch_get_main_queue(),^{
                        BarItemTwo *itemTwo = [[BarItemTwo alloc]init];
                        itemTwo.item = itemDetails;
                        itemTwo.titles = self.titles;
                        self.barGraphTwo.dataSource = itemTwo;
                        [self.barGraphTwo draw ];
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
