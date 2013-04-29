//
//  VenueViewController.m
//  SSPI
//
//  Created by Den on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "VenueViewController.h"
#import "VenueCell.h"
#import "Pin.h"
#import "UIImageView+AFNetworking.h"
#import "SORelativeDateTransformer.h"
#import "PinViewController.h"

@interface VenueViewController ()

@end

@implementation VenueViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Pins";
    self.view.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:33.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
    [self.collectionView registerClass:[VenueCell class] forCellWithReuseIdentifier:@"venueCell"];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    tapGesture.delegate = self;
    [self.collectionView addGestureRecognizer:tapGesture];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_pins count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"venueCell" forIndexPath:indexPath];
    Pin *tempPin = [_pins objectAtIndex:indexPath.row];
    switch (tempPin.uploadType) {
        case image:
            [cell.pinImage setImageWithURL:tempPin.dataLocation];
            break;
            
        case video:
            [cell.pinImage setImage:[UIImage imageNamed:@"Video.png"]];
            break;
            
        case audio:
            [cell.pinImage setImage:[UIImage imageNamed:@"Audio.png"]];
            break;
            
        case text:
            [cell.pinImage setImage:[UIImage imageNamed:@"Write.png"]];
            break;
    }

    
    SORelativeDateTransformer *dateTransformer = [SORelativeDateTransformer new];
    cell.pinText.text = [dateTransformer transformedValue:tempPin.uploadDate];
    
    return cell;
}

- (void)cellTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapPoint];
    if (indexPath != nil) {
        Pin *tempPin = [_pins objectAtIndex:indexPath.row];
        PinViewController *pinController = [[PinViewController alloc] initWithNibName:@"PinViewController" bundle:nil andPin:tempPin];
        [self.navigationController pushViewController:pinController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
