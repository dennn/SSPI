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




@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate>
{
    CLLocationManager *locationManager;
    AVAudioRecorder *recorder;
    UIView *modalView;
    BOOL _isVisible;
    IBOutlet UITextView *comments;
    IBOutlet UITextView *infoTags;
    IBOutlet UIButton *micButton;
    IBOutlet UILabel *timer;
    BOOL recording;
}

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet UITextView *comments;
@property (nonatomic, retain) IBOutlet UITextView *infoTags;
@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;

- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;
- (IBAction)micButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;

@end
