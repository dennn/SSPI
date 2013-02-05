//
//  UploadViewController.m
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import "UploadViewController.h"

@implementation UploadViewController

@synthesize locationManager, comments, infoTags, recordingLabel, operation, uploadEngine;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle * )nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Upload", @"Upload");
        self.tabBarItem.image = [UIImage imageNamed:@"upload"];
    }
    return self;
}

- (IBAction)cameraButtonPressed:(id)sender{
    
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
    
        [self presentViewController:imagePicker animated:YES completion:nil];

}

- (IBAction)videoButtonPressed:(id)sender{
    
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
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)setLatLon{
    
    // Get location
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self setLatLon];
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
        NSString *file = [NSString stringWithFormat:@"%@%@%@",lat, lon, [NSString stringWithFormat:@"%d",arc4random() % 1000]];
        NSString *filenameWithoutDots = [file stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",docDir, filenameWithoutDots];
        NSLog(@"FILE PATH:%@", jpegFilePath);
        name = [NSString stringWithFormat:@"%@.jpeg", filenameWithoutDots];
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(imageToSave, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:jpegFilePath atomically:YES];
    }
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
    /////////////////////////////////////////////////////////////////
    // Save image to local bundle for uploading later (may be needed)
    /////////////////////////////////////////////////////////////////
    /*NSData *imageData = UIImagePNGRepresentation(image);
     NSString *imageName = [NSString stringWithFormat:@"image.png"];
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
     [imageData writeToFile:fullPathToFile atomically:YES];*/
    ////////
    
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    NSArray *tags = [self getTags];
}

- (IBAction)micButtonPressed:(id)sender{
    
    type = @"audio";
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ModalMicView" owner:self options:nil];
    modalView = [subviewArray objectAtIndex:0];
    modalView.frame = CGRectMake(0, 480, 320, 480);
    [self.view addSubview:modalView];
    [UIView animateWithDuration:0.5
     delay:0.0
     options: UIViewAnimationCurveEaseOut
     animations:^{
     modalView.frame = CGRectMake(0, 0, 320, 480);
     }
     completion:^(BOOL finished){
     }];
}

- (IBAction)record:(id)sender{
    if(!recording){
        [micButton setImage:[UIImage imageNamed:@"light_on.png"] forState:UIControlStateNormal];
        recordingLabel.textColor = [UIColor redColor];
        recording = YES;
    }else{
        NSArray *tags = [self getTags];
        [self dismiss:sender];
    }
}


- (IBAction)noteButtonPressed:(id)sender{
    
    type = @"text";
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"ModalTextInputView" owner:self options:nil];
    
    comments.layer.cornerRadius = 8;
    comments.clipsToBounds = YES;
    [comments.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor]];
    [comments.layer setBorderWidth:2.0];
    //comments.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    infoTags.layer.cornerRadius = 8;
    infoTags.clipsToBounds = YES;
    [infoTags.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor]];
    [infoTags.layer setBorderWidth:2.0];
    //infoTags.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //
    
    modalView = [subviewArray objectAtIndex:0];
    modalView.frame = CGRectMake(0, 480, modalView.frame.size.width, modalView.frame.size.height);
    [self.view addSubview:modalView];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         modalView.frame = CGRectMake(0, 0, modalView.frame.size.width, modalView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void) animateTextView: (BOOL) up
{
    const int movementDistance = 150;
    const float movementDuration = 0.3f; 
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    comments.frame = CGRectOffset(comments.frame, 0, movement);
    infoTags.frame = CGRectOffset(infoTags.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)dismiss:(id)sender{
    if([self isVisible]){
        [modalView endEditing:YES];
    }else{
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options: UIViewAnimationCurveEaseOut
                         animations:^{
                             modalView.frame = CGRectMake(0, 480, 320, 480);
                         }
                         completion:^(BOOL finished){
                             NSLog(@"Done!");
                             [modalView removeFromSuperview];
                         }];
        NSLog([self isVisible] ? @"Yes" : @"No");
    }
    
    NSLog(@"%@",comments.text);    
}

- (NSArray *)getTags{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tag" message:@"Please input space separated tags" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    return nil;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *tagString = [alertView textFieldAtIndex:0].text;
    NSLog(@"%@", tagString);
    [self store:tagString];
}
       
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";

    if([textView.restorationIdentifier isEqualToString:@"1"]){
        [self animateTextView:YES];
    }
    NSLog(@"Started editing target!");
    NSLog(@"%@",textView.restorationIdentifier);


}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if([textView.restorationIdentifier isEqualToString:@"1"]){
        [self animateTextView:NO];
    }
}
/* Sends image to server, should be extended (MKNetworkKit used) */
- (void)sendImage:(NSString *)filename lat:(NSString *)latitude lon:(NSString *)longitude tags:(NSString *)tags{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dataPath = [documentsPath stringByAppendingPathComponent:filename];
    UIImage *image = [UIImage imageWithContentsOfFile:dataPath];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    NSLog(@"Image path:  %@", dataPath);
    
    self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       latitude, @"lat",longitude, @"long",@"634", @"userID",tags,@"tags",
                                       nil];
    self.operation = [self.uploadEngine postDataToServer:postParams path:@"coomko/index.php/uploads/run"];
    [self.operation addData:imageData forKey:@"userfl" mimeType:@"image/jpeg" fileName:@"upload.jpg"];
    
    [self.operation addCompletionHandler:^(MKNetworkOperation* networkOperation) {
        NSLog(@"%@", [networkOperation responseString]);
    }
                              errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                  NSLog(@"%@", error);
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                  message:[error localizedDescription]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Dismiss"
                                                                        otherButtonTitles:nil];
                                  [alert show];
                              }];
    
    [self.uploadEngine enqueueOperation:self.operation ];
}

-(void)store:(NSString *)tags {
    NSString *DocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* filePath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSLog(@"sync.plist did not exist");
        NSString *path=[[NSBundle mainBundle] pathForResource:@"sync" ofType:@"plist"];
        NSLog(@"file path: %@",filePath);
        NSDictionary *info=[NSDictionary dictionaryWithContentsOfFile:path];
        [info writeToFile:filePath atomically:YES];
    }
    NSLog(@"Name: %@", name);
    // Create the new dictionary that will be inserted into the plist.
    NSMutableDictionary *nameDictionary = [NSMutableDictionary dictionary];
    [nameDictionary setValue:type forKey:@"Type"];
    [nameDictionary setValue:name forKey:@"Name"];
    NSLog(@"Name stored: %@", [nameDictionary objectForKey:@"Name"]);
    [nameDictionary setValue:lat forKey:@"Latitude"];
    [nameDictionary setValue:lon forKey:@"Longitude"];
    [nameDictionary setValue:tags forKey:@"Tags"];
    
    // Open the plist from the filesystem.
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (plist == nil) plist = [NSMutableArray array];
    [plist addObject:nameDictionary];
    [plist writeToFile:filePath atomically:YES];
}

- (IBAction)syncPressed:(id)sender {
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"Nothing yet synced");
        return;
    }
    
    NSArray* a = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *d in a){
        NSLog(@"Type: %@, filename: %@, lat: %@, lon: %@, tags: %@", [d objectForKey:@"Type"],[d objectForKey:@"Name"],[d objectForKey:@"Latitude"],[d objectForKey:@"Longitude"],[d objectForKey:@"Tags"]);
        
        [self sendImage:[d objectForKey:@"Name"] lat:[d objectForKey:@"Latitude"] lon:[d objectForKey:@"Longitude"] tags:[d objectForKey:@"Tags"]];
    }
    
    // Open the plist from the filesystem.
    NSMutableArray *plist = nil;
    if (plist == nil) plist = [NSMutableArray array];
    [plist writeToFile:plistPath atomically:YES];
}

- (BOOL)isVisible
{
    return _isVisible;
}

- (void)didShow
{
    _isVisible = YES;
}

- (void)didHide
{
    _isVisible = NO;
}

- (void)viewDidLoad {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(didShow) name:UIKeyboardDidShowNotification object:nil];
    [center addObserver:self selector:@selector(didHide) name:UIKeyboardWillHideNotification object:nil];
    comments.contentSize = CGSizeMake(comments.frame.size.height,comments.contentSize.height);
    infoTags.contentSize = CGSizeMake(infoTags.frame.size.height,infoTags.contentSize.height);

    recording = NO;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
