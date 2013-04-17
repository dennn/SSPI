//
//  PlacesViewController.m
//  SSPI
//
//  Created by Den on 13/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "PlacesViewController.h"
#import "MediaCell.h"
#import "TextCell.h"
#import "Pin.h"

@interface PlacesViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation PlacesViewController

@synthesize pins = _pins;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 15, 10, 10);
    flowLayout.minimumInteritemSpacing = 10.0f;
    flowLayout.minimumLineSpacing = 20.0f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[self.view frame] collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [self.collectionView registerClass:[MediaCell class] forCellWithReuseIdentifier:@"mediaCell"];
    [self.collectionView registerClass:[TextCell class] forCellWithReuseIdentifier:@"textCell"];

    [self.view addSubview:self.collectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.pins count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Pin *currentPin = [self.pins objectAtIndex:indexPath.row];
    UICollectionViewCell *cell;
    switch (currentPin.type) {
        case Audio:
        case Video:            
        case Image:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mediaCell" forIndexPath:indexPath];
            break;
            
        case Text:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"textCell" forIndexPath:indexPath];
            break;
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
