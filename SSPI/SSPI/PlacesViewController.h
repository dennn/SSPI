//
//  PlacesViewController.h
//  SSPI
//
//  Created by Den on 13/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlacesViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *pins;

@end
