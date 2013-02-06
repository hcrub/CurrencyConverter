//
//  AppDelegate.h
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import <UIKit/UIKit.h>
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DownloadCurrencyRates.h"

/* Class Declarations */
@class DownloadCurrencyRates;

/* Header Declaration */
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

/* Global Accessors */
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) DownloadCurrencyRates *dcr;

/* Global Methods */
+ (void) setDictionary:(NSMutableDictionary *)dictionary;
+ (NSMutableDictionary *) getDictionary;
+ (void) setNameArray:(NSMutableArray *)array;
+ (NSMutableArray *) getNameArray;
+ (void) setPriceArray:(NSMutableArray *)array;
+ (NSMutableArray *) getPriceArray;

@end
