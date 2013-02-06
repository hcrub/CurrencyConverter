//
//  SecondViewController.m
//  CurrencyConverter
//
//  Created by Burchfield, Neil on 2/5/13.
//  Copyright (c) 2013 Burchfield, Neil. All rights reserved.
//

/* Imports */
#import "SecondViewController.h"

/* Implementation Declaration */
@implementation SecondViewController

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
        self.title = NSLocalizedString(@"Exchange Rates", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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
    return 1;
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
    return [[AppDelegate getDictionary] count];
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
    return @"All Rates";
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
    
    // Try to retrieve from the table view a now-unused cell with the given identifier.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:main_cell_identifier];
    
    // If no cell is available, create a new one using the given identifier.
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:main_cell_identifier];
        
        cell.textLabel.text = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = [[AppDelegate getPriceArray] objectAtIndex:indexPath.row];
        cell.accessoryView = label;
    }

    return cell;
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
    
    return nil;
}


@end
