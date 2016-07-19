//
//  AppDelegate.m
//  BlocBrowser
//
//  Created by Jordan Johnson on 7/19/16.
//  Copyright © 2016 Bloc. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
//@interface ViewController : UIViewController
//@interface ViewController () <WKNavigationDelegate, UITextFieldDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];

    [self.window makeKeyAndVisible];
    
    //Welcome Message
    UIAlertController *welcomeMessage = [UIAlertController alertControllerWithTitle:@"Welcome"
                                                                   message:@"Welcome to Private Browsing.  All browser activity will be deleted upon the app becoming inactive"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Thanks" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [welcomeMessage addAction:defaultAction];
    [self.window.rootViewController presentViewController:welcomeMessage animated:YES completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    UINavigationController *navigationVC = (UINavigationController *)self.window.rootViewController;
    ViewController *browserVC = [[navigationVC viewControllers] firstObject];
    [browserVC resetWebView];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
