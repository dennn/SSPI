//
//  FeedsCell.h
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "feedSourceManager.h"

@interface FeedsCell : UITableViewCell

@property (nonatomic,strong) feedSourceManager* _feed;

-(void)set_feed:(feedSourceManager *)_feed;
+ (CGFloat)heightForCellWithPost:(feedSourceManager *)feed;

@end
