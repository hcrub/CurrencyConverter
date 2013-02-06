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
#define NUMBERS_ONLY @"1234567890"
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Currency Converter", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

/*
 ViewDidLoad
 --------
 Purpose:        Init/Alloc initial methods
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    
    [self createPopover];
    
    [self downloadCurrencyExchangeRates];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateConversion:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:amountTextfield];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateConversion:)
                                                 name:@"UITextFieldTextDidChangeNotification" object:conversionLabel];
}

/*
 CreatePopover
 --------
 Purpose:        Creates popover for selecting destination currency 
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void) createPopover
{
    UIViewController *popoverViewController = [[UIViewController alloc] init];
    toTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
    toTableview.dataSource = self;
    toTableview.delegate = self;
    
    [popoverViewController.view addSubview:toTableview];
    popover = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
    [popover setPopoverContentSize:CGSizeMake(300, 300)];
}

/*
 downloadCurrencyExchangeRates
 --------
 Purpose:        Caches Currencies
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void) downloadCurrencyExchangeRates
{
    DownloadCurrencyRates *downloadRates = [[DownloadCurrencyRates alloc] init];
    [downloadRates downloadUrl];
}

/*
 NumberOfSectionsInTableView
 --------
 Purpose:        Tableview Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == toTableview)
        return 1;
    return 5;
}

/*
 NumberOfRowsInSection
 --------
 Purpose:        Tableview Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == toTableview)
        return [[AppDelegate getDictionary] count];
    return 1;
}

/*
 TitleForHeaderInSection
 --------
 Purpose:        Tableview Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.tableView)
    {
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
        }
    }
    return @"";
}

/*
 CellForRowAtIndexPath
 --------
 Purpose:        Tableview Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *main_cell_identifier = @"cell";
    static NSString *from_cell_identifier = @"from_cell";

    UITableViewCell *cell;
    
    if (tableView == self.tableView)
    {
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
                amountTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
                amountTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
                [amountTextfield setClearButtonMode:UITextFieldViewModeAlways];
                amountTextfield.delegate = self;
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
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView = toLabel;
            }
                break;
            case 3:
            {
                conversionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                conversionLabel.backgroundColor = [UIColor clearColor];
                conversionLabel.textAlignment = NSTextAlignmentRight;
                cell.accessoryView = conversionLabel;
            }
                break;
            case 4:
            {
                resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
                resultsLabel.backgroundColor = [UIColor clearColor];
                resultsLabel.textAlignment = NSTextAlignmentRight;
                cell.accessoryView = resultsLabel;
            }
                break;
            default:
                break;
        }
    }
    else if (tableView == toTableview)
    {
        // Try to retrieve from the table view a now-unused cell with the given identifier.
        cell = [tableView dequeueReusableCellWithIdentifier:from_cell_identifier];
        
        // If no cell is available, create a new one using the given identifier.
        if (cell == nil) {
            // Use the default cell style.
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:from_cell_identifier];
        }
        
        cell.textLabel.text = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
    }

    return cell;
}

/*
 CalculateConversion
 --------
 Purpose:        Calculates and Sets Results
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (void) calculateConversion:(id)sender
{
    if (![amountTextfield.text isEqualToString:@""] && toLabel.text != NULL)
    {
        float floatValue = [amountTextfield.text floatValue] * [conversionLabel.text floatValue];
        resultsLabel.text = [NSString stringWithFormat:@"$%f", floatValue];
    }
}

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
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView)
    {
        if (indexPath.section == 2)
        {
            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
            [popover presentPopoverFromRect:CGRectMake(rect.size.width - 300, rect.origin.y + rect.size.height/2 + 57, 10, 10)
                                     inView:self.navigationController.view permittedArrowDirections:UIPopoverArrowDirectionLeft
                                   animated:YES];
        }
    }
    else if (tableView == toTableview)
    {
        toLabel.text = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
        conversionLabel.text = [[AppDelegate getPriceArray] objectAtIndex:indexPath.row];
        [self calculateConversion:self];
        [popover dismissPopoverAnimated:YES];
    }
    
    return nil;
}

/*
 ShouldChangeCharactersInRange
 --------
 Purpose:        TextField Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return (([string isEqualToString:filtered])&&(newLength <= CHARACTER_LIMIT));
}

/*
 textFieldShouldReturn
 --------
 Purpose:        TextField Delegate
 Parameters:     none
 Returns:        none
 Notes:          --
 Author:         Neil Burchfield
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
