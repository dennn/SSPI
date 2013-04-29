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
    self.title = @"Add server";
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
     NSLog(@"%@",serverpath);
    AFHTTPClient* test = [[AFHTTPClient alloc]initWithBaseURL:[[NSURL alloc]initWithString:@"test"]];
    [servermanager checkValid:nil];
    [servermanager addServerByPathAndAuth:serverpath User:@"test" Pass:@"test"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
