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
                
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 21)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        
        if ([[AppDelegate getCodesDictionary] objectForKey:[[AppDelegate getNameArray] objectAtIndex:indexPath.row]] != nil)
            nameLabel.text = [NSString stringWithFormat:@"%@", [[[AppDelegate getCodesDictionary] objectForKey:[[AppDelegate getNameArray] objectAtIndex:indexPath.row]] valueForKey:@"name"]];
        else
            nameLabel.text = [NSString stringWithFormat:@"%@", [[AppDelegate getNameArray] objectAtIndex:indexPath.row] ];
        
        [cell.contentView addSubview:nameLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 22, 200, 21)];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:13.0f];
        detailLabel.textColor = [UIColor grayColor];
        detailLabel.text = [[AppDelegate getNameArray] objectAtIndex:indexPath.row];
        [cell.contentView addSubview:detailLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 280, 21)];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.font = [UIFont systemFontOfSize:14.0f];
        valueLabel.text = [[AppDelegate getPriceArray] objectAtIndex:indexPath.row];
        cell.accessoryView = valueLabel;
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
