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


@synthesize txtPassword,txtUsername,tabViewController,operation,uploadEngine,loginButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loginButton.alpha = 0.4;
    loginButton.enabled = NO;
    self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [txtPassword setSecureTextEntry:YES];
    self.txtUsername.text = @"";
    self.txtPassword.text = @"";
    username = @"";
    password = @"";
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


- (IBAction)registerPressed:(id)sender {
    username = self.txtUsername.text;
    password = self.txtPassword.text;
    NSMutableDictionary *regprams = [[NSMutableDictionary alloc] init];
    
    NSString *hashpass = [self sha256:password];
    [regprams setObject:username forKey:@"user"];
    [regprams setObject:hashpass forKey:@"pass"];
    
    self.operation = [self.uploadEngine postDataToServer:regprams path:@"coomko/index.php/users/register"];
    [operation onCompletion:^(MKNetworkOperation* operation) {
        NSLog(@"user:%@, pass:%@", username,hashpass);
        NSLog(@"return:%@", [self.operation responseString]);
            }  onError:^(NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }];
    [self.uploadEngine enqueueOperation:self.operation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)signUpPressed:(id)sender
{
    LoginViewController *registerViewController = [[LoginViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
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
        NSString *hashPass = [self sha256:password];
    
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:username forKey:@"user"];
        [dic setValue:hashPass forKey:@"pass"];
    
        self.operation = [self.uploadEngine postDataToServer:dic path:@"coomko/index.php/users/login"];
        [operation onCompletion:^(MKNetworkOperation *operation){
            if (![[self.operation responseString] isEqual: @"0"])
            {
                NSLog(@"Login Success!");
                
                //for keychain part
               // CFDataRef mydataRef = (CFDataRef)[mydataRef dataUsingEncoding]accessGroup:nil];
                NSMutableDictionary *keychain = [[NSMutableDictionary alloc] init];
                [keychain setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
                [keychain setObject:username forKey:(__bridge id)kSecAttrAccount];
                [keychain setObject:password forKey:(__bridge id)kSecValueData];
                OSStatus s = SecItemAdd((__bridge CFDictionaryRef)keychain, NULL);
                //[wrapper setObject:username forKey:(__bridge id)(kSecAttrAccount)];
                NSLog(@"add: %ld",s);
                
                [self gotoMainView];
            }
            else
            {
                NSLog(@"%@",[self.operation responseString]);
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
        [self.uploadEngine enqueueOperation:self.operation];
    }
}

-(NSString*) sha256:(NSString *)data
{
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
    [self.tabViewController setViewControllers: @[mapViewController,uploadViewController,settingsViewController] animated:YES];
    [self.navigationController pushViewController:self.tabViewController animated:YES];
}

@end
