//
//  SyncController.h
//  SSPI
//
//  Created by Ryan Connolly on 28/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadEngine.h"
#import "CustomMediaCell.h"
#import "NewUploadViewController.h"

@class SyncViewController;
@protocol SyncViewControllerDelegate
- (void)syncd;
@end

@interface SyncViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NewUploadViewControllerDelegate>{
    IBOutlet CustomMediaCell *_cell;
    NSMutableArray *stuff;
}

@property (nonatomic, strong) id <SyncViewControllerDelegate> delegate;

-(id)initWithStyle:(UITableViewStyle)style;
-(void)viewDidLoad;

@end
