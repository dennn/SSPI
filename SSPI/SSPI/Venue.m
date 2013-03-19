//
//  MapAnnotation.m
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "Venue.h"

@implementation Venue

@synthesize coordinate, title, subtitle, children, dataDictionary;

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    coordinate = CLLocationCoordinate2DMake([[dictionary valueForKey:@"lat"] doubleValue], [[dictionary valueForKey:@"long"] doubleValue]);
    title = [NSString stringWithFormat:@"Pin %i", [[dictionary valueForKey:@"id"] intValue]];
    dataDictionary = dictionary;
    children = [NSMutableArray new];
    
    NSLog(@"Adding a pin at long: %f, lat: %f", coordinate.longitude, coordinate.latitude);
    
    return self;
}

- (NSString *)title
{
    if ([self childrenCount] == 1)
    {
        return title;
    } else {
        return [NSString stringWithFormat:@"%i places", [self childrenCount]];
    }
}

- (NSString *)subtitle
{
    if ([self childrenCount] == 1)
    {
        return subtitle;
    } else {
        return @"";
    }
}
- (CLLocationCoordinate2D)getCoordinate
{
    return coordinate;
}

- (int)childrenCount
{
    return [children count];
}

- (void)cleanChildren
{
    [children removeAllObjects];
    [children addObject:self];
}

- (void)addChild:(Venue *)place
{
    [children addObject:place];
}

@end
