//
//  LoginViewController.h
//  SSPI
//

//  Created by Hannah Oliver on 04/02/2013.
//  Created by Cheng Ma on 04/02/2013.

//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIButton *signUpClicker;
@property (weak, nonatomic) IBOutlet UIButton *loginClicker;


@end
