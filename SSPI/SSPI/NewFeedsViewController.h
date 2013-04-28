//
//  NewFeedsViewController.h
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedSourceManager.h"
#import "FeedsCell.h"
#import "MKNetworkEngine.h"
#import "NewFeedsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DetailViewController.h"
#import "VideoViewController.h"

@interface NewFeedsViewController : UITableViewController
{
    feedSourceManager *feedsourcemanager;
    MKNetworkEngine* engine;
}

@property (nonatomic,strong) MPMoviePlayerController *videoplayer;
@end
