//
//  CreateNewLocationViewController.m
//  SSPI
//
//  Created by Den on 17/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "CreateNewLocationViewController.h"

@interface CreateNewLocationViewController ()

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITextField *venueName;
@property (nonatomic, assign) CLLocationCoordinate2D mapCoordinate;

@end

@implementation CreateNewLocationViewController

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
    
    self.title = @"Create a location";
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 60, 320, 400)];
    _mapView.delegate = self;
    _mapView.zoomEnabled = FALSE;
    _mapView.showsUserLocation = TRUE;
    
    _venueName = [[UITextField alloc] initWithFrame: CGRectMake(20, 15, 280, 20)];
    _venueName.placeholder = @"Venue Name";
    _venueName.textColor = [UIColor blackColor];
    _venueName.backgroundColor = [UIColor whiteColor];
    _venueName.delegate = self;
    _venueName.returnKeyType = UIReturnKeyDone;
    
    [self.view addSubview:_mapView];
    [self.view addSubview:_venueName];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)setupMapForLocation:(CLLocation*)newLocation{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    CLLocationCoordinate2D location;
    location.latitude = newLocation.coordinate.latitude;
    location.longitude = newLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [_mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self setupMapForLocation:userLocation.location];
    _mapCoordinate = userLocation.coordinate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_venueName resignFirstResponder];

    if (CLLocationCoordinate2DIsValid(_mapCoordinate))
    {
        Venue *newVenue = [[Venue alloc] initWithVenueID:nil];
        newVenue.venueName = _venueName.text;
        newVenue.coordinate = _mapCoordinate;
        [self.delegate didCreateNewVenue:newVenue];
        [self popControllersNumber:2];
    }
    return YES;
}


- (void) popControllersNumber:(int)number
{
    if (number <= 1)
        [[self navigationController] popViewControllerAnimated:YES];
    else
    {
        NSArray* controller = [[self navigationController] viewControllers];
        int requiredIndex = [controller count] - number - 1;
        if (requiredIndex < 0) requiredIndex = 0;
        UIViewController* requireController = [[[self navigationController] viewControllers] objectAtIndex:requiredIndex];
        [[self navigationController] popToViewController:requireController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
