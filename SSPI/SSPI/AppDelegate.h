//
//  AppDelegate.h
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, retain) LoginViewController *loginViewController;
@property (strong, retain) UINavigationController *navigationController;

@end
