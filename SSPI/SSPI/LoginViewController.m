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

@interface LoginViewController (){

}

@end

@implementation LoginViewController


@synthesize txtPassword,txtUsername,tabViewController,parentNavController,operation,uploadEngine,loginButton;



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
    loginButton.alpha = 0.4;
    loginButton.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    if (self.txtPassword.text.length > 0) {
        loginButton.alpha = 1.0;
        loginButton.enabled = YES;
    }else{
        loginButton.alpha = 0.4;
        loginButton.enabled = NO;
    }
    if (theTextField == self.txtUsername || theTextField == self.txtPassword) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}


- (IBAction)signUpPressed:(id)sender
{
    NSLog(@"Sign Up Pressed");
}

- (IBAction)loginPressed:(id)sender
{
    username = self.txtUsername.text;
    password = self.txtPassword.text;
    
    if (username.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Please enter the user name"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"username= %@, password= %@",username, password);
    
        NSString *hashPass = [self sha256:password];
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:username forKey:@"user"];
        [dic setValue:hashPass forKey:@"pass"];
    
        self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
        self.operation = [self.uploadEngine authTest:dic];
        [operation onCompletion:^(MKNetworkOperation *operation) {
            if ([[operation responseString] isEqual: @"1"])
            {
                NSLog(@"Login Success!");
                [self gotoMainView];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Login Failed"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                NSLog(@"Login Failed");
            }
        } onError:^(NSError *error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
        [self.uploadEngine enqueueOperation:self.operation ];
    }
}

-(NSString*) sha256:(NSString *)data{
    const char *s=[data cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData=[NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH]={0};
    CC_SHA256(keyData.bytes, keyData.length, digest);
    NSData *out=[NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash=[out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

-(void)gotoMainView
{
    UIViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    UIViewController *viewController2 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    UINavigationController *settingsViewController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UIViewController *uploadViewController = [[UploadViewController alloc] initWithNibName:@"UploadViewController" bundle:nil];
    self.tabViewController = [[UITabBarController alloc] init];
    [self.tabViewController setViewControllers: @[mapViewController,settingsViewController,uploadViewController] animated:NO];
    [self.parentNavController pushViewController:self.tabViewController animated:YES];
}

@end
