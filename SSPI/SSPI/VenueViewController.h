//
//  VenueViewController.h
//  SSPI
//
//  Created by Den on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VenueViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *pins;

@end
