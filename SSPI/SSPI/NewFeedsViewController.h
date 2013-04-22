//
//  NewFeedsViewController.h
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedSourceManager.h"
#import "AFNetworking.h"

@interface NewFeedsViewController : UIViewController
{
    feedSourceManager *feedsourcemanager;
}

- (IBAction)getFeeds:(UIButton *)sender;

@end
