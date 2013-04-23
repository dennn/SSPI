//
//  VenueLayout.m
//  SSPI
//
//  Created by Den on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "VenueLayout.h"

@implementation VenueLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.sectionInset = UIEdgeInsetsMake(10.0f, 15.0f, 10.0f, 10.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.minimumInteritemSpacing = 10.0f;
    self.minimumLineSpacing = 20.0f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

@end
