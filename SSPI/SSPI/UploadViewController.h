//
//  UploadViewController.h
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "MKNetworkKit.h"
#import "UploadEngine.h"




@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIAlertViewDelegate, AVAudioRecorderDelegate>
{
    CLLocationManager *locationManager;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    UIView *modalView;
    BOOL _isVisible;
    IBOutlet UITextView *comments;
    IBOutlet UITextView *infoTags;
    IBOutlet UIButton *micButton;
    IBOutlet UILabel *timer;
    NSString *type;
    NSString *name;
    NSString *lon;
    NSString *lat;
    NSString *tags;
    BOOL recording;
    NSMutableDictionary *recordSetting;
    NSString *recorderFilePath;
    UIViewController *parentController;
}

@property (nonatomic, assign) int uploadType;
@property (nonatomic, strong) NSString *foursquareVenueID;
@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UITextView *comments;
@property (nonatomic, retain) IBOutlet UITextView *infoTags;
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;
@property (strong, nonatomic) UploadEngine *uploadEngine;
@property (strong, nonatomic) MKNetworkOperation *operation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle * )nibBundleOrNil parent:(UIViewController *)parent;
- (void)loadCamera;
- (void)loadVideo;
- (void)loadAudio;
- (void)loadText;
- (IBAction)syncPressed:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)dismissAudio:(id)sender;


@end

