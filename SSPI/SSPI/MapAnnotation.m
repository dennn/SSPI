//
//  MapAnnotation.m
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate, title, subtitle, children;

- (id)initWithLocation:(CLLocationCoordinate2D)coord
{
    self = [super init];
    if(self)
    {
        coordinate = coord;
        children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)getTitle
{
    return title;
}

- (NSString *)getSubtitle
{
    return subtitle;
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

- (void)addChild:(MapAnnotation *)place
{
    [children addObject:place];
}

@end
