//
//  MapAnnotation.h
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Pin;

@interface Venue : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSMutableArray *pins;
@property (nonatomic, strong) NSMutableArray *venues;

- (id)initWithVenueID:(NSString *)venue;

- (void)addPin:(Pin *)pin;
- (void)addChildVenue:(Venue *)venue;
- (void)cleanChildren;
- (int)venuesCount;
- (int)pinsCount;

@end
