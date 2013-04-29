//
//  TextUploadViewController.m
//  SSPI
//
//  Created by Ryan Connolly on 05/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "TextUploadViewController.h"

@interface TextUploadViewController ()
{
    CGFloat textHeight;
    UITableView *table;
    UITextView *textV;
    NSString *currentText;
}

-(IBAction)save:(id)sender;

@end

@implementation TextUploadViewController

- (id)initWithParent:(UIViewController*)controllerParent {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        parent = controllerParent;
        table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, 480) style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        self.title = @"Text upload";
    }
    return self;
}

- (void)viewDidLoad
{
    currentText = @"Input text";
    
    float height = [self heightForTextView:textV containingString:currentText];
    CGRect textViewRect = CGRectMake(2, 4, 296, height);
    textV = [UITextView new];
    textV.frame = textViewRect;
    textV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    textV.contentSize = CGSizeMake(296, [self heightForTextView:textV containingString:currentText]);
    textV.text = currentText;
    textV.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
    textV.backgroundColor = [UIColor clearColor];
    textV.delegate = self;
    textV.scrollEnabled = FALSE;
    
    //Add next button item
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    //Add tap keyboard dismiss
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TextCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    [cell.contentView addSubview:textV];
    
    return cell;
}

- (CGFloat)heightForTextView:(UITextView*)textView containingString:(NSString*)string
{
    float horizontalPadding = 2;
    float verticalPadding = 26;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    float height = [string sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0] constrainedToSize:CGSizeMake(widthOfTextView, 999999.0f) lineBreakMode:NSLineBreakByWordWrapping].height + verticalPadding;
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (textV.contentSize.height >= 44) {
        float height = [self heightForTextView:textV containingString:currentText];
        return height + 8; // a little extra padding is needed
    }
    else {
        return tableView.rowHeight;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    currentText = textView.text;
    [table beginUpdates];
    [table endUpdates];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text = @"";
}

-(void)dismissKeyboard {
    [textV resignFirstResponder];
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

- (void)cancel
{
    
}

-(void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
    NSString *text = [[NSString alloc]initWithFormat: @"%@", textV.text];
    NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
    //Write to text file
    [data writeToFile:filePath atomically:YES];
}

- (IBAction)save:(id)sender{
    if([textV.text isEqualToString:@""]){
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
