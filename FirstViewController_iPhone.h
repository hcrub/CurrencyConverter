//
//  FirstViewController_iPhone.h
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/6/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DownloadCurrencyRates.h"
#import "DownloadCurrencyCodes.h"

/* Header Declaration */
@interface FirstViewController_iPhone : UITableViewController <UITextFieldDelegate> {
    
    /* Variables */
    UILabel *toLabel;
    UILabel *resultsLabel;
    UITableView *toTableview;
    UILabel *conversionLabel;
    UITextField *amountTextfield;
    
    NSString *enteredAmount;
    NSString *resultAmount;
    NSString *toConversionAmount;
    NSString *toConversionName;
}

@end