//
//  AppDelegate.m
//  The Movie DB
//
//  Created by Ricardo Sarto on 10/3/16.
//  Copyright © 2016 Ricardo Sarto Costa. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieDBClient.h"
#import "Realm/Realm.h"
#import "ConfigRealm.h"
#import "Helper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Status bar color
    application.statusBarStyle = UIStatusBarStyleLightContent;

    // Realm
    RLMRealm* realm      = [RLMRealm defaultRealm];
    ConfigRealm *config = [[ConfigRealm allObjects] firstObject];
    
    // Overcoat client to handle requests
    MovieDBClient* movieDBClient     = [[MovieDBClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];

    // Never loaded or first time today
    if (!config || [Helper isDateGreaterNoHour:[NSDate date] than:config.lastLoadGenres]) {

        // as we only want movies from today on we dont need old movies...
        // lets free some space and load again... maybe there is something new...
        [realm beginWriteTransaction];
        [realm deleteAllObjects];

        // could have used NSDefault... but realm is here anyway...
        ConfigRealm* config     = [[ConfigRealm alloc] init];
        config.lastLoadGenres   = [NSDate date];

        [realm addObject:config];
        [realm commitWriteTransaction];

        // Load Genres - maybe there are new Genres...
        [movieDBClient loadGenres];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
