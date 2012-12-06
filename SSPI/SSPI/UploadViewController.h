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



@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    AVAudioRecorder *recorder;
}

@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;
- (IBAction)micButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;

@end
