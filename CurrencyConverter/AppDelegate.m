//
//  AppDelegate.m
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import "AppDelegate.h"

/* Statics */
static NSMutableDictionary *currencyDictionary;
static NSMutableArray *nameArray;
static NSMutableArray *priceArray;

/* Main Implementation */
@implementation AppDelegate
/* Synthesization */
@synthesize dcr = _dcr;

/*
 DidFinishLaunchingWithOptions
 --------
 Purpose:        Application Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UINavigationController *rvc1 = [[UINavigationController alloc] initWithRootViewController:viewController1];

    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UINavigationController *rvc2 = [[UINavigationController alloc] initWithRootViewController:viewController2];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[rvc1, rvc2];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

/*
 SetDictionary
 --------
 Purpose:        Copy Dictionary
 Parameters:     NSMutableDictionary
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
+ (void) setDictionary:(NSMutableDictionary *)dictionary
{
    currencyDictionary = [[NSMutableDictionary alloc] init];
    currencyDictionary = [dictionary copy];
}

/*
 GetDictionary
 --------
 Purpose:        Return Dictionary
 Parameters:     none
 Returns:        NSMutableDictionary
 Notes:          --
 Author:         Neil Burchfield
 */
+ (NSMutableDictionary *) getDictionary
{
    return currencyDictionary;
}

/*
 SetNameArray
 --------
 Purpose:        Copy Array
 Parameters:     NSMutableArray
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
+ (void) setNameArray:(NSMutableArray *)array
{
    nameArray = [[NSMutableArray alloc] initWithArray:array];
}

/*
 GetNameArray
 --------
 Purpose:        Return Array
 Parameters:     none
 Returns:        NSMutableArray
 Notes:          --
 Author:         Neil Burchfield
 */
+ (NSMutableArray *) getNameArray
{
    return nameArray;
}

/*
 SetPriceArray
 --------
 Purpose:        Copy Array
 Parameters:     NSMutableArray
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
+ (void) setPriceArray:(NSMutableArray *)array
{
    priceArray = [[NSMutableArray alloc] initWithArray:array];
}

/*
 GetNamePrice
 --------
 Purpose:        Return Array
 Parameters:     none
 Returns:        NSMutableArray
 Notes:          --
 Author:         Neil Burchfield
 */
+ (NSMutableArray *) getPriceArray
{
    return priceArray;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
