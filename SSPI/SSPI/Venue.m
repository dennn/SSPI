//
//  MapAnnotation.m
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize coordinate, title, subtitle, venues, venueName, venueID, pins;

- (id)initWithVenueID:(NSString *)venue
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    venueID = venue;
    
    pins = [NSMutableArray new];
    venues = [NSMutableArray new];
        
    return self;
}

- (NSString *)title
{
    if ([self venuesCount] == 1)
    {
        return venueName;
    } else {
        return [NSString stringWithFormat:@"%i places", [self venuesCount]];
    }
}

- (CLLocationCoordinate2D)getCoordinate
{
    return coordinate;
}

- (int)venuesCount
{
    return [venues count];
}

- (int)pinsCount
{
    return [pins count];
}

- (void)cleanChildren
{
    [venues removeAllObjects];
    [venues addObject:self];
}

- (void)addChildVenue:(Venue *)venue
{
    [venues addObject:venue];
}

- (void)addPin:(Pin *)pin
{
    [pins addObject:pin];
}

@end
