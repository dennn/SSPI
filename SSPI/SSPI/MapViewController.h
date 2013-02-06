//
//  FirstViewController.h
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "LoginViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *brandingImage;
@property (nonatomic, strong) IBOutlet LoginViewController *loginview;

@end
