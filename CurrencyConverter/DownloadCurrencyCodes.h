//
//  DownloadCurrencyCodes.h
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/6/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import <Foundation/Foundation.h>
#import "AppDelegate.h"

/* Header Declaration */
@interface DownloadCurrencyCodes : NSObject {
    
    /* Variables */
    NSURLConnection *connection;
    NSMutableData *data;
    NSURL *downloadURL;
}

/* Global Accessor */
- (void) downloadUrl;

@end