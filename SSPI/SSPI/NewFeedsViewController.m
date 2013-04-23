//
//  NewFeedsViewController.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "NewFeedsViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                [self.tableView reloadData];
            }
        }
    }];
    
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_feeds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FeedsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FeedsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //[cell setFeeds:[UIImage imageNamed:@"Heart-icon.png"] ];
    // Configure the cell...
    cell._feed = [_feeds objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"userID:%i", (int)cell._feed.userid];
    cell.textLabel.text = [NSString stringWithFormat:@"feedID:%i, feed type:%@", (int)cell._feed.feedid, cell._feed.type];
    engine = [[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    if ([cell._feed.type isEqualToString: @"image"]) {
        NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",cell._feed.dataLocation]];
        [engine imageAtURL:imageURL completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            [cell.imageView setImage:fetchedImage];
            [self.tableView reloadData];
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
        NSLog(@"set image");
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
