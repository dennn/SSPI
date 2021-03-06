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
        if (![venueName isEqualToString:@""])
            return [venueName capitalizedString];
        else
            return @"Venue";
    } else {
        return [NSString stringWithFormat:@"%i venues", [self venuesCount]];
    }
}

- (NSString *)subtitle
{
    return @"";
}

- (CLLocationCoordinate2D)coordinate
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
    for (Pin *tempPin in pins) {
        if (tempPin.pinID == pin.pinID) {
            return;
        }
    }
    
    [pins addObject:pin];
}

@end
