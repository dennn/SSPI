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


@interface LoginViewController : UIViewController<UITextFieldDelegate, UITabBarControllerDelegate>


@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) UITabBarController *tabViewController;
@property (nonatomic, assign) UINavigationController *parentNavController;

@property NSString *username;
@property NSString *password;

- (IBAction)signUpPressed:(id)sender;
- (IBAction)loginPressed:(id)sender;


@end
