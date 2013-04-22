//
//  AddServerViewController.m
//  SSPI
//
//  Created by Cheng Ma on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "AddServerViewController.h"
#import "ServerManager.h"

@interface AddServerViewController ()

@end


@implementation AddServerViewController

@synthesize txtname,txtpass,txtpath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        servermanager = [ServerManager instance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    if (theTextField == self.txtname || theTextField == self.txtpass || theTextField == self.txtpath ) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)Addbutton:(id)sender {
    serverpath = self.txtpath.text;
    username = self.txtname.text;
    password = self.txtpass.text;
    /*if([username length] <1 || [password length]<1)
    {
        NSLog(@"empty username password");
        username = @"test";
        password = @"test";
    }*/
    NSLog(@"%@",serverpath);
    [servermanager addServerByPathAndAuth:serverpath User:username Pass:password Table:@"inactive"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end