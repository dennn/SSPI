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
#import "NewFeedsViewController.h"

@interface SideViewController ()

@property (nonatomic, strong) UIImageView *brandingImage;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNewLogo:)
                                                 name:@"NewBranding"
                                               object:nil];
    
        
    _brandingImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 67, 32)];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int selectedBranding = [defaults integerForKey:@"branding"];
    
    switch (selectedBranding) {
        case 0:
        {
            [_brandingImage setImage:[UIImage imageNamed:@"UOB.png"]];
            [_brandingImage setFrame:CGRectMake(10, 20, 67, 32)];
            break;
        }
            
        case 1:
        {
            [_brandingImage setImage:[UIImage imageNamed:@"IBM.png"]];
            [_brandingImage setFrame:CGRectMake(10, 20, 67, 32)];
            break;
        }
            
        case 2:
        {
            [_brandingImage setImage:[UIImage imageNamed:@"Council.jpeg"]];
            [_brandingImage setFrame:CGRectMake(10, 10, 67, 67)];
            break;
        }
            
        default:
            break;
    }

	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:57.0f/255.0f green:59.0f/255.0f blue:62.0f/255.0f alpha:1.0];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 90, 42, 34)];
    [mapButton setBackgroundImage:[UIImage imageNamed:@"Map-icon.png"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(loadMapPage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 160, 37, 33)];
    [userButton setBackgroundImage:[UIImage imageNamed:@"User-icon.png"] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(loadNewFeedsPage:) forControlEvents:UIControlEventTouchUpInside];
    
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
    [self.view addSubview:_brandingImage];
}

- (void)setNewLogo:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"NewBranding"])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        int selectedBranding = [defaults integerForKey:@"branding"];
        
        switch (selectedBranding) {
            case 0:
            {
                [_brandingImage setImage:[UIImage imageNamed:@"UOB.png"]];
                [_brandingImage setFrame:CGRectMake(10, 20, 67, 32)];
                break;
            }
                
            case 1:
            {
                [_brandingImage setImage:[UIImage imageNamed:@"IBM.png"]];
                [_brandingImage setFrame:CGRectMake(10, 20, 67, 32)];
                break;
            }
                
            case 2:
            {
                [_brandingImage setImage:[UIImage imageNamed:@"Council.jpeg"]];
                [_brandingImage setFrame:CGRectMake(10, 20, 67, 67)];
                break;
            }
        }
    }
}

- (void)loadMapPage:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil]];
}

- (void)loadSettingsPage:(id)sender
{
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil]];
}

- (void)loadNewFeedsPage:(id)sender
{
    
    self.sidePanelController.centerPanel = [[UINavigationController alloc] initWithRootViewController: [[NewFeedsViewController alloc] initWithNibName:@"NewFeedsViewController" bundle:nil]] ;
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
