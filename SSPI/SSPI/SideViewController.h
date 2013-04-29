//
//  SideViewController.h
//  SSPI
//
//  Created by Den on 25/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadEngine.h"
#import "SyncViewController.h"

@interface SideViewController : UIViewController<SyncViewControllerDelegate>

-(void)loadMapPage:(id)sender;

@end
