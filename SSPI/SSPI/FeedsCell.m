//
//  FeedsCell.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "FeedsCell.h"

@implementation FeedsCell

@synthesize _feed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    return self;
}

- (void)setFeeds:(feedSourceManager*) feed
{
    self.detailTextLabel.text = [NSString stringWithFormat: @"userID:%i", (int)feed.feedid];
    self.textLabel.text = [NSString stringWithFormat:@"feedID:%i", (int)feed.feedid];
    if ([feed.type isEqualToString: @"image"]) {
        NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@%@",@"thenicestthing.co.uk/coomko/uploads/",feed.dataLocation]];
        [self.imageView setImageFromURL:imageURL placeHolderImage:nil];
        NSLog(@"set image");
    }
    
    NSLog(@"call:%@,%@", self.textLabel.text,self.detailTextLabel.text);
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithPost:(feedSourceManager *)feed {
    CGSize sizeToFit = [[NSString stringWithFormat:@"feedID:%i", (int)feed.feedid] sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    
    return fmaxf(70.0f, sizeToFit.height + 100.0f);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_feed] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}


@end