//
//  Pin.h
//  SSPI
//
//  Created by Den on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Venue.h"
#import "User.h"

typedef enum {
    image,
    video,
    audio,
    text
} Uploadtype;

@interface Pin : NSObject

@property (nonatomic, strong) NSDate *uploadDate;
@property (nonatomic, assign) int pinID;
@property (nonatomic, strong) User *uploadUser;
@property (nonatomic, strong) NSURL *dataLocation;
@property (nonatomic, strong) Venue *venueLocation;
@property (nonatomic, assign) Uploadtype uploadType;

- (id)initWithPinID:(int)pin;

@end
