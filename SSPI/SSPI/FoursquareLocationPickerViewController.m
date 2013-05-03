//
//  FoursquareLocationPickerViewController.m
//  SSPI
//
//  Created by Den on 24/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "FoursquareLocationPickerViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"

@interface FoursquareLocationPickerViewController ()
{
    UITableView *table;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *venuesArray;
@property (nonatomic, assign) BOOL researching;

@end

@implementation FoursquareLocationPickerViewController

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
	// Add map
    self.title = @"Choose a location";
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 250)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = TRUE;
    _researching = NO;
    
    // Do any additional setup after loading the view.
    
    [self.view addSubview:_mapView];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 376, 320, 44)];
    UIBarButtonItem *space =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"New Pin" style:UIBarButtonItemStyleBordered target:self action:@selector(createNewVenue)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:space, barButton, space, nil];
    [toolbar setItems:toolbarItems];
    
    [self.view addSubview:toolbar];
    
    // Add table
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 251, 320, 125) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeAllAnnotationExceptOfCurrentUser
{
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapView.annotations];
    
    for (id <MKAnnotation> annot_ in self.mapView.annotations)
    {
        if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
            [annForRemove removeObject:annot_];
            break;
        }
    }
    
    [self.mapView removeAnnotations:annForRemove];
}

- (void)proccessAnnotations{
    [self removeAllAnnotationExceptOfCurrentUser];
    [self.mapView addAnnotations:self.venuesArray];
    _researching = FALSE;
    [table reloadData];
}

- (void)getVenuesAtLocation:(CLLocation *)location
{
    [Foursquare2 searchVenuesNearByLatitude:@(location.coordinate.latitude)
                                  longitude:@(location.coordinate.longitude)
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:nil
                                      limit:nil
                                     intent:intentBrowse
                                     radius:@(500)
                                   callback:^(BOOL success, id result) {
                                       if(success)
                                       {
                                           NSDictionary *dic = result;
                                           NSArray* venues = [dic valueForKeyPath:@"response.venues"];
                                           FSConverter *converter = [[FSConverter alloc]init];
                                           self.venuesArray = [NSMutableArray arrayWithArray:[converter convertToObjects:venues]];
                                           [self proccessAnnotations];
                                       }
                                   }];
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

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [_locationManager stopUpdatingLocation];
    [self getVenuesAtLocation:newLocation];
    [self setupMapForLocation:newLocation];
}

#pragma mark -
#pragma mark MKMapView methods

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //Make sure we're not current searching
    if (_researching == FALSE) {
        _researching = TRUE;
        NSLog(@"Redoing search");
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
        [self getVenuesAtLocation:newLocation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    } else {

        static NSString *reuseId = @"StandardPin";
    
        MKPinAnnotationView *aView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
        if (aView == nil)
        {
            aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:reuseId];
            aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            aView.canShowCallout = YES;
        }
    
        aView.annotation = annotation;
    
        return aView;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FSVenue *currentAnnotation = view.annotation;
    Venue *newVenue = [[Venue alloc] initWithVenueID:nil];
    newVenue.venueName = currentAnnotation.name;
    newVenue.coordinate = currentAnnotation.coordinate;
    
    [self.delegate didPickVenue:newVenue];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Delegate methods

- (void)createNewVenue
{
    CreateNewLocationViewController *createLocationController = [CreateNewLocationViewController new];
    createLocationController.delegate = self;
    [self.navigationController pushViewController:createLocationController animated:YES];
}

- (void)didCreateNewVenue:(Venue *)venue
{
    NSLog(@"Calling delegate");
    [self.delegate didPickVenue:venue];
}

#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _venuesArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [_venuesArray[indexPath.row] name];
    FSVenue *venue = _venuesArray[indexPath.row];
    if (venue.location.address) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
                                     venue.location.distance,
                                     venue.location.address];
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                     venue.location.distance];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FSVenue *currentAnnotation = _venuesArray[indexPath.row];
    Venue *newVenue = [[Venue alloc] initWithVenueID:nil];
    newVenue.venueName = currentAnnotation.name;
    newVenue.coordinate = currentAnnotation.coordinate;
    
    [self.delegate didPickVenue:newVenue];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
