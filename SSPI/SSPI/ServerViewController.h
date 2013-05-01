//
//  ServerViewController.h
//  SSPI
//
//  Created by Den on 02/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"

@interface ServerViewController : UITableViewController<UIActionSheetDelegate>
{
    ServerManager* servermanager;
}

@property (nonatomic, assign) BOOL fromLogin;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil flag:(int)pageflag;

@end
