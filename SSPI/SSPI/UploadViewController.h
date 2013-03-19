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
#import "MKNetworkKit.h"
#import "UploadEngine.h"




@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIAlertViewDelegate>
{
    CLLocationManager *locationManager;
    AVAudioRecorder *recorder;
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
    BOOL recording;
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

- (IBAction)syncPressed:(id)sender;
- (void)sendImage:(UIImage *)image;


@end
