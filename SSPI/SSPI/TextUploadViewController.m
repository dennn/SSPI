//
//  TextUploadViewController.m
//  SSPI
//
//  Created by Ryan Connolly on 05/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "TextUploadViewController.h"

@implementation TextUploadViewController
@synthesize comments;

- (id)initWithParent:(UIViewController*)controllerParent{
    self = [super initWithNibName:@"ModalTextInputView" bundle:nil];

    if (self) {
        parent = controllerParent;
        comments.layer.cornerRadius = 8;
        comments.clipsToBounds = YES;
        [comments.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor]];
        [comments.layer setBorderWidth:2.0];
        //comments.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        //infoTags.layer.cornerRadius = 8;
        //infoTags.clipsToBounds = YES;
        //[infoTags.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor]];
        //[infoTags.layer setBorderWidth:2.0];
    }
    return self;
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

-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

-(void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
    //tags = infoTags.text;
    //[self store:tags];
    NSString *text = [[NSString alloc]initWithFormat: @"%@", comments.text];
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    // Write to text file
    [data writeToFile:filePath atomically:YES];
}

-(void)cancel{
    
}

- (IBAction)dismiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender{
    if([comments.text isEqualToString:@""]){
        UIAlertView *error =
            [[UIAlertView alloc] initWithTitle: @"Warning"
                               message: @"No text has been entered, please enter some text to save"
                              delegate: nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        [error show];
        return;
    }
    [self setLatLon];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *filename = [NSString stringWithFormat:@"%@%@%@",lat, lon, [NSString stringWithFormat:@"%d",arc4random() % 1000]];
    filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@""];
    name = [NSString stringWithFormat:@"%@.txt",filename];
    NewUploadViewController *getInfo = [[NewUploadViewController alloc] initWithStyle:UITableViewStyleGrouped type:@"text" name:name];
    getInfo.delegate = self;
    [parent.navigationController pushViewController:getInfo animated:YES];
}

@end
