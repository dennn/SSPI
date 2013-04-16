//
//  Pin.m
//  SSPI
//
//  Created by Den on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@synthesize dataLocation, pinID, uploadDate, venueLocation, uploadType, uploadUser;

- (id)initWithPinID:(int)pin
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    pinID = pin;
}

@end
