//
//  MapAnnotation.h
//  SSPI
//
//  Created by Cheng Ma on 05/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSMutableArray *children;

- (id)initWithLocation:(CLLocationCoordinate2D)coordinate;
- (NSString *)title;
- (NSString *)subtitle;
- (CLLocationCoordinate2D)getCoordinate;

- (void)addChild:(MapAnnotation *)place;
- (int)childrenCount;


@end
