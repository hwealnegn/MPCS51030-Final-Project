//
//  AppDelegate.m
//  Align
//
//  Created by helenwang on 3/2/15.
//  Copyright (c) 2015 helenwang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

// Dismiss splash screen
- (void)dismissSplashScreen {
    // Reference for animation: http://stackoverflow.com/questions/9115854/animating-hide-show
    [UIView transitionWithView:self.splash duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL]; // delay dismissal
    [self.splash setHidden:YES];
    NSLog(@"Splash screen dismissed");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setPreferenceDefaults];
    
    // Reference: http://www.raywenderlich.com/21703/user-interface-customization-in-ios-6
    [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          nil]];
    
    // Splash screen
    self.splash = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    self.splash.backgroundColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.5 alpha:1.0];
    [self.window.rootViewController.view addSubview:self.splash];
    
    CGFloat labelHeight = 50.0;
    UILabel *splashTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.splash.frame.size.height-labelHeight)/2.0, self.splash.frame.size.width, labelHeight)];
    splashTitle.numberOfLines = 2;
    splashTitle.text = @"ALIGN\nHelen Wang";
    splashTitle.textAlignment = NSTextAlignmentCenter;
    splashTitle.textColor = [UIColor grayColor];
    splashTitle.backgroundColor = [UIColor clearColor];
    
    // Add images for splash screen background
    UIView *tmpView = [[UIView alloc] init];
    [self.splash addSubview:tmpView];
    
    UIImageView *splashOne = [[UIImageView alloc] initWithFrame:CGRectMake(0-(350-self.window.frame.size.width/2.0), 0-(350-self.window.frame.size.height/2.0), 700, 700)];
    [splashOne setImage:[UIImage imageNamed:@"splashScreenOne"]];
    [tmpView addSubview:splashOne];
    
    UIImageView *splashTwo = [[UIImageView alloc] initWithFrame:CGRectMake(0-(350-self.window.frame.size.width/2.0), 0-(350-self.window.frame.size.height/2.0), 700, 700)];
    [splashTwo setImage:[UIImage imageNamed:@"splashScreenTwo"]];
    [tmpView addSubview:splashTwo];
    [tmpView sendSubviewToBack:splashTwo];
    
    [self.splash addSubview:splashTitle];
    
    // Reference for adding delay: http://stackoverflow.com/questions/15335649/adding-delay-between-execution-of-two-following-lines
    double delayInTransition = 1.0;
    dispatch_time_t switchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInTransition * NSEC_PER_SEC));
    dispatch_after(switchTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.5 animations:^{
            splashOne.alpha = 0;
            splashTwo.alpha = 1;
        }];
    });
    
    NSLog(@"Splash screen is showing");
    
    // Dismiss splash screen after set amount of time
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissSplashScreen];
    });
    
    return YES;
}

- (void) setPreferenceDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:[NSDate date] forKey:@"Initial Launch"];
    [defaults registerDefaults:appDefaults];
    [defaults setValue:@"1.0" forKey:@"appVersion"];
    [defaults setValue:@"Helen Wang" forKey:@"appDev"];
    [defaults setValue:@"icons8.com for in-app icons" forKey:@"appCred"];
    [defaults synchronize];
    NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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
