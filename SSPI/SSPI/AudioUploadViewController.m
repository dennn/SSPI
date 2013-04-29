//
//  AudioUpload.m
//  SSPI
//
//  Created by Ryan Connolly on 02/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "AudioUploadViewController.h"

@implementation AudioUploadViewController

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@synthesize recordingLabel;


- (void)setLatLon{
    
    // Get location
    CLLocationManager *locationManager;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    CLLocation *location = [locationManager location];
    
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"dLatitude : %@", latitude);
    NSLog(@"dLongitude : %@",longitude);
    lat = latitude;
    lon = longitude;
}

- (id)initWithParent:(UIViewController*)controllerParent{
    self = [super initWithNibName:@"ModalMicView" bundle:nil];
    if (self) {
        recording = NO;
        secondsElapsed = 0;
        parent = controllerParent;
    }
    return self;
}

/*- (void)loadAudio{
    
    //type = @"audio";
    //NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ModalMicView" owner:self options:nil];
    //modalView = [subviewArray objectAtIndex:0];
    //modalView.frame = CGRectMake(0, 480, 320, 480);
    //[self.view addSubview:modalView];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         modalView.frame = CGRectMake(0, 0, 320, 480);
                     }
                     completion:^(BOOL finished){
                     }];
}*/

- (IBAction)record:(id)sender{
    [self setLatLon];
    if(!recording){
        secondsElapsed = 0;
        [micButton setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
        recordingLabel.textColor = [UIColor redColor];
        recordingLabel.text = @"0:00";
        recording = YES;
        timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                 target: self
                                               selector:@selector(tick:)
                                               userInfo: nil
                                                repeats: YES];
        [self startRecording];
    }else{
        [timer invalidate];
        recording = NO;
        [micButton setImage:[UIImage imageNamed:@"light_off.png"] forState:UIControlStateNormal];
        recordingLabel.textColor = [UIColor whiteColor];
        [self stopRecording];
        //[self dismiss:sender];
    }
}

- (void)tick:(NSTimer *)theTimer{
    secondsElapsed++;
    int seconds = secondsElapsed % 60;
    int minutes = secondsElapsed / 60;
    recordingLabel.text = [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
}

- (void) startRecording{
    NSLog(@"Recording");
    if(recorderFilePath != nil){
        NSLog(@"Re recording, deleting existing file");
        [recorder deleteRecording];
    }
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop" style:UIBarButtonItemStyleBordered  target:self action:@selector(stopRecording)];
    self.navigationItem.rightBarButtonItem = stopButton;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    [recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    NSString *filename = [NSString stringWithFormat:@"%@%@%@",lat, lon, [NSString stringWithFormat:@"%d",arc4random() % 1000]];
    filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@""];
    recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, filename];
    name = [NSString stringWithFormat:@"%@.caf",filename];
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    err = nil;
    recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: [err localizedDescription]
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [alert show];
        //[alert release];
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Audio input hardware not available"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
    }
    
    // start recording
    [recorder record];
    
}

- (void) stopRecording{
    
    [recorder stop];
    
    NSLog(@"Recorded audio successfully");
}

-(IBAction) playAudio:(id)sender {
    NSLog(@"Playing audio");
    if(recorderFilePath == nil){
        UIAlertView *cantPlayAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"Nothing has been recorded"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantPlayAlert show];
        return;
    }
    if (!recorder.recording){
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
        NSLog(@"Playing audio2");
        NSError *error;
        NSLog(@"Audio path: %@", recorderFilePath);
        player = [[AVAudioPlayer alloc]
                  initWithContentsOfURL:[NSURL fileURLWithPath:recorderFilePath]
                  error:&error];
        player.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else{
            [player play];
            secondsElapsed = 0;
            recordingLabel.text = @"0:00";
            recording = YES;
            timer = [NSTimer scheduledTimerWithTimeInterval: 1
                                                     target: self
                                                   selector:@selector(tick:)
                                                   userInfo: nil
                                                    repeats: YES];
        }
    }else{
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"Warning"
                                   message: @"You cannot play whilst recording"
                                  delegate: nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
        [cantRecordAlert show];
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag {
    if(flag)
        NSLog (@"audioRecorderDidFinishRecording:successfully:");
    else
        NSLog(@"Unsuccessful");
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [timer invalidate];
    NSLog(@"Finished playing");
    
}

- (IBAction)dismiss:(id)sender{
    if(recorderFilePath == nil){
        UIAlertView *error =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                                       message: @"Nothing has been recorded"
                                      delegate: nil
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
        [error show];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    NewUploadViewController *getInfo = [[NewUploadViewController alloc] initWithStyle:UITableViewStyleGrouped type:@"audio" name:name];
    getInfo.delegate = self;
    [parent.navigationController pushViewController:getInfo animated:YES];
}

-(void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires{
    NSLog(@"View saved");

}

- (IBAction)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancel{
    NSLog(@"View cancelled - deleting recording");
    if(recorderFilePath != nil){
        NSLog(@"Re recording, deleting existing file");
        [recorder deleteRecording];
    }
}


@end
