//
//  DownloadCurrencyCodes.m
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/6/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

#import "DownloadCurrencyCodes.h"

/* Statics */
static NSString * url = @"https://gist.github.com/Fluidbyte/2973986/raw/9ead0f85b6ee6071d018564fa5a314a0297212cc/Common-Currency.json";

/* Implementation Declaration */
@implementation DownloadCurrencyCodes

/*
 DownloadUrl
 --------
 Purpose:        Initiates URL Connection
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void) downloadUrl {
    
    downloadURL = [NSURL URLWithString:url];
    data = [[NSMutableData alloc] init];
    connection = [[NSURLConnection alloc] initWithRequest: [NSURLRequest requestWithURL: downloadURL] delegate: self startImmediately: YES];
}

/*
 DidReceiveData
 --------
 Purpose:        Append Incoming Data
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)mdata {
    [data appendData: mdata];
}

/*
 ConnectionDidFinishLoading
 --------
 Purpose:        Parse Data - JSON
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    [AppDelegate setCodesDictionary:[JSON copy]];
}

/*
 DidFailWithError
 --------
 Purpose:        Ammend Failure
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Failed (%@)", [downloadURL absoluteString]);
}

@end
