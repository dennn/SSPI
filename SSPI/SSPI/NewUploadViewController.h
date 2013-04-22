//
//  NewUploadViewController.h
//  SSPI
//
//  Created by Den on 23/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "TDDatePickerController.h"

@class NewUploadViewController;
@protocol NewUploadViewControllerDelegate
- (void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires;
- (void)cancel;
@end

@class FSVenue;

@interface NewUploadViewController : UITableViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>{
    NSString *type;
    NSString *name;
    NSString *description;
    NSString *expires;
    NSString *tags;
    NSString *lat;
    NSString *lon;
    BOOL cancel;
    //id <NewUploadViewControllerDelegate> delegate;
}


@property (nonatomic, assign) int uploadType;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) TDDatePickerController *datePicker;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FSVenue *selectedVenue;
@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) id <NewUploadViewControllerDelegate> delegate;


- (id)initWithStyle:(UITableViewStyle)style type:(NSString *)type name:(NSString *)name;
- (void)finish;

@end
