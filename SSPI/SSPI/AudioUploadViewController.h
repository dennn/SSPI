//
//  AudioUpload.h
//  SSPI
//
//  Created by Ryan Connolly on 02/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "NewUploadViewController.h"

@interface AudioUploadViewController : UIViewController <UIAlertViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, CLLocationManagerDelegate, NewUploadViewControllerDelegate> {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    NSString *type;
    NSString *name;
    NSString *lat;
    NSString *lon;
    UIViewController *parent;
    IBOutlet UIButton *micButton;
    NSTimer *timer;
    BOOL recording;
    NSMutableDictionary *recordSetting;
    NSString *recorderFilePath;
    int secondsElapsed;
}

@property (nonatomic, retain) IBOutlet UILabel *recordingLabel;

- (id)initWithParent:(UIViewController*)controllerParent;
- (IBAction)playAudio:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)record:(id)sender;
- (IBAction)cancel:(id)sender;
@end
