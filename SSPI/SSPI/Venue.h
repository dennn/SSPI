//
//  MapAnnotation.h
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Venue : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *foursquareVenueID;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSDictionary *dataDictionary;


- (id)initWithDictionary:(NSDictionary *)dictionary;
- (CLLocationCoordinate2D)getCoordinate;

- (NSString *)title;
- (NSString *)subtitle;

- (void)addChild:(Venue *)place;
- (int)childrenCount;


@end
