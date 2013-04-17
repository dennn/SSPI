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

@end

@implementation ServerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil section:(int)flag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Server Setup", @"Server Setup");
        servermanager = [ServerManager instance];
        sectionNumber = flag;
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
    if (sectionNumber == 0)
    {
        //NSLog(@"%d", [servermanager tablesizeByName:@"active"]);
        return [servermanager tablesizeByName:@"active"];
    }
    else
    {
        //NSLog(@"%d", [servermanager tablesizeByName:@"inactive"]);
        return [servermanager tablesizeByName:@"inactive"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (sectionNumber == 0)
    {
        NSString *cellname = [servermanager getNameAtIndex: indexPath.row name:@"active"];
        cell.textLabel.text= cellname;
    }
    else
    {
        NSString *cellname = [servermanager getNameAtIndex: indexPath.row name:@"inactive"];
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
        if (sectionNumber ==0) {
            [servermanager deleteServerByIndex:indexPath.row name:@"active"];
        }
        else
            [servermanager deleteServerByIndex:indexPath.row name:@"inactive"];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (sectionNumber == 0) {
         UIActionSheet* actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Set Inactive"  otherButtonTitles:nil, nil];
        actionsheet.tag = sectionNumber;
        [actionsheet showInView:self.view];
    }
    else
    {
        UIActionSheet* actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:@"Set Active"  otherButtonTitles:nil, nil];
        actionsheet.tag = sectionNumber;
        [actionsheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if(actionSheet.tag == 0)
        {
            AFHTTPClient* temp = [servermanager searchServerByIndex:self.tableView.indexPathForSelectedRow.row name:@"active"];
            [servermanager addServerByHTTPClient:temp name:@"inactive"];
            [servermanager deleteServerByIndex: self.tableView.indexPathForSelectedRow.row name:@"active"];
            [self viewDidAppear:YES];
        }
        else
        {
            AFHTTPClient* temp = [servermanager searchServerByIndex:self.tableView.indexPathForSelectedRow.row name:@"inactive"];
            [servermanager addServerByHTTPClient:temp name:@"active"];
            [servermanager deleteServerByIndex: self.tableView.indexPathForSelectedRow.row name:@"inactive"];
            [self viewDidAppear:YES];
        }
    }
}
@end
