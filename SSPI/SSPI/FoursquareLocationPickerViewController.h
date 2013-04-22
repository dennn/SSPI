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
#import "CreateNewLocationViewController.h"

@class FSVenue;

@protocol LocationPickedDelegate <NSObject>
@required

- (void)didPickVenue:(Venue *)venue;

@end

@interface FoursquareLocationPickerViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, CreateLocationDelegate>

@property (nonatomic, weak) id <LocationPickedDelegate> delegate;

@end
