//
//  AppDelegate.m
//  TabBarApp
//
//  Created by it-högskolan on 2015-02-25.
//  Copyright (c) 2015 it-högskolan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self loadFromUserDefaults];
    return YES;
}

-(void) loadFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"favorites"];
    if (data != nil)
    {
        NSDictionary *oldSavedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (oldSavedDictionary != nil) {
            self.favoriteList = [[NSMutableDictionary alloc] initWithDictionary:oldSavedDictionary];
            NSLog(@"Favorite list initialised from NSUserDefaults");
        } else {
            self.favoriteList = [[NSMutableDictionary alloc] init];
        }
    } else {
        self.favoriteList = [[NSMutableDictionary alloc] init];
        NSLog(@"Favorite list initialised empty");
    }
}

-(void) saveToUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favoriteList];
    [defaults setObject:data forKey:@"favorites"];
    NSLog(@"Favorites saved to NSUserDefaults");
    [defaults synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveToUserDefaults];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
