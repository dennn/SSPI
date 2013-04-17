//
//  AddServerViewController.h
//  SSPI
//
//  Created by Cheng Ma on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerManager.h"
@interface AddServerViewController : UIViewController<UITextFieldDelegate>
{
    NSString* serverpath;
    NSString* username;
    NSString* password;
    ServerManager* servermanager;
}

@property (weak, nonatomic) IBOutlet UITextField* txtpath;
@property (weak, nonatomic) IBOutlet UITextField* txtname;
@property (weak, nonatomic) IBOutlet UITextField* txtpass;
- (IBAction)Addbutton:(id)sender;


@end
