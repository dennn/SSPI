//
//  FirstViewController.m
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "MapViewController.h"
#import "Venue.h"
#import "Pin.h"
#import "AFNetworking.h"
#import "PinViewController.h"
#import "PhotoUploadViewController.h"
#import "AudioUploadViewController.h"
#import "TextUploadViewController.h"
#import "UploadViewController.h"
#import "VenueLayout.h"
#import "VenueViewController.h"

@interface MapViewController ()
{
    BOOL searching;
    BOOL shouldMoveToCurrentLocation;
    BOOL showingSearch;
    UploadType currentFilter;
}

@property (nonatomic, strong) IBOutlet MKMapView *currentMapView;
@property (nonatomic, strong) NSMutableDictionary *venues;
@property (nonatomic, assign) CLLocationDegrees zoomLevel;
@property (nonatomic, assign) BOOL changedMapRegion;
@property (nonatomic, strong) UIButton *userHeadingButton;

- (void)filterAnnotations:(NSMutableDictionary *)pinLocations;

@end

@implementation MapViewController

@synthesize search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"pinit";
        self.tabBarItem.image = [UIImage imageNamed:@"map"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];    
    //Add the search button to toggle the search bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(showSearch)];
    _changedMapRegion = FALSE;
    searching = FALSE;
    
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -60, 320, 44)];
    search.delegate = self;
    search.tintColor = [UIColor colorWithRed:30.0f/255.0f green:33.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    search.text = @"";

    [self.view addSubview:search];
    
    _venues = [NSMutableDictionary new];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapGesture:)];
    [_currentMapView addGestureRecognizer:tapGesture];
    
    /*
     * Add the new Pin menu in the bottom right. We then wait for a delegate callback whenever
     * one of the menu items are pressed and load the NewUploadViewController.
     */
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    AwesomeMenuItem *photoButton = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:[UIImage imageNamed:@"icon-photo"]
                                                  highlightedContentImage:nil];
    
    AwesomeMenuItem *videoButton = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:[UIImage imageNamed:@"icon-video"]
                                                  highlightedContentImage:nil];
    
    AwesomeMenuItem *audioButton = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:[UIImage imageNamed:@"icon-mic"]
                                                  highlightedContentImage:nil];
    
    AwesomeMenuItem *textButton = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                        highlightedImage:storyMenuItemImagePressed
                                                            ContentImage:[UIImage imageNamed:@"icon-write"]
                                                 highlightedContentImage:nil];
    
    NSArray *menuArray = @[photoButton, videoButton, audioButton, textButton];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.frame menus:menuArray];
    menu.menuWholeAngle = M_PI/180 * 90;
    menu.rotateAngle = M_PI/180 * -90;
    menu.startPoint = CGPointMake(290, 347);
    menu.delegate = self;
    
    [self.view addSubview:menu];
    
    /*
     Check whether there is a previous uploaded pin and if there is set the map to 
     be centered at that location
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CLLocationDegrees lat = [[defaults valueForKey:@"Latitude"] doubleValue];
    CLLocationDegrees lon = [[defaults valueForKey:@"Longitude"] doubleValue];
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(lat, lon);
    if (CLLocationCoordinate2DIsValid(CLLocationCoordinate2DMake(lat, lon)) && !((lat == 0) || (lon == 0))) {
        MKCoordinateRegion viewRegion = [_currentMapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoordinate, 10000, 10000)];
        [_currentMapView setCenterCoordinate:startCoordinate animated:YES];
        [_currentMapView setRegion:viewRegion animated:NO];
    } else {
        shouldMoveToCurrentLocation = TRUE;
        [_currentMapView setCenterCoordinate:_currentMapView.userLocation.location.coordinate animated:YES];
    }
    
    /* 
     Add the user tracking button
     https://github.com/jcalonso/iOS6MapsUserHeadingButton/blob/master/iOS6MapsUserHeadingButton/ViewController.m
     */
    
    //User Heading Button states images
    UIImage *buttonImage = [UIImage imageNamed:@"greyButtonHighlight.png"];
    UIImage *buttonImageHighlight = [UIImage imageNamed:@"greyButton.png"];
    UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
    
    //Configure the button
    _userHeadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userHeadingButton addTarget:self action:@selector(startShowingUserHeading:) forControlEvents:UIControlEventTouchUpInside];
    //Add state images
    [_userHeadingButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_userHeadingButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [_userHeadingButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [_userHeadingButton setImage:buttonArrow forState:UIControlStateNormal];
    
    //Position and Shadow
    _userHeadingButton.frame = CGRectMake(8,376,39,30);
    _userHeadingButton.layer.cornerRadius = 8.0f;
    _userHeadingButton.layer.masksToBounds = NO;
    _userHeadingButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _userHeadingButton.layer.shadowOpacity = 0.8;
    _userHeadingButton.layer.shadowRadius = 1;
    _userHeadingButton.layer.shadowOffset = CGSizeMake(0, 1.0f);
    
    [_currentMapView addSubview:_userHeadingButton];
    
    //Add toolbar with pin filter
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 376, 320, 44)];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Photo", @"Video", @"Audio", @"Text", @"All"]];
    segmentControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentControl addTarget:self action:@selector(valueChanged:) forControlEvents: UIControlEventValueChanged];
    UIBarButtonItem *segBarBtn = [[UIBarButtonItem alloc] initWithCustomView:segmentControl];
    UIBarButtonItem *space =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolbar setItems:@[space, segBarBtn, space] animated:YES];
    segmentControl.selectedSegmentIndex = 4;
    currentFilter = none;

    [self.view addSubview:toolbar];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (![search.text isEqualToString:@""]) {
        [self showSearch2];
    } 
}

- (void)valueChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

    switch (selectedSegment)
    {
        case 0:
            currentFilter = image;
            break;
            
        case 1:
            currentFilter = video;
            break;
            
        case 2:
            currentFilter = audio;
            break;
            
        case 3:
            currentFilter = text;
            break;
            
        case 4:
            currentFilter = none;
            break;
            
        default:
            currentFilter = none;
            break;
    }
    
    [self searchForString:@""];
}

- (void)hideSearch
{
    if (showingSearch == TRUE) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        search.frame = CGRectMake(0, -60, search.frame.size.width, search.frame.size.height);
        [UIView commitAnimations];
        [search resignFirstResponder];
        showingSearch = FALSE;
        search.text = @"";
        [self searchForString:search.text];
    } else {
        [self showSearch];
    }
}

- (void)showSearch
{
    if (showingSearch == FALSE) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        search.frame = CGRectMake(0, 0, search.frame.size.width, search.frame.size.height);
        [UIView commitAnimations];
        if ([search.text isEqualToString:@""]) {
            [search becomeFirstResponder];
        }
        showingSearch = TRUE;
    } else {
        [self hideSearch];
    }
}

- (void)showSearch2
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    search.frame = CGRectMake(0, 0, search.frame.size.width, search.frame.size.height);
    [UIView commitAnimations];
    if ([search.text isEqualToString:@""]) {
        [search becomeFirstResponder];
    }
    showingSearch = TRUE;
}

- (void)hideSearch2
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    search.frame = CGRectMake(0, -60, search.frame.size.width, search.frame.size.height);
    [UIView commitAnimations];
    [search resignFirstResponder];
    showingSearch = FALSE;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Grab the text from the search bar and send off a query
    if (![searchBar.text isEqualToString:@""]) {
        [self searchForString:searchBar.text];
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self hideSearch];
}

- (void)searchForString:(NSString *)string
{
    if (!searching) {
        searching = TRUE;
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/search/%f/%f/5/%@", (double)_currentMapView.region.center.longitude, (double)_currentMapView.region.center.latitude, string]];
        NSLog(@"Final URL %@", url);
    
        if (![string isEqualToString:@""]) {
        _changedMapRegion = TRUE;
        }
    
        [_venues removeAllObjects];
    
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            Venue *venue;
            for (NSDictionary *dict in [JSON valueForKeyPath:@"pins"])
            {
                NSString *key = [NSString stringWithFormat:@"%@", [dict valueForKey:@"location"]];
                Pin *newPin = [[Pin alloc] initWithDictionary:dict];
                if (currentFilter == newPin.uploadType || currentFilter == none) {
                    if ([_venues objectForKey:key] == nil) {
                        venue = [[Venue alloc] initWithVenueID:[NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]]];
                        venue.coordinate = CLLocationCoordinate2DMake([[dict valueForKey:@"lat"] doubleValue], [[dict valueForKey:@"long"] doubleValue]);
                        venue.venueName = [dict valueForKey:@"locationName"];
                    } else {
                        venue = [_venues objectForKey:key];
                    }
            
                    [venue addPin:newPin];
                    [_venues setObject:venue forKey:key];
                }
            }
            [self filterAnnotations:_venues];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if (![string isEqualToString:@""]) {
                UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find any pins with this tag" delegate:NULL cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [errorMessage show];
            }
        }];
    
        [operation start];
    }
}

- (void)mapTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    if ([search.text isEqualToString:@""]) {
        [self hideSearch2];
    }
    
    [search resignFirstResponder];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    } else {
        MKAnnotationView *annotationView = nil;
        static NSString *AnnotationIdentifier = @"VenueAnnotation";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
            pinView.animatesDrop = NO;
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.enabled = YES;
            pinView.canShowCallout = YES;
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.userInteractionEnabled = YES;
        }
        
        annotationView = pinView;

        return annotationView;
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (shouldMoveToCurrentLocation)
    {
        _currentMapView.centerCoordinate = userLocation.location.coordinate;
        shouldMoveToCurrentLocation = FALSE;
        MKCoordinateRegion viewRegion = [_currentMapView regionThatFits:MKCoordinateRegionMakeWithDistance(_currentMapView.centerCoordinate, 5000, 5000)];
        [_currentMapView setRegion:viewRegion animated:YES];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Venue *tempVenue = (Venue *)view.annotation;
    
    NSMutableArray *pins = [NSMutableArray new];
    if ([tempVenue venuesCount] > 1) {
        for (Venue *ven in tempVenue.venues) {
            [pins addObjectsFromArray:ven.pins];
        }
    } else {
        pins = tempVenue.pins;
    }
        
    /* We're looking at the venues, now check how many pins there are at this venues
       If there is one pin then load the pin viewer straight away. If there are multiple pins
       load the venue viewer first */
    if ([pins count] == 1) {
        PinViewController *pinController = [[PinViewController alloc] initWithNibName:@"PinViewController" bundle:nil andPin:[pins objectAtIndex:0]];
        [self.navigationController pushViewController:pinController animated:YES];
    } else {
        VenueViewController *venueController = [[VenueViewController alloc] initWithCollectionViewLayout:[[VenueLayout alloc] init]];
        venueController.pins = pins;
        [self.navigationController pushViewController:venueController animated:YES];
    }
}

- (void)filterAnnotations:(NSMutableDictionary *)pinLocations
{
    if (searching)
    {
        // Remove all pins from map view
        id userLocation = [_currentMapView userLocation];
        NSMutableArray *pinsToRemove = [[NSMutableArray alloc] initWithArray:[_currentMapView annotations]];
        if ( userLocation != nil ) {
            [pinsToRemove removeObject:userLocation]; // avoid removing user location off the map
        }
    
        // Cluster pins that are too close to each other
        float latDelta = _currentMapView.region.span.latitudeDelta/9.0;
        float longDelta = _currentMapView.region.span.longitudeDelta/11.0;
        NSMutableArray *venuesArray = [NSMutableArray new];
        for (NSString *key in pinLocations) {
            Venue *venue = (Venue *)[pinLocations objectForKey:key];
            [venue cleanChildren];
            [venuesArray addObject:venue];
        }
     
    
        NSMutableArray *pinsToShow = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [pinLocations count]; i++)
        {
            Venue *venueToCheck = [venuesArray objectAtIndex:i];
            CLLocationDegrees latitude = venueToCheck.coordinate.latitude;
            CLLocationDegrees longitude = venueToCheck.coordinate.longitude;
            
            bool found = FALSE;
            for (Venue *tempAnnotation in pinsToShow) {
                if(fabs(tempAnnotation.coordinate.latitude - latitude) < latDelta &&
                fabs(tempAnnotation.coordinate.longitude - longitude) < longDelta)
                {
                    if (venueToCheck != tempAnnotation) {
                        found = TRUE;
                        [tempAnnotation addChildVenue:venueToCheck];
                        break;
                    }
                }
            }
            if (!found) {
                [pinsToShow addObject:venueToCheck];
            }
        }
        
        NSArray *tempPinsToShow = [pinsToShow copy];
        NSArray *tempPinsToRemove = [pinsToRemove copy];
    
        for (Venue *venueOut in tempPinsToShow)
        {
            for (Venue *venueIn in tempPinsToRemove)
            {
                if ([venueIn.venueID isEqualToString:venueOut.venueID])
                {
                    if (([venueIn pinsCount] == venueOut.pinsCount) && (venueIn.venuesCount == venueOut.venuesCount))
                    {
                        [pinsToRemove removeObject:venueIn];
                        [pinsToShow removeObject:venueOut];
                    } 
                }
            }
        }
    
        [_currentMapView removeAnnotations:pinsToRemove];
        [_currentMapView addAnnotations:pinsToShow];

        pinsToRemove = nil;
        pinsToShow = nil;


        // Move the map to show the pins that have been found
        if (_changedMapRegion) {
            MKMapRect rectToShow = MKMapRectNull;

            for (id <MKAnnotation> annotation in _currentMapView.annotations) {
                if (![annotation isKindOfClass:[MKUserLocation class]]) {
                    MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);
                    rectToShow = MKMapRectUnion(rectToShow, MKMapRectMake(point.x-400, point.y-400, 800, 800));
                }
            }
        
            [_currentMapView setRegion:MKCoordinateRegionForMapRect(rectToShow) animated:YES];
            _changedMapRegion = FALSE;
        }
    
        searching = FALSE;
    }
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([_currentMapView.selectedAnnotations count] > 0) {
        for (id <MKAnnotation> annotation in _currentMapView.annotations) {
            [_currentMapView deselectAnnotation:annotation animated:NO];
        }
    }

    if (_zoomLevel != mapView.region.span.longitudeDelta)
    {
        if ([search.text isEqualToString:@""])
            [self searchForString:@""];
        _zoomLevel = mapView.region.span.longitudeDelta - 10.0;
    }
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    
    /* Upload order:
        1. Photo
        2. Video
        3. Audio
        4. Text
     */
    
   switch (idx)
    {
        case 0:
        {
            PhotoUploadViewController *uploadController = [[PhotoUploadViewController alloc] initWithMedia:@"photo" parent:self];
            [self presentViewController:uploadController animated:YES completion:nil];
            break;
        }
        case 1:
        {
            PhotoUploadViewController *uploadController = [[PhotoUploadViewController alloc] initWithMedia:@"video" parent:self];
            [self presentViewController:uploadController animated:YES completion:nil];
            break;
        }
        case 2:
        {
            AudioUploadViewController *uvc = [[AudioUploadViewController alloc] initWithParent:self];
            [self presentViewController:uvc animated:YES completion:nil];
            break;
            
        }
        case 3:
        {
            TextUploadViewController *uvc = [[TextUploadViewController alloc] initWithParent:self];
            UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:uvc];
            [self presentViewController:newNavController animated:YES completion:nil];
            break;
            
        }
    }
}

#pragma mark User Heading
- (IBAction) startShowingUserHeading:(id)sender{
    
    if(_currentMapView.userTrackingMode == 0){
        [_currentMapView setUserTrackingMode: MKUserTrackingModeFollow animated: YES];
        
        //Turn on the position arrow
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationBlue.png"];
        [_userHeadingButton setImage:buttonArrow forState:UIControlStateNormal];
        
    }
    else if(_currentMapView.userTrackingMode == 1){
        [_currentMapView setUserTrackingMode: MKUserTrackingModeFollowWithHeading animated: YES];
        
        //Change it to heading angle
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationHeadingBlue"];
        [_userHeadingButton setImage:buttonArrow forState:UIControlStateNormal];
    }
    else if(_currentMapView.userTrackingMode == 2){
        [_currentMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [_userHeadingButton setImage:buttonArrow forState:UIControlStateNormal];
    }
    
    
}

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    if(_currentMapView.userTrackingMode == 0){
        [_currentMapView setUserTrackingMode: MKUserTrackingModeNone animated: YES];
        
        //Put it back again
        UIImage *buttonArrow = [UIImage imageNamed:@"LocationGrey.png"];
        [_userHeadingButton setImage:buttonArrow forState:UIControlStateNormal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
