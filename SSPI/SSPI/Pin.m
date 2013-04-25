//
//  Pin.m
//  SSPI
//
//  Created by Den on 16/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@synthesize dataLocation, pinID, uploadDate, venueLocation, uploadType, uploadUser, description;

- (id)initWithDictionary:(NSDictionary *)dictionary;
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    pinID = [dictionary valueForKey:@"id"];
    uploadDate = [NSDate dateWithTimeIntervalSince1970:[[dictionary valueForKey:@"date"] doubleValue]];
    NSString *dataType = [dictionary valueForKey:@"type"];
    if ([dataType isEqualToString:@"photo"]) {
        uploadType = image;
    } else if ([dataType isEqualToString:@"video"]) {
        uploadType = video;
    } else if ([dataType isEqualToString:@"audio"]) {
        uploadType = audio;
    } else if ([dataType isEqualToString:@"text"]) {
        uploadType = text;
    }
    
    dataLocation = [NSURL URLWithString:[dictionary valueForKey:@"dataLocation"]];
    description = [dictionary valueForKey:@"data"];
    
    
    return self;
}

@end
