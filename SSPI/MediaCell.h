//
//  MediaCell.h
//  SSPI
//
//  Created by Den on 13/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"

@interface MediaCell : UICollectionViewCell

- (void)loadMedia:(NSURL *)media forPin:(Pin *)pin;

@end
