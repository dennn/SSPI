//
//  MediaCell.m
//  SSPI
//
//  Created by Den on 13/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "MediaCell.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UIImageView+AFNetworking.h"

@interface MediaCell ()

@property (nonatomic, strong) UIImageView *cellImage;

@end

@implementation MediaCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cellImage = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 5, 5)];
        _cellImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _cellImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _cellImage.layer.borderWidth = 4.0;
        _cellImage.layer.cornerRadius = 6.0;
        [self.contentView addSubview:_cellImage];
    }
    return self;
}

- (void)loadMedia:(NSURL *)media forPin:(Pin *)pin
{
    switch (pin.type) {
        case Image:
        {
            [_cellImage setImageWithURL:media];
            break;
        }
            
        case Audio:
        {
            break;
        }
            
        case Video:
        {
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:media];
            UIImage *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            [player stop];
            
            _cellImage.image = thumbnail;
            break;
        }
            
        case Text:
        {
            NSAssert(1, @"Shouldn't be using a media cell for type text");
            break;
        }
    }
}

@end
