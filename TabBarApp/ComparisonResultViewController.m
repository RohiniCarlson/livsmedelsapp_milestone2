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
#import "BarItem.h"

@interface ComparisonResultViewController ()
@property (strong, nonatomic) IBOutlet UILabel *itemOneLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphOne;
@property (strong, nonatomic) IBOutlet UILabel *itemTwoLabel;
@property (strong, nonatomic) IBOutlet GKBarGraph *barGraphTwo;

//Labels for item1
@property (strong, nonatomic) IBOutlet UILabel *proteinItemOne;
@property (strong, nonatomic) IBOutlet UILabel *fatItemOne;
@property (strong, nonatomic) IBOutlet UILabel *carbsItemOne;
@property (strong, nonatomic) IBOutlet UILabel *fibreItemOne;
@property (strong, nonatomic) IBOutlet UILabel *waterItemOne;

//Labels for item2
@property (strong, nonatomic) IBOutlet UILabel *proteinItemTwo;
@property (strong, nonatomic) IBOutlet UILabel *fatItemTwo;
@property (strong, nonatomic) IBOutlet UILabel *carbsItemTwo;
@property (strong, nonatomic) IBOutlet UILabel *fibreItemTwo;
@property (strong, nonatomic) IBOutlet UILabel *waterItemTwo;


@property (nonatomic) NSDictionary *searchResult;
@property (nonatomic) NSDictionary *nutrientValues;
@property (nonatomic) NSArray *titles;
@property (nonatomic) NSArray *colors;
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
    self.titles = @[@"Pr.",@"Fe.",@"Ko.",@"Fi.",@"Va."];
    self.colors = @[[UIColor redColor],
                    [UIColor yellowColor],
                    [UIColor greenColor],
                    [UIColor orangeColor],
                    [UIColor blueColor]];
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
                    float proteinContent, fatContent, carbContent, fibreContent, waterContent;                    if (self.nutrientValues[@"protein"] != nil) {
                        NSLog(@"Should print out protein label %@",[NSString stringWithFormat:@"Protein %@g",self.nutrientValues[@"protein"]]);
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
                        BarItem *itemOne = [[BarItem alloc]init];
                        itemOne.item = itemDetails;
                        itemOne.titles = self.titles;
                        itemOne.colors = self.colors;
                        self.barGraphOne.dataSource = itemOne;
                        self.barGraphOne.barWidth=10.0f;
                        [self.barGraphOne draw ];
                        // Set labels for item one
                        if (proteinContent > 0) {
                        self.proteinItemOne.text = [NSString stringWithFormat:@"Protein %.2fg",proteinContent];
                        } else {
                            self.proteinItemOne.text = @"Protein 0.0g";
                        }
                        if (fatContent > 0) {
                            self.fatItemOne.text = [NSString stringWithFormat:@"Fett %.2fg",fatContent];
                            
                        } else {
                            self.fatItemOne.text = @"Fett 0.0g";
                        }
                        if (carbContent > 0) {
                            self.carbsItemOne.text = [NSString stringWithFormat:@"Kolhydr. %.2fg",carbContent];
                        } else {
                            self.carbsItemOne.text = @"Kolhydr. 0.0g";
                        }
                        if (fibreContent > 0) {
                            self.fibreItemOne.text = [NSString stringWithFormat:@"Fibre %.2fg", fibreContent];
                        } else {
                            self.fibreItemOne.text = @"Fibre 0.0g";
                        }
                        if (waterContent > 0) {
                            self.waterItemOne.text = [NSString stringWithFormat:@"Vatten %.2fg", waterContent];
                        } else {
                            self.waterItemOne.text = @"Vatten 0.0g";
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
                        BarItem *itemTwo = [[BarItem alloc]init];
                        itemTwo.item = itemDetails;
                        itemTwo.titles = self.titles;
                        itemTwo.colors = self.colors;
                        self.barGraphTwo.dataSource = itemTwo;
                        self.barGraphTwo.barWidth=10.0f;
                        [self.barGraphTwo draw ];
                        // Set labels for item two
                        if (proteinContent > 0) {
                            self.proteinItemTwo.text = [NSString stringWithFormat:@"Protein %.2fg",proteinContent];
                        } else {
                            self.proteinItemTwo.text = @"Protein 0.0g";
                        }
                        if (fatContent > 0) {
                            self.fatItemTwo.text = [NSString stringWithFormat:@"Fett %.2fg",fatContent];
                            
                        } else {
                            self.fatItemTwo.text = @"Fett 0.0g";
                        }
                        if (carbContent > 0) {
                            self.carbsItemTwo.text = [NSString stringWithFormat:@"Kolhydr. %.2fg",carbContent];
                        } else {
                            self.carbsItemTwo.text = @"Kolhydr. 0.0g";
                        }
                        if (fibreContent > 0) {
                            self.fibreItemTwo.text = [NSString stringWithFormat:@"Fibre %.2fg", fibreContent];
                        } else {
                            self.fibreItemTwo.text = @"Fibre 0.0g";
                        }
                        if (waterContent > 0) {
                            self.waterItemTwo.text = [NSString stringWithFormat:@"Vatten %.2fg",waterContent];
                        } else {
                            self.waterItemTwo.text = @"Vatten 0.0g";
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
