//
//  LoginViewController.m
//  SSPI
//

//  Created by Hannah Oliver on 04/02/2013.

//  Created by Cheng Ma on 04/02/2013.

//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "UploadViewController.h"
#import "MapViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


@synthesize txtPassword,txtUsername,tabViewController,parentNavController,username,password;



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

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    if (theTextField == self.txtUsername || theTextField == self.txtPassword) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


- (IBAction)signUpPressed:(id)sender{
    NSLog(@"Sign Up Pressed");
}

- (IBAction)loginPressed:(id)sender{
    self.username = self.txtUsername.text;
    self.password = self.txtPassword.text;
    
    NSLog(@"username= %@, password= %@",self.username, self.password);
    UIViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    UIViewController *viewController2 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *settingsViewController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UIViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    self.tabViewController = [[UITabBarController alloc] init];
    [self.tabViewController setViewControllers: @[mapViewController,settingsViewController,uploadViewController] animated:NO];
    [self.parentNavController pushViewController:self.tabViewController animated:YES];
}

@end
