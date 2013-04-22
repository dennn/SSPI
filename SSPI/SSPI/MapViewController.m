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

@interface MapViewController ()
{
    IBOutlet MKMapView *currentMapView;
    NSMutableDictionary *venues;
    CLLocationDegrees zoomLevel;
    BOOL searchBarShown;
}

- (void)filterAnnotations:(NSMutableDictionary *)pinLocations;

@end

@implementation MapViewController

@synthesize search;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Map", @"Map");
        self.tabBarItem.image = [UIImage imageNamed:@"map"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Add the search button to toggle the search bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(toggleSearch)];
    searchBarShown = FALSE;
    
    search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, -60, 320, 50)];
    search.delegate = self;
    search.showsCancelButton = TRUE;

    [self.view addSubview:search];
    
    venues = [NSMutableDictionary new];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapGesture:)];
    [currentMapView addGestureRecognizer:tapGesture];
    
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
    menu.startPoint = CGPointMake(290, 380);
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

- (void)toggleSearch
{
    if (searchBarShown)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        search.frame = CGRectMake(0, -60, search.frame.size.width, search.frame.size.height);
        [UIView commitAnimations];
        searchBarShown = FALSE;
    } else {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        search.frame = CGRectMake(0, 0, search.frame.size.width, search.frame.size.height);
        [UIView commitAnimations];
        searchBarShown = TRUE;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Grab the text from the search bar and send off a query
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/search/%f/%f/3/%@", (double)currentMapView.region.center.longitude, (double)currentMapView.region.center.latitude, searchBar.text]];
    NSLog(@"Final URL: %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        Venue *venue;
        for (NSDictionary *dict in [JSON valueForKeyPath:@"pins"])
        {
            NSString *key = [NSString stringWithFormat:@"%@", [dict valueForKey:@"location"]];
            Pin *newPin = [[Pin alloc] initWithPinID:[dict valueForKey:@"id"]];
            if ([venues objectForKey:key] == nil) {
                venue = [[Venue alloc] initWithVenueID:[NSString stringWithFormat:@"%@",[dict valueForKey:@"location"]]];
            } else {
                venue = [venues objectForKey:key];
            }
           
            [venue addPin:newPin];
            [venues setObject:venue forKey:key];
        }
        
        [self filterAnnotations:venues];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}

- (void)mapTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    if (search.isFirstResponder)
        [search resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [search setShowsCancelButton:YES animated:YES];
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Venue *tempVenue = (Venue *)view.annotation;
    if ([tempVenue venuesCount] == 1) {
        
        /* We're looking at one venue, now check how many pins there are at this venues
           If there is one pin then load the pin viewer straight away. If there are multiple pins
           load the venue viewer first */
        if ([tempVenue pinsCount] == 1) {
            PinViewController *pinController = [[PinViewController alloc] initWithNibName:@"PinViewController" bundle:nil andPin:[tempVenue.pins objectAtIndex:0]];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pinController];
            [self presentViewController:navController animated:YES completion:nil];

        } else {
            #warning Add a link to the venue viewer
        }
    }
}

- (void)filterAnnotations:(NSMutableDictionary *)pinLocations
{
    float latDelta = currentMapView.region.span.latitudeDelta/9.0;
    float longDelta = currentMapView.region.span.longitudeDelta/11.0;
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
                [currentMapView removeAnnotation:venueToCheck];
                found = TRUE;
                [tempAnnotation addChildVenue:venueToCheck];
                break;
            }
        }
        if (!found) {
            [pinsToShow addObject:venueToCheck];
            [currentMapView addAnnotation:venueToCheck];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (zoomLevel != mapView.region.span.longitudeDelta)
    {
        [self filterAnnotations:venues];
        zoomLevel = mapView.region.span.longitudeDelta;
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
            //NSLog(@"Calling video");
            break;
            
        }
        case 3:
        {
            TextUploadViewController *uvc = [[TextUploadViewController alloc] initWithParent:self];
            [self presentViewController:uvc animated:YES completion:nil];
            //NSLog(@"Calling video");
            break;
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
