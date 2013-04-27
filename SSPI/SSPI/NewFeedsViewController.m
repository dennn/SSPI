//
//  NewFeedsViewController.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "NewFeedsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewFeedsViewController ()

@end

@implementation NewFeedsViewController{
@private
    NSArray* _feeds;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
   
    }
    return self;
}

- (void)refreshControlRequest
{
    NSLog(@"refreshing...");
    [self.refreshControl beginRefreshing];
    // Update the table
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    self.title = @"New Feeds";
    //[self.view setBackgroundColor:[UIColor colorWithRed:0.08 green:0.55 blue:0.83 alpha:1]];
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlRequest) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl: refreshControl];
    
    [feedSourceManager globalTimelinePostsWithBlock:^(MKNetworkOperation *completedOperation, NSArray *posts, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil] show];
        } else {
            if(completedOperation)
            {
                _feeds = posts;
                for (feedSourceManager *f in posts) {
                    [f printAttributes];
                }
                [self refreshControlRequest];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.08 green:0.55 blue:0.83 alpha:.8]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:0.08 green:0.55 blue:0.83 alpha:.5]];
    }
    NSLog(@"%@",[cell.textLabel.backgroundColor description]);
    [self.tableView reloadInputViews];
    NSLog(@"set color");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    }
    // Configure the cell...
    cell._feed = [_feeds objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", cell._feed.text];
    cell.textLabel.text = [NSString stringWithFormat:@"User%i uploaded new %@",(int)cell._feed.userid,cell._feed.type];
    if ([cell._feed.type isEqualToString: @"photo"]|| [cell._feed.type isEqualToString:@"image"]) {
        NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",cell._feed.dataLocation]];
        [cell.imageView setImageWithURL:imageURL
                       placeholderImage:[UIImage imageNamed:@"User-icon.png"]];
    }
    else if([cell._feed.type isEqualToString:@"text"]){
        [cell setNeedsLayout];
    }
    else
    {
        [cell setNeedsLayout];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FeedsCell heightForCellWithPost:[_feeds objectAtIndex:indexPath.row]];
}

@end
