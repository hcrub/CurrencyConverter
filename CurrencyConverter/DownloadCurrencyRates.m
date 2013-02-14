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
    
    NSMutableDictionary *fetchedDictionary = [[[[JSON valueForKey:@"list"]
                                                     valueForKey:@"resources"]
                                                     valueForKey:@"resource"]
                                                     valueForKey:@"fields"];
    
    // Sort Dictionary
    NSMutableDictionary *parsedDictionary = [[NSMutableDictionary alloc] init];
    for ( int foo = 0; foo < fetchedDictionary.count; foo++ ) {
        
        // Parse Symbols
        NSString *original = [[fetchedDictionary valueForKey:@"name"] objectAtIndex:foo];
        if ([original rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]].location != NSNotFound)
        {
            original = [original substringFromIndex:NSMaxRange([original rangeOfString:@"/"])];
        }
        else
        {
            original = [original stringByReplacingOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [original length])];
        }
        
        // Add Values for Keys in new object
        [parsedDictionary setObject:[[fetchedDictionary valueForKey:@"price"] objectAtIndex:foo] forKey:original];
        
    }
    
    // Stash Results on AppDelegate Methods
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
    return [[[dictionary allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] copy];
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
    int index = 0;
    NSMutableArray *values = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary)
    {
        [values addObject:[dictionary valueForKey:[[self parseDictionaryNames:dictionary] objectAtIndex:index]]];
        index++;
    }
    
    return [values copy];
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
