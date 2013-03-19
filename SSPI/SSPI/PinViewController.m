//
//  PinViewController.m
//  SSPI
//
//  Created by Den on 17/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "PinViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

@interface PinViewController () {
    Venue *currentVenue;
}

@end

@implementation PinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andVenue:(Venue *)venue;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentVenue = venue;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = back;
    
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/getPin/%i/", currentVenue.venueID]];
    NSLog(@"Final URL: %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        currentVenue.imageSource = [NSURL URLWithString:[JSON valueForKey:@"dataLocation"]];
        currentVenue.userID = [JSON valueForKey:@"userid"];
        
        UIImageView *webImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 250, 250)];
        [webImage setImageWithURL:currentVenue.imageSource];
        [self.view addSubview:webImage];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}

- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
