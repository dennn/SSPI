//
//  DescriptionCell.m
//  SSPI
//
//  Created by Den on 25/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "DescriptionCell.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>

@interface DescriptionCell ()

@property (nonatomic, strong) UILabel *characterCount;
@property (nonatomic, strong) UIImageView *uploadImage;

@end

@implementation DescriptionCell

@synthesize descriptionText, selectedImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        descriptionText = [[SSTextView alloc] initWithFrame:CGRectZero];
        descriptionText.delegate = self;
        descriptionText.backgroundColor = [UIColor clearColor];
        descriptionText.returnKeyType = UIReturnKeyDone;
        descriptionText.placeholder = @"Description...";
        [self.contentView addSubview:descriptionText];
        
        _characterCount = [[UILabel alloc] initWithFrame:CGRectZero];
        _characterCount.text = @"140 characters remaining";
        _characterCount.backgroundColor = [UIColor clearColor];
        _characterCount.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        _characterCount.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_characterCount];

        _uploadImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _uploadImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _uploadImage.layer.borderWidth = 3.0;
        [self.contentView addSubview:_uploadImage];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect textFieldRect = CGRectMake(10.0, 12.0, self.contentView.bounds.size.width - 95.0, 75.0);
    descriptionText.frame = textFieldRect;

    CGRect characterCountRect = CGRectMake(20.0, 90.0, 150, 20);
    _characterCount.frame = characterCountRect;
    
    CGRect uploadImageRect = CGRectMake(self.contentView.bounds.size.width - 85.0, -5.0, 80.0, 60.0);
    _uploadImage.image = [selectedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(80.0, 60.0) interpolationQuality:kCGInterpolationHigh];
    _uploadImage.frame = uploadImageRect;
    _uploadImage.transform = CGAffineTransformMakeRotation(M_PI * 2.0/180.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        NSUInteger newLength = (textView.text.length ) + (text.length - range.length);
        if(newLength <= 140)
        {
            [_characterCount setText:[NSString stringWithFormat:@"%d characters remaining", (140 - descriptionText.text.length)]];
            [_characterCount setTextColor:[UIColor darkGrayColor]];
        } else {
            [_characterCount setText:[NSString stringWithFormat:@"%d characters remaining", (140 - descriptionText.text.length)]];
            [_characterCount setTextColor:[UIColor redColor]];
        }
        return YES;
    }
    
    [textView resignFirstResponder];
    return NO;
}

@end
