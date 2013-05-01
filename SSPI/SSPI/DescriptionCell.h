//
//  DescriptionCell.h
//  SSPI
//
//  Created by Den on 25/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTextView.h"

@interface DescriptionCell : UITableViewCell <UITextViewDelegate>{
    SSTextView *descriptionText;
}

@property (nonatomic, strong) SSTextView *descriptionText;
@property (nonatomic, strong) UIImage *selectedImage;

@end
