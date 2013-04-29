//
//  CustomMediaCell.h
//  SSPI
//
//  Created by Ryan Connolly on 28/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMediaCell : UITableViewCell{
    IBOutlet UILabel *typeLabel;
    IBOutlet UIImageView *coverImageView;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *locationLabel;
}

@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UIImageView *coverImageView;

@end
