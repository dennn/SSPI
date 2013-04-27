//
//  SettingsViewController.m
//  SSPI
//
//  Created by Den on 02/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "SettingsViewController.h"

#import "ServerViewController.h"
#import "AddServerViewController.h"
#import "ServerManager.h"

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
        servermanager = [ServerManager instance];
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    NSLog(@"reload");
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
    return 3;
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
            return 3;
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
            return @"Active Server";
            break;
        }
            
        case 2:
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
            NSString *server = [servermanager getActiveServerName];
            cell.textLabel.text = server;
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
        }
            
        case 1:
        {
            cell.textLabel.text = @"Add new server";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        }
           
            
        case 2:
        {
            switch (indexPath.row)
            {
                case 0:
                    cell.textLabel.text = @"UoB";
                    break;
                    
                case 1:
                    cell.textLabel.text = @"IBM";
                    break;
                    
                case 2:
                    cell.textLabel.text = @"Bristol Council";
                    break;
            }
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            int selectedBranding = [defaults integerForKey:@"branding"];
            
            if (indexPath.row == selectedBranding && ([defaults objectForKey:@"branding"] != nil))
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"NewBranding"
             object:self];
            
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
        /*
        case 1:
        {
            ServerViewController *serverViewController = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil section:1];
            [self.navigationController pushViewController:serverViewController animated:YES];
            break;
        }*/
            
        case 1:
        {           
            AddServerViewController *addServerViewController = [[AddServerViewController alloc]
                                                                initWithNibName: @"AddServerViewController" bundle:nil];
             [self.navigationController pushViewController:addServerViewController animated:YES];
            break;
        }
            
        case 2:
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:indexPath.row forKey:@"branding"];
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }
            
        default:
        {
            return;
        }
    }
}

@end
