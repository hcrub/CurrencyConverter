//
//  DownloadCurrencyRates.m
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import "DownloadCurrencyRates.h"

/* Statics */
static NSString * url = @"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json";

/* Implementation Declaration */
@implementation DownloadCurrencyRates

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
    
    NSMutableDictionary *parsedDictionary = [[[[JSON valueForKey:@"list"]
                                                     valueForKey:@"resources"]
                                                     valueForKey:@"resource"]
                                                     valueForKey:@"fields"];
    [AppDelegate setDictionary:parsedDictionary];
    [AppDelegate setNameArray:[self parseDictionaryNames:parsedDictionary]];
    [AppDelegate setPriceArray:[self parseDictionaryPrices:parsedDictionary]];
}

/*
 ParseDictionaryNames
 --------
 Purpose:        Parse Currency Names
 Parameters:     NSMutableDictionary
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (NSMutableArray *) parseDictionaryNames:(NSMutableDictionary *)dictionary
{
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    NSMutableDictionary *namesDictionary =[[NSMutableDictionary alloc] init];
    namesDictionary = [dictionary copy];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for ( int x = 0; x < namesDictionary.count; x++)
    {
        NSString *original = [[namesDictionary valueForKey:@"name"] objectAtIndex:x];
        
        if ([original rangeOfCharacterFromSet:set].location != NSNotFound)
        {
            NSRange range = [original rangeOfString:@"/"];
            NSString *substring = [original substringFromIndex:NSMaxRange(range)];
            [array addObject:substring];
        }
    }
    return array;
}

/*
 ParseDictionaryPrices
 --------
 Purpose:        Parse Currency Prices
 Parameters:     NSMutableDictionary
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */

- (NSMutableArray *) parseDictionaryPrices:(NSMutableDictionary *)dictionary
{
    NSMutableDictionary *pricesDictionary =[[NSMutableDictionary alloc] init];
    pricesDictionary = [dictionary copy];

    NSMutableArray *array = [[NSMutableArray alloc] init];
    for ( int x = 0; x < pricesDictionary.count; x++)
    {
        [array addObject:[[pricesDictionary valueForKey:@"price"] objectAtIndex:x]];
    }
    return array;
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
