//
//  FeedsCell.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "FeedsCell.h"

@implementation FeedsCell


@synthesize _feed,name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14.0 ];
        self.detailTextLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 16.0 ];
        self.detailTextLabel.textColor = [UIColor blackColor];
        self.detailTextLabel.numberOfLines = 0;
    }
      return self;
}

-(void) prepareForReuse
{
    [self.imageView setImage:nil];
    self.textLabel.text = @"";
    /*[self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];*/
}

- (void)setFeeds:(feedSourceManager*) feed
{
    self.detailTextLabel.text = [NSString stringWithFormat: @"userID:%i", (int)feed.feedid];
    self.textLabel.text = [NSString stringWithFormat:@"feedID:%i", (int)feed.feedid];
    if ([feed.type isEqualToString: @"image"]) {
        NSURL *imageURL = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"http://%@%@",@"thenicestthing.co.uk/coomko/uploads/",feed.dataLocation]];
        [self.imageView setImageFromURL:imageURL placeHolderImage:nil];
    }

    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForCellWithPost:(feedSourceManager *)feed {
    if([feed.type isEqual: @"text"])
        return 100.0f;
    else if ([feed.type isEqualToString:@"audio"])
        return 100.0f;
    else
        return 250.0f;
    
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect f = [[UIScreen mainScreen] applicationFrame];
    
    if([_feed.type isEqualToString:@"photo"] || [_feed.type isEqualToString:@"image"])
    {
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, 300.0f, 20.0f);
        self.imageView.frame = CGRectMake(80.0f, 47.0f, 120.0f, 160.0f);
        CGRect detailTextLabelFrame = CGRectMake(10.0f,208.0f, 300.0f, 25.0f);
        self.detailTextLabel.frame = detailTextLabelFrame;
    }
    else if([_feed.type isEqualToString:@"video"])
    {
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, 300.0f, 20.0f);
        self.imageView.frame = CGRectMake(80.0f, 47.0f, 120.0f, 160.0f);
        CGRect detailTextLabelFrame = CGRectMake(10.0f,208.0f, 300.0f, 25.0f);
        self.detailTextLabel.frame = detailTextLabelFrame;
    }
    else if([_feed.type isEqualToString:@"audio"])
    {
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, f.size.width-10.0*2, 20.0f);
        self.imageView.frame = CGRectMake(30.0f, 40.0f, f.size.width-10.0*2, 20.0f);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        [button addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Show View" forState:UIControlStateNormal];
        [self.imageView addSubview:button];
        
    }
    else
    {
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, f.size.width-10.0*2, 20.0f);
        
        //CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
        //detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_feed] - 45.0f;
        self.detailTextLabel.frame = CGRectMake(30.0f, 40.0f, f.size.width-10.0*2, 20.0f);
    }
    
}


@end
