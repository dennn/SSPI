//
//  FirstViewController.m
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"

@interface MapViewController ()
{
    IBOutlet MKMapView *currentMapView;
    NSMutableArray *annotations;
    CLLocationDegrees zoomLevel;
}

- (void)filterAnnotations:(NSArray *)pinLocations;

@end

@implementation MapViewController

@synthesize brandingImage;

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
    
    [self loadDummyPlaces];
    [self filterAnnotations:annotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int selectedBranding = [defaults integerForKey:@"branding"];
    
    switch (selectedBranding)
    {
        case 0:
            brandingImage.image = [UIImage imageNamed:@"UOB"];
            break;
            
        case 1:
            brandingImage.image = [UIImage imageNamed:@"IBM"];
            break;
            
        default:
            break;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    } else {
        MKAnnotationView *annotationView = nil;
        static NSString *AnnotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
        
        if (pinView == nil)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
            pinView.animatesDrop = NO;
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.enabled = YES;
            pinView.canShowCallout = YES;
            pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        
        annotationView = pinView;

        return annotationView;
    }
}

- (void)loadDummyPlaces
{
    srand((unsigned)time(0));
    
    annotations = [[NSMutableArray alloc] init];
    for (int i=0; i<1000; i++) {
        MapAnnotation *debugAnn = [[MapAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake([self RandomFloatStart:50.0 end: 51.0], [self RandomFloatStart:20.0 end:21.0])];
        debugAnn.title = [NSString stringWithFormat:@"Pin %d", i];
        debugAnn.subtitle = @"Test";
        [debugAnn addChild:debugAnn];

        [annotations addObject:debugAnn];
    }
}

- (float)RandomFloatStart:(float)a end:(float)b {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

- (void)filterAnnotations:(NSArray *)pinLocations
{
    float latDelta = currentMapView.region.span.latitudeDelta/9.0;
    float longDelta = currentMapView.region.span.longitudeDelta/11.0;
    [pinLocations makeObjectsPerformSelector:@selector(cleanChildren)];
    NSMutableArray *pinsToShow = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [pinLocations count]; i++) {
        MapAnnotation *pinLocation = [pinLocations objectAtIndex:i];
        CLLocationDegrees latitude = [pinLocation getCoordinate].latitude;
        CLLocationDegrees longitude = [pinLocation getCoordinate].longitude;
        
        bool found = FALSE;
        for (MapAnnotation *tempAnnotation in pinsToShow) {
            if(fabs([tempAnnotation getCoordinate].latitude - latitude) < latDelta &&
               fabs([tempAnnotation getCoordinate].longitude - longitude) < longDelta)
            {
                [currentMapView removeAnnotation:pinLocation];
                found = TRUE;
                [tempAnnotation addChild:pinLocation];
                break;
            }
        }
        if (!found) {
            [pinsToShow addObject:pinLocation];
            [currentMapView addAnnotation:pinLocation];
        }
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (zoomLevel != mapView.region.span.longitudeDelta)
    {
        NSLog(@"ZOOM");
        [self filterAnnotations:annotations];
        zoomLevel = mapView.region.span.longitudeDelta;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
