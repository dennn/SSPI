//
//  LoginViewController.h
//  SSPI
//

//  Created by Hannah Oliver on 04/02/2013.
//  Created by Cheng Ma on 04/02/2013.

//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "KeychainItemWrapper.h"
#import "MKNetworkKit.h"
#import "UploadEngine.h"
#import "JASidePanelController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate, UITabBarControllerDelegate,UIAlertViewDelegate>
{
    NSString *username;
    NSString *password;
}

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *createLabel;
- (IBAction)changeServer:(id)sender;

@property (nonatomic, strong) JASidePanelController *ViewController;

@property (strong, nonatomic) MKNetworkOperation *operation;
@property (strong, nonatomic) UploadEngine *uploadEngine;

- (IBAction)registerPressed:(id)sender;
- (IBAction)signUpPressed:(id)sender;
- (IBAction)loginPressed:(id)sender;
- (IBAction)back:(id)sender;

@end
