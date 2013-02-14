//
//  FirstViewController.h
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DownloadCurrencyRates.h"

/* Header Declaration */
@interface FirstViewController : UITableViewController <UITextFieldDelegate> {

    /* Variables */
    UILabel *toLabel;
    UILabel *resultsLabel;
    UITableView *toTableview;
    UILabel *conversionLabel;
    UITextField *amountTextfield;
    UIPopoverController *popover;

    NSString *enteredAmount;
    NSString *resultAmount;
    NSString *toConversionAmount;
    NSString *toConversionName;
}

@end
