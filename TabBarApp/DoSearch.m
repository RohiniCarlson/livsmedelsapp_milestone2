//
//  ViewController.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "DoSearch.h"
#import "SearchResultTableViewController.h"

@interface DoSearch ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic) NSArray *searchResult;

@end

@implementation DoSearch

- (void)viewWillAppear:(BOOL)animated {
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[[self.tabBarController tabBar]items]objectAtIndex:3]setEnabled:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Hides the keyboard when the user taps the return key on the soft keyboard.
- (IBAction)onReturn:(id)sender {
    [sender resignFirstResponder];
}

// Hides the keyboard when the user taps on the background.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchTextField isFirstResponder] && [touch view] != self.searchTextField) {
        [self.searchTextField resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)onSearch:(id)sender {
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff?query=%@",self.searchTextField.text];
    // Required to remove whitespace from entered search citeria
    searchString = [searchString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:searchString];
        //searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   //NSURL *url = [NSURL URLWithString:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url: %@",url);

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
            if(self.searchResult.count > 0) {
                [self performSegueWithIdentifier:@"ShowSearchResult" sender:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No results found"
                                                                message:@"Sorry! No search results matched your query."
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
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowSearchResult"]){
        SearchResultTableViewController*resultView = [segue destinationViewController];
        resultView.searchResult = self.searchResult;
    }  else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end

