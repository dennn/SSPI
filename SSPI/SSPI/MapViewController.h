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
#import "AwesomeMenu.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, UISearchBarDelegate, AwesomeMenuDelegate>
{
    IBOutlet UISearchBar *search;
}

@property (nonatomic, strong) IBOutlet UIImageView *brandingImage;
@property (nonatomic, strong) IBOutlet UISearchBar *search;

@end
