//
//  FoursquareLocationPickerViewController.h
//  SSPI
//
//  Created by Den on 24/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class FSVenue;

@interface FoursquareLocationPickerViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *venuesArray;

@end
