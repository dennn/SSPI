//
//  PhotoUploadViewController1.m
//  SSPI
//
//  Created by Ryan Connolly on 01/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "PhotoUploadViewController.h"
#import "NewUploadViewController.h"

@implementation PhotoUploadViewController

- (id)initWithMedia:(NSString *)localtype parent:(UIViewController *)controller {
    parent = controller;
    type = localtype;
    /*if([type isEqualToString:@"photo"]){
        [self loadPhoto];
    }else{
        [self loadVideo];
    }*/
    self = [super init];
    if (self) {
        //UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self setSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        if([type isEqualToString:@"photo"]){
            self.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
        }else{
            self.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
        }
        
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad {
    if([type isEqualToString:@"photo"]){
        [self loadPhoto];
    }else{
        [self loadVideo];
    }
}

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

- (void)loadPhoto{
    
    type = @"image";
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil];
    
    [imagePicker setDelegate:self];
    
    [parent presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)loadVideo{
    
    type = @"video";
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString *)kUTTypeMovie, nil];
    
    [imagePicker setDelegate:self];
    if(imagePicker.delegate == nil)
        NSLog(@"Delegate still nil");
    else
        NSLog(@"Delegate not nil");
    
    [parent presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)mediaInfo{
    info = mediaInfo;
    [self setLatLon];
    NSString *file = [NSString stringWithFormat:@"%@%@%@",lat, lon, [NSString stringWithFormat:@"%d",arc4random() % 1000]];
    NSString *filenameWithoutDots = [file stringByReplacingOccurrencesOfString:@"." withString:@""];
    name = [NSString stringWithFormat:@"%@.jpeg", filenameWithoutDots];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    NewUploadViewController *getInfo = [[NewUploadViewController alloc] initWithStyle:UITableViewStyleGrouped type:@"photo" name:name];
    getInfo.delegate = self;
    UIImage *editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
    UIImage *originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        getInfo.pickedImage = editedImage;
    } else {
        getInfo.pickedImage = originalImage;
    }
    [parent.navigationController pushViewController:getInfo animated:YES];
}


- (void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires{
    NSLog(@"Saving image");
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey: UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        /*// Save the new image (original or edited) to the Camera Roll
         UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);*/
        
        // Save image to the documents folder, wait until tags are added
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSLog(@"%@",docDir);
        
        NSLog(@"saving jpeg");
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
        NSLog(@"FILE PATH:%@", jpegFilePath);
        NSLog(@"Name :: %@", name);
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(imageToSave, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:jpegFilePath atomically:YES];
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        /*NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
         
         if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
         UISaveVideoAtPathToSavedPhotosAlbum (
         moviePath, nil, nil, nil);
         }*/
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *file = [NSString stringWithFormat:@"%@%@%@",lat, lon, [NSString stringWithFormat:@"%d",arc4random() % 1000]];
        NSString *filenameWithoutDots = [file stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *mp4FilePath = [NSString stringWithFormat:@"%@/%@.mp4",docDir, filenameWithoutDots];
        name = [NSString stringWithFormat:@"%@.mp4", filenameWithoutDots];
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        [videoData writeToFile:mp4FilePath atomically:YES];
        NSLog(@"Video file path: %@", mp4FilePath);
        
    }
    NSLog(@"Delegate function called");
}

-(void)cancel{
    // Do nothing
}

@end
