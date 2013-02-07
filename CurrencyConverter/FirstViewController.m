//
//  FirstViewController.m
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import "FirstViewController.h"

/* Definitions */
#define NUMBERS_ONLY    @"1234567890"
#define CHARACTER_LIMIT 10

/* Main Implementation */
@implementation FirstViewController

/*
   InitWithNibName
   --------
   Purpose:        Init/Alloc initial methods
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Currency Converter", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
} /* initWithNibName */


/*
   ViewDidLoad
   --------
   Purpose:        Init/Alloc initial methods
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];

    [self createPopover];

    // Load Exchange Codes
    [self downloadCurrencyExchangeCodes];
    // Load Exchange Rates
    [self downloadCurrencyExchangeRates];

    // Add Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateConversion:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:amountTextfield];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateConversion:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:conversionLabel];
} /* viewDidLoad */


/*
   ViewWillAppear
   --------
   Purpose:        Reload Data
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [toTableview reloadData];
} /* viewWillAppear */


/*
   CreatePopover
   --------
   Purpose:        Creates popover for selecting destination currency
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) createPopover {
    // Create Popover for iPad
    UIViewController *popoverViewController = [[UIViewController alloc] init];
    toTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
    toTableview.dataSource = self;
    toTableview.delegate = self;

    // Reload Data
    [toTableview reloadData];

    // Add Tableview to Popover
    [popoverViewController.view addSubview:toTableview];
    popover = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
    [popover setPopoverContentSize:CGSizeMake(300, 300)];
} /* createPopover */


/*
   DownloadCurrencyExchangeCodes
   --------
   Purpose:        Caches Currency Codes
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) downloadCurrencyExchangeCodes {
    // Downloads and places codes in dictionaries
    DownloadCurrencyCodes *downloadCodes = [[DownloadCurrencyCodes alloc] init];
    [downloadCodes downloadUrl];
} /* downloadCurrencyExchangeCodes */


/*
   downloadCurrencyExchangeRates
   --------
   Purpose:        Caches Currencies
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) downloadCurrencyExchangeRates {
    DownloadCurrencyRates *downloadRates = [[DownloadCurrencyRates alloc] init];
    [downloadRates downloadUrl];
} /* downloadCurrencyExchangeRates */


/*
   NumberOfSectionsInTableView
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == toTableview)
        return 1;

    return 5;
} /* numberOfSectionsInTableView */


/*
   NumberOfRowsInSection
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == toTableview)
        return [[AppDelegate getDictionary] count];

    return 1;
} /* tableView */


/*
   TitleForHeaderInSection
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (tableView == self.tableView) {
        switch (section) {
            case 0:
                return @"Enter Amount";

                break;
            case 1:
                return @"   From";

                break;
            case 2:
                return @"   To";

                break;
            case 3:
                return @"Conversion Rate (Buy/Sell)";

                break;
            case 4:
                return @"Results";

                break;
            default:
                return @"";

                break;
        } /* switch */
    }
    return @"";
} /* tableView */


/*
   KeyboardToolbar
   --------
   Purpose:        Adds done/cancel to keyboard
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (UIToolbar *) keyboardToolbar {
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];

    return numberToolbar;
} /* keyboardToolbar */


/*
   CellForRowAtIndexPath
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *main_cell_identifier = @"cell";
    NSString *from_cell_identifier = [NSString stringWithFormat:@"from_cell_%d", indexPath.row];

    UITableViewCell *cell;

    if (tableView == self.tableView) {
        // Try to retrieve from the table view a now-unused cell with the given identifier.
        cell = [tableView dequeueReusableCellWithIdentifier:main_cell_identifier];

        // If no cell is available, create a new one using the given identifier.
        if (cell == nil) {
            // Use the default cell style.
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:main_cell_identifier];
        }

        switch (indexPath.section) {
            case 0:
            {
                amountTextfield = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                amountTextfield.placeholder = @"Enter Value";
                amountTextfield.textAlignment = NSTextAlignmentRight;
                amountTextfield.returnKeyType = UIReturnKeyDone;
                amountTextfield.delegate = self;
                amountTextfield.text = enteredAmount;
                amountTextfield.inputAccessoryView = [self keyboardToolbar];
                cell.accessoryView = amountTextfield;
            }
            break;
            case 1:
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                label.backgroundColor = [UIColor clearColor];
                label.textAlignment = NSTextAlignmentRight;
                label.text = @"USD";
                cell.accessoryView = label;
            }
            break;
            case 2:
            {
                toLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                toLabel.backgroundColor = [UIColor clearColor];
                toLabel.textAlignment = NSTextAlignmentRight;
                toLabel.text = toConversionName;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView = toLabel;
            }
            break;
            case 3:
            {
                conversionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                conversionLabel.backgroundColor = [UIColor clearColor];
                conversionLabel.textAlignment = NSTextAlignmentRight;
                conversionLabel.text = toConversionAmount;
                cell.accessoryView = conversionLabel;
            }
            break;
            case 4:
            {
                resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                resultsLabel.backgroundColor = [UIColor clearColor];
                resultsLabel.textAlignment = NSTextAlignmentRight;
                resultsLabel.text = resultAmount;
                cell.accessoryView = resultsLabel;
            }
            break;
            default:
                break;
        } /* switch */
    } else if (tableView == toTableview) {
        // Try to retrieve from the table view a now-unused cell with the given identifier.
        cell = [tableView dequeueReusableCellWithIdentifier:from_cell_identifier];

        // If no cell is available, create a new one using the given identifier.
        if (cell == nil) {
            // Use the default cell style.
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:from_cell_identifier];

            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 21)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.textAlignment = NSTextAlignmentLeft;
            nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];

            // Place codes instead of code symbols
            if ([[AppDelegate getCodesDictionary] objectForKey:[[AppDelegate getNameArray] objectAtIndex:indexPath.row]] != nil)
                nameLabel.text = [NSString stringWithFormat:@"%@", [[[AppDelegate getCodesDictionary] objectForKey:[[AppDelegate getNameArray] objectAtIndex:indexPath.row]] valueForKey:@"name"]];
            else
                nameLabel.text = [NSString stringWithFormat:@"%@", [[AppDelegate getNameArray] objectAtIndex:indexPath.row] ];

            [cell.contentView addSubview:nameLabel];

            // Detail Label
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 22, 200, 21)];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.textAlignment = NSTextAlignmentLeft;
            detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:13.0f];
            detailLabel.textColor = [UIColor grayColor];
            detailLabel.text = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
            [cell.contentView addSubview:detailLabel];

            // Currency Values
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 125, 21)];
            valueLabel.backgroundColor = [UIColor clearColor];
            valueLabel.textAlignment = NSTextAlignmentLeft;
            valueLabel.font = [UIFont systemFontOfSize:14.0f];
            valueLabel.text = [[AppDelegate getPriceArray] objectAtIndex:indexPath.row];
            cell.accessoryView = valueLabel;
        }
    }

    return cell;
} /* tableView */


/*
   CalculateConversion
   --------
   Purpose:        Calculates and Sets Results
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) calculateConversion:(id)sender {
    enteredAmount = amountTextfield.text;

    if (![enteredAmount isEqualToString:@""] && (enteredAmount != NULL)) {
        float floatValue = [amountTextfield.text floatValue] * [toConversionAmount floatValue];
        resultAmount = [NSString stringWithFormat:@"%f", floatValue];
        resultsLabel.text = resultAmount;
    }
} /* calculateConversion */


/*
   CancelNumberPad
   --------
   Purpose:        Dismisses Pad
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) cancelNumberPad {
    [amountTextfield resignFirstResponder];
} /* cancelNumberPad */


/*
   DoneWithNumberPad
   --------
   Purpose:        Dismisses Pad
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (void) doneWithNumberPad {
    [amountTextfield resignFirstResponder];
} /* doneWithNumberPad */


/*
   To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */

/*
   WillSelectRowAtIndexPath
   --------
   Purpose:        Tableview Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.tableView) {
        if (indexPath.section == 2) {
            // Produce Popover
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            [popover presentPopoverFromRect:CGRectMake(rect.size.width - 300, rect.origin.y + rect.size.height / 2 + 57, 10, 10)
                                     inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionLeft
                                   animated:YES];
        }
    } else if (tableView == toTableview) {
        // Handle Selection and Calculate
        toConversionName = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
        toLabel.text = toConversionName;
        toConversionAmount = [[AppDelegate getPriceArray] objectAtIndex:indexPath.row];
        conversionLabel.text = toConversionAmount;
        [self calculateConversion:self];
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

    return nil;
} /* tableView */


/*
   ShouldChangeCharactersInRange
   --------
   Purpose:        TextField Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered]) && (newLength <= CHARACTER_LIMIT));
} /* textField */


/*
   textFieldShouldReturn
   --------
   Purpose:        TextField Delegate
   Parameters:     none
   Returns:        none
   Notes:          --
   Author:         Neil Burchfield
 */
- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
} /* textFieldShouldReturn */


@end
