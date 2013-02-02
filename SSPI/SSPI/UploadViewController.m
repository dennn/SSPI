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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
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
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@%@.jpeg",docDir, latitude, longitude];
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
    [self sendImage:imageToSave lat:latitude lon:longitude tags:tags];

}

- (IBAction)micButtonPressed:(id)sender{
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
    [self alertView:alert clickedButtonAtIndex:0];
    
    NSString *tagString = [alert textFieldAtIndex:0].text;
    NSLog(@"tag string: %@", tagString);
    return [tagString componentsSeparatedByString:@" "];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *tagString = [alertView textFieldAtIndex:0].text;
    NSLog(@"%@", tagString);
    
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
- (void)sendImage:(UIImage *)image lat:(NSString *)lat lon:(NSString *)lon tags:(NSArray *)tags{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    
    self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"192.168.0.171" customHeaderFields:nil];
    NSString * result = [tags componentsJoinedByString:@"|"];
    NSLog(@"HERERERE %@",result);
    for(int i = 0; i < tags.count; i++){
        
    }
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       lat, @"lat",lon, @"long",@"634", @"userID",result,@"tags",
                                       nil];
    self.operation = [self.uploadEngine postDataToServer:postParams path:@"coomko/PSERVER/index.php/uploads/run"];
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

-(void)store{
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* filePath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"sync" ofType:@"plist"];
        NSLog(@"file path: %@",filePath);
        NSDictionary *info=[NSDictionary dictionaryWithContentsOfFile:path];
        [info writeToFile:filePath atomically:YES];
    }
}

- (IBAction)syncPressed:(id)sender {
    NSLog(@"Sync pressed");
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSLog(@"Nothing yet synced");
        return;
    }

    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    // assign values
    NSString *type = [temp objectForKey:@"Type"];
    NSString *file = [temp objectForKey:@"Name"];
    NSString *tags = [temp objectForKey:@"Tags"];
    //NSString *file = [temp objectForKey:@"Name"];
    /* GET OTHER VALUES
     NSMutableArray *tags = [NSMutableArray arrayWithArray:[temp objectForKey:@"Phones"]];
    // display values
    nameEntered.text = personName;
    homePhone.text = [phoneNumbers objectAtIndex:0];
    workPhone.text = [phoneNumbers objectAtIndex:1];
    cellPhone.text = [phoneNumbers objectAtIndex:2];
     */
}


- (void)viewDidLoad
{
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
