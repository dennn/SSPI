//
//  Pin.h
//  SSPI
//
//  Created by Den on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class Venue;

typedef enum {
    image,
    video,
    audio,
    text
} UploadType;

@interface Pin : NSObject

@property (nonatomic, strong) NSDate *uploadDate;
@property (nonatomic, strong) NSNumber *pinID;
@property (nonatomic, strong) User *uploadUser;
@property (nonatomic, strong) NSURL *dataLocation;
@property (nonatomic, strong) Venue *venueLocation;
@property (nonatomic, assign) UploadType uploadType;
@property (nonatomic, strong) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
