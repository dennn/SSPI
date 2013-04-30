//
//  ServerViewController.m
//  SSPI
//
//  Created by Den on 02/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "ServerViewController.h"
#import "ServerManager.h"

@interface ServerViewController ()
{
    int flag;
}
@end

@implementation ServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil flag:(int)pageflag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Choose server";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(backToHome)];
        servermanager = [ServerManager instance];
    }
    flag = pageflag;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
        return [servermanager tablesize]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = [servermanager getActiveServerName];
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        NSString *cellname = [servermanager getNameAtIndex: indexPath.row-1];
        cell.textLabel.text= cellname;
    }
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.row == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Cannot remove the active server"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];

        }
        else
        {
            [servermanager deleteServerByIndex:indexPath.row-1];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
        UIActionSheet* actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Set Active"  otherButtonTitles:nil, nil];
        [actionsheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (self.tableView.indexPathForSelectedRow.row != 0)
        {
            AFHTTPClient* temp = [servermanager getActiveServer];
            [servermanager updateActiveServer:[servermanager searchServerByIndex:self.tableView.indexPathForSelectedRow.row-1]];
            [servermanager deleteServerByIndex: self.tableView.indexPathForSelectedRow.row-1];
            [servermanager addServerByHTTPClient:temp];
            [self.tableView reloadData];
            [self viewDidAppear:YES];
            if (flag == 0) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else{
            [self.parentViewController.navigationController popToRootViewControllerAnimated:NO];
            }
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"server is already active"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)backToHome
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
