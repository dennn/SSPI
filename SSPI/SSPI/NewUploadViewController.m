//
//  NewUploadViewController.m
//  SSPI
//
//  Created by Den on 23/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "NewUploadViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "UploadViewController.h"
#import "DescriptionCell.h"
#import "FoursquareLocationPickerViewController.h"

@implementation NewUploadViewController

@synthesize pickedImage, datePicker, tableView, autocompleteTags, tagsField, pastTags, autocompleteTableView;


- (id)initWithStyle:(UITableViewStyle)style type:(NSString *)localtype name:(NSString *)localname{
    
    
    return [self initWithStyle:style type:localtype name:localname overwrite:NO array:nil ident:0];
}

- (id)initWithStyle:(UITableViewStyle)style type:(NSString *)localtype name:(NSString *)localname overwrite:(BOOL)localoverwrite array:(NSDictionary*)dict ident:(int)identity{
    
    type = localtype;
    name = localname;
    NSLog(@"Localname: %@", localname);
    if (self) {
        if(!localoverwrite){
            overwrite = NO;
            description = @"";
            tag = @"";
            expires = @"";
            cancel = YES;
        }else{
            overwrite = YES;
            ident = identity;
            description = [dict objectForKey:@"Description"];
            tag = [dict objectForKey:@"Tags"];
            expires = [dict objectForKey:@"Expires"];
            lat = [dict objectForKey:@"Latitude"];
            lon = [dict objectForKey:@"Longitude"];
            location = [dict objectForKey:@"Location"];
            date = [NSDate dateWithTimeIntervalSince1970:
                    [expires doubleValue]];
            NSLog(@"overwrite - tags: %@, desc: %@, location: %@, expires: %@", [dict objectForKey:@"Tags"], description, location, expires);
            cancel = YES;
        }
    }
    self = [super initWithStyle:style];

    server = @"http://thenicestthing.co.uk/";
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Choose location";
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem = finishButton;
    
    self.pastTags = [[NSMutableArray alloc] initWithObjects:@"www.google.com", nil];
    self.autocompleteTags = [[NSMutableArray alloc] init];
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 270, 320, 130) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    if(!overwrite){
        location = @"";
    }
    isEditingTags = NO;
    
    [self setLatLon];

    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(tableView == autocompleteTableView)
        return 1;
    else
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == autocompleteTableView){
        NSLog(@"Count: %d", autocompleteTags.count);
        return autocompleteTags.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == autocompleteTableView){
        UITableViewCell *cell = nil;
        static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        }
        
        cell.textLabel.text = [autocompleteTags objectAtIndex:indexPath.row];
        NSLog(@"indexPath.row: %d", indexPath.row);
        return cell;
    }
    if (indexPath.section == 0) {
        NSLog(@"Creating description cell");
        static NSString *DescriptionCellIdentifier = @"DescriptionCell";
        dcell = [tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
        if (dcell == nil) {
            dcell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DescriptionCellIdentifier];
        }
        //cell.selectedImage = pickedImage;
        dcell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(overwrite){
            dcell.descriptionText.text = description;
        }
        return dcell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        switch (indexPath.section)
        {
            case 1:
            {
                cell.textLabel.text = @"Location";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage imageNamed:@"Location.png"];
                if(overwrite && ![location isEqualToString:@""]){
                    NSLog(@"LOCATION:::: %@", location);
                    cell.textLabel.text = location;
                }
                locationCell = cell;
                break;
            }
                
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                tagsField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
                tagsField.delegate = self;
                tagsField.text = @"Add Tags";
                tagsField.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
                [tagsField setReturnKeyType:UIReturnKeyDone];
                [tagsField addTarget:self
                              action:@selector(textFieldFinished:)
                    forControlEvents:UIControlEventEditingDidEndOnExit];
                [cell.contentView addSubview:tagsField];
                if(overwrite){
                    tagsField.text = tag;
                }
                break;
            }
                
            case 3:
            {
                if (expires && !overwrite)
                {
                    cell.detailTextLabel.text = expires;
                }else if(overwrite){
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:
                                    [expires doubleValue]];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                    
                    NSString *string = [dateFormatter stringFromDate:date];
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",string];
                }
                if([expires isEqualToString:@"0"])
                    cell.detailTextLabel.text = @"";
                cell.textLabel.text = @"Expires";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.imageView.image = [UIImage imageNamed:@"Calendar.png"];
                expiryCell = cell;
                break;
            }
        }
        return cell;
    }
}

- (IBAction)textFieldFinished:(id)sender
{
    [sender resignFirstResponder];
    autocompleteTableView.hidden = YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == autocompleteTableView){
        return 44;
    }
    if (indexPath.section == 0) {
        return 110.0;
    } else {
        return 44.0;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == autocompleteTableView){
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        NSArray *strings = [tagsField.text componentsSeparatedByString:@" "];
        if(strings.count > 1){
            NSMutableArray *mutableCopy = [strings mutableCopy];
            [mutableCopy removeObjectAtIndex:mutableCopy.count-1];
            NSString *oldTags = [mutableCopy componentsJoinedByString:@" "];
            tagsField.text = [NSString stringWithFormat:@"%@ %@ ",oldTags, selectedCell.textLabel.text];
            NSLog(@"mut: %@", oldTags);
        }else{
            tagsField.text = [NSString stringWithFormat:@"%@ ",selectedCell.textLabel.text];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    switch (indexPath.section)
    {
        
        case 1:
        {
            FoursquareLocationPickerViewController *locationPicker = [[FoursquareLocationPickerViewController alloc] initWithNibName:nil bundle:nil];
            locationPicker.delegate = self;
            [self.navigationController pushViewController:locationPicker animated:YES];
            break;
        }
            
        case 3:
        {
            datePicker = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
            datePicker.delegate = self;
            if(date != nil){
                datePicker.datePicker.date = date;
                NSLog(@"Setting date");
            }
            [self presentSemiModalViewController:datePicker];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)datePickerSetDateNever:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
    expires = @"Never";
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
    expiryCell.detailTextLabel.text = expires;
}

- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
    date = viewController.datePicker.date;
    expires = [NSDateFormatter localizedStringFromDate:viewController.datePicker.date
                                             dateStyle:kCFDateFormatterMediumStyle
                                             timeStyle:NSDateFormatterNoStyle];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
    NSLog(@"Expires: %@", expires);
    expiryCell.detailTextLabel.text = expires;
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
}


/* AUTO-COMPLETE */

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    // Print query string
    NSLog(@"Querying string: %@", [tagsField.text stringByReplacingCharactersInRange:range withString:string]);
    NSArray *tagArray = [[tagsField.text stringByReplacingCharactersInRange:range withString:string] componentsSeparatedByString:@" "];
    NSString *tag = [tagArray objectAtIndex:tagArray.count-1];
    //Put current text in url
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@coomko/index.php/uploads/autoComplete/%@", server, tag]]];
    // Connect to server
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // Connection successful - get data
        NSData *responseData = data;
        NSError *jsonParsingError = nil;
        NSArray *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
        // Create new tags array to display
        pastTags = [[NSMutableArray alloc] init];
        NSDictionary *tagsDict;
        for(int i=0; i<[publicTimeline count];i++)
        {
            tagsDict = [publicTimeline objectAtIndex:i];
            NSLog(@"tag: %@", [tagsDict objectForKey:@"name"]);
            [pastTags addObject:[tagsDict objectForKey:@"name"]];
        }
        NSLog(@"%@", pastTags);
        [self searchAutocompleteEntriesWithSubstring:[tag lowercaseString]];
        NSLog(@"updating autocomplete table");
    }];
    
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteTags removeAllObjects];
    for(NSString *curString in pastTags) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteTags addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
}




/* ANIMATE TEXT VIEW */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"Text field begun editing");
    if([textField.text isEqualToString:@"Add Tags"])
        textField.text = @"";
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Text field finished editing");
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    isEditingTags = !isEditingTags;
    const int movementDistance = 190; 
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(void)finish{
    if(isEditingTags){
        [self.view endEditing:YES];
        autocompleteTableView.hidden = YES;
        return;
    }
    description = dcell.descriptionText.text;
    [self store:tagsField.text];
    tag = tagsField.text;
    cancel = NO;
    NSLog(@"Delegate: %@", _delegate);
    NSLog(@"description:%@ tags:%@ expires:%@ lat:%@ lon:%@", description, tag, [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]], lat, lon);
    if(!overwrite)
        [_delegate save:description tags:tag expires:expires];
    else
        [_delegate back];
    NSLog(@"Save data");
    [self.navigationController popViewControllerAnimated: YES];
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
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:lat forKey:@"Latitude"];
    [ud setValue:lon forKey:@"Longitude"];
    // Create the new dictionary that will be inserted into the plist.
    NSMutableDictionary *nameDictionary = [NSMutableDictionary dictionary];
    [nameDictionary setValue:type forKey:@"Type"];
    [nameDictionary setValue:name forKey:@"Name"];
    NSLog(@"Name stored: %@", [nameDictionary objectForKey:@"Name"]);
    [nameDictionary setValue:lat forKey:@"Latitude"];
    [nameDictionary setValue:lon forKey:@"Longitude"];
    [nameDictionary setValue:location forKey:@"Location"];
    [nameDictionary setValue:description forKey:@"Description"];
    [nameDictionary setValue:[NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]] forKey:@"Expires"];
    [nameDictionary setValue:tags forKey:@"Tags"];
    NSLog(@"%@",[NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]]);
    // Open the plist from the filesystem.
    NSMutableArray *plist = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (plist == nil) plist = [NSMutableArray array];
    if(!overwrite){
        [plist addObject:nameDictionary];
    }else{
        for (NSDictionary *d in plist){
            NSLog(@"Type: %@, filename: %@, lat: %@, lon: %@, tags: %@, expires: %@", [d objectForKey:@"Type"],[d objectForKey:@"Name"],[d objectForKey:@"Latitude"],[d objectForKey:@"Longitude"],[d objectForKey:@"Tags"],[d objectForKey:@"Expires"]);
            NSLog(@"%@", [d objectForKey:@"Type"]);
        }
        NSLog(@"lat for 1: %@, lat for 2: %@", lat, [[plist objectAtIndex:ident] objectForKey:@"Latitude"]);
        [plist replaceObjectAtIndex:ident withObject:nameDictionary];
        
        for (NSDictionary *d in plist){
            NSLog(@"Type: %@, filename: %@, lat: %@, lon: %@, tags: %@, expires: %@", [d objectForKey:@"Type"],[d objectForKey:@"Name"],[d objectForKey:@"Latitude"],[d objectForKey:@"Longitude"],[d objectForKey:@"Tags"],[d objectForKey:@"Expires"]);
            NSLog(@"%@", [d objectForKey:@"Type"]);
        }
    }
    [plist writeToFile:filePath atomically:YES];
}

-(void)didPickVenue:(Venue *)venue{
    location = venue.venueName;
    CLLocationCoordinate2D coordinate = venue.coordinate;
    
    lat = [NSString stringWithFormat:@"%f", coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    locationCell.textLabel.text = location;
    NSLog(@"lat: %@", lat);
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        if(cancel)
            [_delegate cancel];
    }
    [super viewWillDisappear:animated];
}

@end