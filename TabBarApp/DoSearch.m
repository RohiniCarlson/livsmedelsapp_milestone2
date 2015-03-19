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
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIButton *fetchAllButton;

@end

@implementation DoSearch

- (void)viewWillAppear:(BOOL)animated {
    if (self.searchTextField.text.length > 0 || self.searchTextField.placeholder == nil) {
        self.fetchAllButton.enabled = NO;
    } else {
        self.fetchAllButton.enabled = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchButton.alpha = 0.0f;
    self.fetchAllButton.alpha = 0.0f;
    self.searchButton.transform = CGAffineTransformMakeScale(0.1,0.1);
    self.fetchAllButton.transform = CGAffineTransformMakeScale(0.1,0.1);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.5];
    self.searchButton.transform = CGAffineTransformMakeScale(1,1);
    self.fetchAllButton.transform = CGAffineTransformMakeScale(1,1);
    self.searchButton.alpha = 1.0f;
    self.fetchAllButton.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

- (IBAction)onChange:(UITextField *)sender {
    if (sender.text.length > 0) {
        NSLog(@"entered");
        self.fetchAllButton.enabled = NO;
    } else {
        NSLog(@"not entered");
        self.fetchAllButton.enabled = YES;
    }
}


- (IBAction)onFetchAll:(id)sender {
    /*if (self.searchTextField.text == nil) {
        self.fetchAllButton.enabled = YES;
    } else {
        self.fetchAllButton.enabled = NO;
    }*/
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff?query=%@",self.searchTextField.text];
    // Required to remove whitespace from entered search citeria
    searchString = [searchString stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
    }];
    [task resume];
    [self.view endEditing:YES];
}


- (IBAction)onSearch:(id)sender {
    NSString *searchString = [NSString stringWithFormat:@"http://matapi.se/foodstuff?query=%@",self.searchTextField.text];
    // Required to remove whitespace from entered search citeria
    searchString = [searchString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSURL *url = [NSURL URLWithString:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
        dispatch_async(dispatch_get_main_queue(), ^{
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
        });
    }];
    [task resume];
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"ShowSearchResult"]){
        SearchResultTableViewController*resultView = [segue destinationViewController];
        resultView.searchResult = self.searchResult;
        if (self.searchTextField.text.length > 0) {
            resultView.title = [self.searchTextField.text capitalizedString];
        } else {
            resultView.title = @"Alla Livsmedel";
        }
        
    }  else {
        NSLog(@"You forgot the segue %@",segue);
    }
}

@end

