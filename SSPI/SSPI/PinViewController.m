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
#import "UIImage+Resize.h"

@interface PinViewController () {
    Pin *currentPin;
    UITableView *pinTableView;
    UIImageView *webImage;
}

@end

@implementation PinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPin:(Pin *)pin
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentPin = pin;
        webImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 245)];
        webImage.contentMode = UIViewContentModeScaleAspectFit;
        webImage.backgroundColor = [UIColor blackColor];
        [self.view addSubview:webImage];
        pinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 247, 320, 230)];
        pinTableView.delegate = self;
        pinTableView.dataSource = self;
        [self.view addSubview:pinTableView];
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
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/getPin/%i/", currentPin.pinID]];
    NSLog(@"Final URL: %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        currentPin.uploadDate = [NSDate dateWithTimeIntervalSince1970:[[JSON valueForKey:@"date"] intValue]];
        currentPin.pinID = [JSON valueForKey:@"id"];
        //Create a new User object
        User *newUser = [User new];
        newUser.userID = [JSON valueForKey:@"userid"];
        currentPin.uploadUser = newUser;
        //Data location holds the URL of the uploaded media
        currentPin.dataLocation = [NSURL URLWithString:[JSON valueForKey:@"dataLocation"]];
        Venue *newVenue = [Venue new];
        newVenue.venueID = [JSON valueForKey:@"foursquareid"];
        currentPin.venueLocation = newVenue;
        //Get the upload type
        NSString *uploadType = [JSON valueForKey:@"type"];
        if ([uploadType isEqualToString:@"image"]) {
            currentPin.uploadType = image;
        } else if ([uploadType isEqualToString:@"audio"]) {
            currentPin.uploadType = audio;
        } else if ([uploadType isEqualToString:@"text"]) {
            currentPin.uploadType = text;
        } else if ([uploadType isEqualToString:@"video"]) {
            currentPin.uploadType = video;
        }
        
        self.title = [NSString stringWithFormat:@"%@'s photo", currentPin.uploadUser.name];
        [webImage setImageWithURL:currentPin.dataLocation];        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"Voting";
            break;
            
        case 1:
            cell.textLabel.text = @"Uploaded by-";
            break;
            
        case 2:
            cell.textLabel.text = @"Uploaded on-";
            cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:currentPin.uploadDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
            break;
            
        case 3:
            cell.textLabel.text = @"Venue";
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            break;
    }
    
    return cell;
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
