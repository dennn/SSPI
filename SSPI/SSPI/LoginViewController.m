//
//  LoginViewController.m
//  SSPI
//
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "UploadViewController.h"
#import "MapViewController.h"
#import "SideViewController.h"
#import "JASidePanelController.h"
#import "ServerManager.h"
#import "ServerViewController.h"

@interface LoginViewController (){

}

@end

@implementation LoginViewController


@synthesize txtPassword,txtUsername,operation,uploadEngine,loginButton, createLabel;


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
    self.navigationController.navigationBarHidden = YES;

    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 14)];
    UIImageView *loginImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginUser.png"]];
    loginImage.frame = CGRectMake(0, 0, 10, 12);
    [loginView addSubview:loginImage];
    self.txtUsername.leftView = loginView;
    self.txtUsername.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 14)];
    UIImageView *passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginPadlock.png"]];
    passwordImage.frame = CGRectMake(0, 0, 10, 12);
    [passwordView addSubview:passwordImage];
    self.txtPassword.leftView = passwordView;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    [self.txtPassword setSecureTextEntry:TRUE];
    
    UIView *emailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 14)];
    UIImageView *emailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Mail.png"]];
    emailImage.frame = CGRectMake(0, 0, 10, 12);
    [emailView addSubview:emailImage];
    self.txtEmail.leftView = emailView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    
    //Add create label
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signUpPressed:)];
    createLabel.userInteractionEnabled = YES;
    [createLabel addGestureRecognizer: gesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    self.navigationController.navigationBarHidden = YES;
    self.txtUsername.text = @"";
    self.txtPassword.text = @"";
    username = @"";
    password = @"";
    [self.txtPassword setSecureTextEntry:TRUE];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if([[userdefaults objectForKey:@"loginstatus"] isEqualToString:@"autologin"])
    {
        self.txtUsername.text = [userdefaults objectForKey:@"username"];
        self.txtPassword.text = [userdefaults objectForKey:@"password"];
        [self loginPressed:(id)loginButton];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    if (theTextField == self.txtUsername || theTextField == self.txtPassword || theTextField == self.txtEmail) {
        [theTextField resignFirstResponder];
    }
    return YES;
}


- (IBAction)registerPressed:(id)sender {
    username = self.txtUsername.text;
    password = self.txtPassword.text;
    NSMutableDictionary *regprams = [[NSMutableDictionary alloc] init];
    
    NSString *hashpass = [self sha256:password];
    [regprams setObject:username forKey:@"user"];
    [regprams setObject:hashpass forKey:@"pass"];
    
    self.operation = [self.uploadEngine postDataToServer:regprams path:@"coomko/index.php/users/register"];
    [operation addCompletionHandler:^(MKNetworkOperation* blockOperation) {
        if (![[blockOperation responseString] isEqual:@"0"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Register Success"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Register Failed"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            self.txtPassword.text = @"";
            self.txtUsername.text = @"";
            [alert show];
        }
            }  errorHandler:^(MKNetworkOperation *errorOp,NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }];
    [self.uploadEngine enqueueOperation:self.operation];
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
        operation = [uploadEngine postDataToServer:dic path:@"coomko/index.php/users/login"];
        __block NSString* b_username = username;
        __block NSString* b_password = password;
        [operation addCompletionHandler:^(MKNetworkOperation *blockOperation){
            if (![[blockOperation responseString] isEqual: @"0"])
            {
                NSLog(@"Login Success!");
                //for keychain part
                NSDictionary *dic = [blockOperation responseJSON];
                NSString *st= [dic objectForKey:@"id"];
                NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                [userdefaults setObject:b_username forKey:@"username"];
                [userdefaults setObject:st forKey:@"id"];
                [userdefaults setObject:b_password forKey:@"password"];
                [userdefaults setObject:@"autologin" forKey:@"loginstatus"];
                [userdefaults synchronize];
                
                [self gotoMainView];
            }
            else
            {
                NSLog(@"%@",[operation responseString]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Login Failed"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                NSLog(@"Login Failed");
            }
                } errorHandler:^(MKNetworkOperation *errorOp, NSError *error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[error localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Dismiss"
                                                          otherButtonTitles:nil];
            [alert show];
        }];
        [uploadEngine enqueueOperation:operation];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    self.ViewController = [[JASidePanelController alloc] init];
    self.ViewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.ViewController.leftFixedWidth = 90.0;
    
    UIViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    SideViewController *sideController = [[SideViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    self.ViewController.centerPanel = navController;
    self.ViewController.leftPanel = sideController;
    
    [self.navigationController pushViewController:self.ViewController animated:YES];
}

- (IBAction)changeServer:(id)sender {
    ServerViewController* serverView = [[ServerViewController alloc] initWithNibName:@"ServerViewController" bundle:nil flag:0];
    serverView.fromLogin = TRUE;
    UINavigationController *navControl = [[UINavigationController alloc] initWithRootViewController:serverView];
    navControl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navControl animated:YES completion:nil];
}
@end
