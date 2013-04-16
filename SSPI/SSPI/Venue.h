//
//  MapAnnotation.h
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Pin.h"

@interface Venue : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSMutableArray *pins;
@property (nonatomic, strong) NSMutableArray *venues;

- (id)initWitVenueID:(NSString *)venue;

- (void)addPin:(Pin *)pin;
- (void)addChildVenue:(Venue *)venue;
- (int)venuesCount;
- (int)pinsCount;

@end
