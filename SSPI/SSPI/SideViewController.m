//
//  SideViewController.m
//  SSPI
//
//  Created by Den on 25/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "SideViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

#import "SettingsViewController.h"
#import "MapViewController.h"

@interface SideViewController ()

@end

@implementation SideViewController

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
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Side-BG.jpg"]];
    [self.view addSubview:backgroundImage];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 90, 42, 34)];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"Map-icon.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(loadMapPage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 160, 37, 33)];
    [userButton setBackgroundImage:[UIImage imageNamed:@"User-icon.png"] forState:UIControlStateNormal];
    
    UIButton *heartButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 230, 37, 34)];
    [heartButton setBackgroundImage:[UIImage imageNamed:@"Heart-icon.png"] forState:UIControlStateNormal];
    [heartButton addTarget:self action:@selector(sync:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 380, 37, 34)];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"Settings-icon.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(loadSettingsPage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:mapButton];
    [self.view addSubview:userButton];
    [self.view addSubview:heartButton];
    [self.view addSubview:settingsButton];
}

- (void)loadMapPage:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil]];
}

- (void)loadSettingsPage:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil]];
}

- (void)sync:(id)sender
{
    UploadEngine * ue = [[UploadEngine alloc] init];
    [ue syncPressed:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
