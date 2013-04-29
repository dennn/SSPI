//
//  VenueCell.m
//  SSPI
//
//  Created by Den on 23/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "VenueCell.h"
#import <QuartzCore/QuartzCore.h>

@interface VenueCell ()

@end

@implementation VenueCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 7.0;
        //Draw pin image
        _pinImage = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, (CGRectGetWidth(frame)-20), (CGRectGetHeight(frame)-20)), 5, 5)];
        _pinImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _pinImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _pinImage.layer.borderWidth = 4.0;
        
        _pinText = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 105, 14)];
        _pinText.backgroundColor = [UIColor clearColor];
        _pinText.textAlignment = NSTextAlignmentCenter;
        _pinText.textColor = [UIColor whiteColor];
        _pinText.font = [UIFont fontWithName:@"Helvetica-Bold" size:12.0];
        
        [self.contentView addSubview:_pinImage];
        [self.contentView addSubview:_pinText];
    }
    return self;

}

@end
