//
//  NewFeedsViewController.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "NewFeedsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DetailViewController.h"
#import "VideoViewController.h"

@interface NewFeedsViewController ()

@end

@implementation NewFeedsViewController
{
@private
    NSArray* _feeds;
}

@synthesize username;


@synthesize videoplayer,audioplayer;

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
    [self.refreshControl beginRefreshing];
    // Update the table
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)viewDidLoad
{
    self.title = @"News Feed";
    [super viewDidLoad];
    
    username = [[NSMutableDictionary alloc] init];
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
                for (int i =0; i<[_feeds count]; i++) {
                    feedSourceManager *f = [_feeds objectAtIndex:i];
                    NSString* userid = [NSString stringWithFormat:@"coomko/index.php/uploads/getUsername/%d", (int)f.userid];
                    NSString* d_username;
                    d_username = [username objectForKey:[NSString stringWithFormat:@"%d",(int)f.userid]];
                    if (d_username == nil) {
                        engine = [[MKNetworkEngine alloc]initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
                        MKNetworkOperation *op = [engine operationWithPath:userid
                                                                    params:nil
                                                                httpMethod:@"POST"
                                                                       ssl:NO];
                        __block MKNetworkOperation*b_op = op;
                        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                            NSString *name = [[[b_op responseJSON] objectForKey:@"account"] objectForKey:@"user"];
                            [username setValue:name forKey:[NSString stringWithFormat:@"%d",(int)f.userid]];
                            [self refreshControlRequest];
                        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                        }];
                        [engine enqueueOperation:op];
                    }
                }
            }
        }
    }];
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
        [cell setNeedsLayout];
    if ([cell._feed.type isEqualToString: @"photo"]|| [cell._feed.type isEqualToString:@"image"]) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ uploaded a %@",[username objectForKey:[NSString stringWithFormat:@"%d",
                                                                                                     (int)cell._feed.userid]],cell._feed.type];
        NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",cell._feed.dataLocation]];
        [cell.imageView setImageWithURL:imageURL
                       placeholderImage:[UIImage imageNamed:@"loading.png"]];
        cell.detailTextLabel.text = [NSString stringWithFormat: @""];
    }
    else if([cell._feed.type isEqualToString:@"text"])
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ uploaded %@",[username objectForKey:[NSString stringWithFormat:@"%d",
                                                                                                     (int)cell._feed.userid]],cell._feed.type];
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", cell._feed.text];
    }
    else if([cell._feed.type isEqualToString:@"video"])
    {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ uploaded a %@",[username objectForKey:[NSString stringWithFormat:@"%d",
                                                                                                     (int)cell._feed.userid]],cell._feed.type];
        NSURL *videoURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",cell._feed.dataLocation]];
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:[videoURL absoluteString] done:^(UIImage *image,SDImageCacheType cacheType)
        {
            if (image != nil) {
                [cell.imageView setImage:image];
                [cell setNeedsLayout];
            }
            else{
                AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:videoURL options:nil];
                CMTime time = CMTimeMakeWithSeconds(0.0,600);
                AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                generator.appliesPreferredTrackTransform=TRUE;
                NSError *error = nil;
                CMTime actualTime;
                
                CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
                UIImage *thumbnail = [[UIImage alloc] initWithCGImage:image];
                [[SDImageCache sharedImageCache] storeImage:thumbnail forKey:[videoURL absoluteString]];
                [cell.imageView setImage:thumbnail];
                [cell setNeedsLayout];
            }
        }];
        
        cell.detailTextLabel.text = [NSString stringWithFormat: @""];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ uploaded %@",[username objectForKey:[NSString stringWithFormat:@"%d",
                                                                                                     (int)cell._feed.userid]],cell._feed.type];
        cell.detailTextLabel.text = @"play";
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    feedSourceManager* f = [_feeds objectAtIndex:indexPath.row];
    NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",f.dataLocation]];
    if([f.type isEqualToString:@"photo"] || [f.type isEqualToString:@"image"])
    {
        DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        UIImageView *detailView = [[UIImageView alloc] init];
        [detailView setBackgroundColor:[UIColor blackColor]];
        [detailView setImageWithURL:imageURL
                       placeholderImage:[UIImage imageNamed:@"icon-photo.png"]];
        detailViewController.view = detailView;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if([f.type isEqualToString:@"video"])
    {
        VideoViewController *videoviewcontroller = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
        self.videoplayer = [[MPMoviePlayerController alloc]initWithContentURL:imageURL];
        [videoplayer prepareToPlay];
        videoviewcontroller.view = videoplayer.view;
        [self.navigationController pushViewController:videoviewcontroller animated:YES];
    }
    else if([f.type isEqualToString:@"audio"])
    {
        NSURL* resourcePath = imageURL;

        NSData *_objectData = [NSData dataWithContentsOfURL:resourcePath];
        NSError *error;

        self.audioplayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
        audioplayer.numberOfLoops = 0;
        audioplayer.volume = 5.0f;
        [audioplayer prepareToPlay];
        
        if (audioplayer == nil)
            NSLog(@"%@", [error description]);
        else
            [audioplayer play];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FeedsCell heightForCellWithPost:[_feeds objectAtIndex:indexPath.row]];
}

@end
