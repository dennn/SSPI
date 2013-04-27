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
    self.textLabel.font = [UIFont fontWithName: @"ChalkboardSE-Bold" size: 14.0 ];
    self.detailTextLabel.font = [UIFont fontWithName: @"Arial" size: 18.0 ];
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.numberOfLines = 0;
    //self.selectionStyle = UITableViewCellSelectionStyleGray;
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
    
    if([_feed.type isEqualToString:@"photo"] || [_feed.type isEqualToString:@"image"])
    {
        //NSLog(@"%@",[[UIScreen mainScreen] applicationFrame] );
        
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, 300.0f, 20.0f);
        //self.imageView.frame = CGRectMake(250.0f, 10.0f, 60.0f, 80.0f);
        CGRect imageFrame = CGRectOffset(self.imageView.frame, 0.0f, 25.0f);
        CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
        detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_feed] - 15.0f;
        imageFrame.size.height=[[self class] heightForCellWithPost:_feed] - 55.0f;
        self.detailTextLabel.frame = detailTextLabelFrame;
        self.imageView.frame  = imageFrame;
    }
    else
    {
        //self.imageView.frame = CGRectMake(10.0f, 10.0f, 60.0f, 80.0f);
        self.textLabel.frame = CGRectMake(10.0f, 10.0f, 310.0f, 20.0f);
        
        CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
        detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_feed] - 45.0f;
        self.detailTextLabel.frame = detailTextLabelFrame;
    }
    
}


@end
