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
    int sectionNumber;
    ServerManager* servermanager;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil section:(int)flag;

@end
