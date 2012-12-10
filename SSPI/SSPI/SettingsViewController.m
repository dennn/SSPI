//
//  SettingsViewController.m
//  SSPI
//
//  Created by Den on 02/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "SettingsViewController.h"

#import "ServerViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"settings"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    switch (section)
    {
        case 0:
            return 1;
            break;
            
        case 1:
            return 1;
            break;
            
        case 2:
            return 1;
            break;
            
        case 3:
            return 2;
            break;
            
        default:
        {
            return 0;
            break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return @"Active Servers";
            break;
        }
            
        case 1:
        {
            return @"Inactive Servers";
            break;
        }
            
        case 3:
        {
            return @"Branding";
            break;
        }
            
            
        default:
        {
            return @"";
            break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section)
    {
        case 0:
        {
            cell.textLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
        }
            
        case 2:
        {
            cell.textLabel.text = @"Add new server";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
           
            
        case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"UoB";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                    
                case 1:
                    cell.textLabel.text = @"IBM";
                    break;
            }
            break;
        }
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            ServerViewController *serverViewController = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil];
            [self.navigationController pushViewController:serverViewController animated:YES];
            break;
        }
            
        case 1:
        {
            ServerViewController *serverViewController = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil];
            [self.navigationController pushViewController:serverViewController animated:YES];
            break;
        }
            
        case 2:
        {
            ServerViewController *serverViewController = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil];
            [self.navigationController pushViewController:serverViewController animated:YES];
            break;
        }
            
        default:
        {
            return;
        }
    }
}

@end