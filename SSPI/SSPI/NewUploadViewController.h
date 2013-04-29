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
#import "UploadEngine.h"
#import "FoursquareLocationPickerViewController.h"

@class NewUploadViewController;

@protocol NewUploadViewControllerDelegate

@required
- (void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires;
- (void)cancel;

@end

@class FSVenue;

@interface NewUploadViewController : UITableViewController <CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, UITextFieldDelegate, LocationPickedDelegate>{
    NSString *type;
    NSString *name;
    NSString *description;
    NSString *expires;
    NSString *tag;
    NSString *lat;
    NSString *lon;
    NSString *location;
    NSDate *date;
    BOOL cancel;
    IBOutlet UITextField *tagsField;
    NSMutableArray *pastTags;
    NSMutableArray *autocompleteTags;
    UITableView *autocompleteTableView;
    BOOL isEditingTags;
    UITableViewCell *locationCell;
    UITableViewCell *expiryCell;
    NSString *server;
    //id <NewUploadViewControllerDelegate> delegate;
}

@property (nonatomic, retain) UITextField *tagsField;
@property (nonatomic, retain) NSMutableArray *pastTags;
@property (nonatomic, retain) NSMutableArray *autocompleteTags;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic, assign) int uploadType;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) TDDatePickerController *datePicker;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) FSVenue *selectedVenue;
@property (nonatomic, strong) NSArray *venues;
@property (nonatomic, strong) id <NewUploadViewControllerDelegate> delegate;
@property (strong, nonatomic) MKNetworkOperation *operation;
@property (strong, nonatomic) UploadEngine *uploadEngine;


- (id)initWithStyle:(UITableViewStyle)style type:(NSString *)type name:(NSString *)name;
- (void)finish;

@end