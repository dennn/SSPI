//
//  LoginViewController.m
//  SSPI
//

//  Created by Hannah Oliver on 04/02/2013.

//  Created by Cheng Ma on 04/02/2013.

//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


@synthesize txtPassword,txtUsername,loginClicker,signUpClicker;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.



}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)loginClicker:(id)sender
{
    //incompleted for the login button
}

- (IBAction)signUpClicker:(id)sender
{
    //incompleted for the signup button
}

@end
