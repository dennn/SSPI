//
//  PinViewController.m
//  SSPI
//
//  Created by Den on 17/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "PinViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Resize.h"
#import "Venue.h"

@interface PinViewController ()

    @property (nonatomic, strong) Pin *currentPin;
    @property (nonatomic, strong) UITableView *pinTableView;
    @property (nonatomic, strong) UIImageView *webImage;
    @property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end

@implementation PinViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPin:(Pin *)pin
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentPin = pin;
        _pinTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 260, 320, 160)];
        _pinTableView.delegate = self;
        _pinTableView.dataSource = self;
        [self.view addSubview:_pinTableView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (_currentPin.uploadType) {
        case video:
        {
            UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
            _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_currentPin.dataLocation];
            [_moviePlayer setControlStyle:MPMovieControlStyleNone];
            [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
            [_moviePlayer prepareToPlay];
            [_moviePlayer setShouldAutoplay:YES];
            
            [[_moviePlayer view] setFrame:[playerView bounds]];
            [playerView addSubview:[_moviePlayer view]];
            [self.view addSubview:playerView];
            break;
        }
            
        case image:
        {
            _webImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
            _webImage.contentMode = UIViewContentModeScaleAspectFill;
            _webImage.backgroundColor = [UIColor blackColor];
            [self.view addSubview:_webImage];
            [_webImage setImageWithURL:_currentPin.dataLocation];
            break;
        }
            
        case audio:
        {
            UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
            _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:_currentPin.dataLocation];
            [_moviePlayer setControlStyle:MPMovieControlStyleNone];
            [_moviePlayer setRepeatMode:MPMovieRepeatModeOne];
            [_moviePlayer prepareToPlay];
            [_moviePlayer setShouldAutoplay:YES];
            
            [[_moviePlayer view] setFrame:[playerView bounds]];
            [playerView addSubview:[_moviePlayer view]];
            [self.view addSubview:playerView];
            break;
        }
            
        case text:
        {
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
            textView.text = _currentPin.description;
            textView.backgroundColor = [UIColor blackColor];
            textView.textColor = [UIColor whiteColor];
            textView.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:textView];
            break;
        }
            
        default:
            break;
    }
    
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/getPin/%i/", [_currentPin.pinID intValue]]];
    NSLog(@"Final URL: %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        _currentPin.uploadDate = [NSDate dateWithTimeIntervalSince1970:[[JSON valueForKey:@"date"] intValue]];
        _currentPin.pinID = [JSON valueForKey:@"id"];
        int user = [[JSON valueForKey:@"userid"] intValue];
        Venue *newVenue = [Venue new];
        newVenue.venueID = [JSON valueForKey:@"foursquareid"];
        _currentPin.venueLocation = newVenue;
        [self getUsername:user];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    
    [operation start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_moviePlayer stop];
}

- (void)getUsername:(int)userID
{
    //Create a new User object
    NSURL *userURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/getUsername/%i", userID]];
    NSLog(@"Final URL: %@", userURL);
    NSURLRequest *userRequest = [[NSURLRequest alloc] initWithURL:userURL];
    AFJSONRequestOperation *userOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:userRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        JSON = [JSON valueForKey:@"account"];
        User *newUser = [User new];
        newUser.name = [NSString stringWithFormat:@"%@",[JSON valueForKey:@"user"]];
        NSLog(@"%@", newUser.name);
        newUser.userID = userID;
        _currentPin.uploadUser = newUser;
        
        [_pinTableView reloadData];
        
        switch (_currentPin.uploadType) {
            case audio:
                self.title = [NSString stringWithFormat:@"%@'s audio", newUser.name];
                break;
                
            case video:
                self.title = [NSString stringWithFormat:@"%@'s video", newUser.name];
                break;
                
            case text:
                self.title = [NSString stringWithFormat:@"%@'s text", newUser.name];
                break;
                
            case image:
                self.title = [NSString stringWithFormat:@"%@'s photo", newUser.name];
                break;
                
            default:
                break;
        }
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
    }];
    [userOperation start];
}

- (void)handleMPMoviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    NSDictionary *notificationUserInfo = [notification userInfo];
    NSNumber *resultValue = [notificationUserInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    MPMovieFinishReason reason = [resultValue intValue];
    if (reason == MPMovieFinishReasonPlaybackError)
    {
        NSError *mediaPlayerError = [notificationUserInfo objectForKey:@"error"];
        if (mediaPlayerError)
        {
            NSLog(@"playback failed with error description: %@", [mediaPlayerError localizedDescription]);
        }
        else
        {
            NSLog(@"playback failed without any given reason");
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch(indexPath.row) {
        case 0:
            cell.textLabel.text = @"Uploaded by";
            cell.detailTextLabel.text = _currentPin.uploadUser.name;
            break;
            
        case 1:
            cell.textLabel.text = @"Uploaded on";
            cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:_currentPin.uploadDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
            break;
            
        case 2:
            cell.textLabel.text = @"Description";
            if ([_currentPin.description isEqualToString:@""]) {
                cell.detailTextLabel.text = @"No Description";
            } else {
                cell.detailTextLabel.text = _currentPin.description;
            }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 66;
    }
    
    return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
