//
//  CreateNewLocationViewController.h
//  SSPI
//
//  Created by Den on 17/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Venue.h"

@protocol CreateLocationDelegate <NSObject>
@required
- (void)didCreateNewVenue:(Venue *)venue;
@end

@interface CreateNewLocationViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) id <CreateLocationDelegate> delegate;

@end
