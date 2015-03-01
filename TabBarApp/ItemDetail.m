//
//  ItemDetail.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-27.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "ItemDetail.h"

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

@end

@implementation ItemDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.foodItemNameLabel.text = self.item[@"name"];
  /*  NSMutableSet *executedQueries;
    [executedQueries addObject: @{@"name" :@"Dressing fett 0%%",
        @"number" : @44,
        @"nutrientValues" : @{
                          @"energyKj" : @250.0f,
                          @"energyKcal": @60.0f,
                          @"protein" : @1.6f,
                          @"fat": @0.0f}}];
    [executedQueries addObject: @{@"name" :@"Dressing fett 0%%",
        @"number" : @44,
        @"nutrientValues" : @{
                        @"energyKj" : @250.0f,
                        @"energyKcal": @60.0f,
                        @"protein" : @1.6f,
                        @"fat": @0.0f}}];
    [executedQueries addObject: @{@"name" :@"Morotssoppa",
        @"number" : @307,
        @"nutrientValues" : @{
                        @"energyKj" : @181.0f,
                        @"energyKcal": @43.0f,
                        @"protein" : @0.9f,
                        @"fat": @2.4f}}];*/
  //  NSLog(@"sortedSet: %@",executedQueries);
  //  NSLog(@"num items sortedSet: %lu",(unsigned long)executedQueries.count);
    
    //self.foodItemNumberLabel.text = [NSString stringWithFormat:@"%@", self.item[@"number"]];
    
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff/%@", self.item[@"number"]];
    NSLog(@"%@",searchString);
    // NSURL *url = [NSURL URLWithString:searchString];
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
                      // float num = [[NSString stringWithFormat:@"%@",self.nutrientValues[@"energyKcal"]]floatValue];
                        //NSLog(@"%@",self.nutrientValues[@"energyKcal"]);
                        NSLog(@"float value: %.2f",[[NSString stringWithFormat:@"%@",self.nutrientValues[@"energyKcal"]]floatValue]);
                        if (self.nutrientValues[@"energyKcal"] != nil) {
                            self.energy.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"energyKcal"]];
                        } else {
                           self.energy.text = @"Not found";
                        }
                        if (self.nutrientValues[@"protein"] != nil) {
                            self.protein.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"protein"]];
                        } else {
                            self.protein.text = @"Not found";
                        }
                        if (self.nutrientValues[@"fat"] != nil) {
                            self.fat.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"fat"]];
                        } else {
                            self.fat.text = @"Not found";
                        }
                        if (self.nutrientValues[@"carbohydrates"] != nil) {
                            self.carbs.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"carbohydrates"]];
                        } else {
                            self.carbs.text = @"Not found";
                        }
                        if (self.nutrientValues[@"fibres"] != nil) {
                            self.fibre.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"fibres"]];
                        } else {
                            self.fibre.text = @"Not found";
                        }
                        if (self.nutrientValues[@"salt"] != nil) {
                            self.salt.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"salt"]];
                        } else {
                            self.salt.text = @"Not found";
                        }
                        if (self.nutrientValues[@"water"] != nil) {
                            self.water.text = [NSString stringWithFormat:@"%@",self.nutrientValues[@"water"]];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
