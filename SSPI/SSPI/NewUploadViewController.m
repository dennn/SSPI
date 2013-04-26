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
    
    self = [super initWithStyle:style];
    type = localtype;
    name = localname;
    NSLog(@"Localname: %@", localname);
    if (self) {
        
        description = @"";
        tags = @"";
        expires = @"";
        lat = @"";
        lon = @"";
        cancel = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Choose location";
    
    UIBarButtonItem *finishButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(finish)];
    self.navigationItem.rightBarButtonItem = finishButton;
    
    self.pastTags = [[NSMutableArray alloc] initWithObjects:@"www.google.com", nil];
    self.autocompleteTags = [[NSMutableArray alloc] init];
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 270, 320, 130) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    location = @"";
    isEditingTags = NO;
    
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
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
        if (cell == nil) {
            cell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DescriptionCellIdentifier];
        }
        //cell.selectedImage = pickedImage;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
                locationCell = cell;
                break;
            }
                
            case 2:
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
                tagsField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
                tagsField.delegate = self;
                tagsField.text = @"Add Tags";
                [tagsField setReturnKeyType:UIReturnKeyDone];
                [tagsField addTarget:self
                              action:@selector(textFieldFinished:)
                    forControlEvents:UIControlEventEditingDidEndOnExit];
                [cell.contentView addSubview:tagsField];
                
                break;
            }
                
            case 3:
            {
                if (expires)
                {
                    cell.detailTextLabel.text = expires;
                }
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
    expiryCell.textLabel.text = expires;
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
    expiryCell.textLabel.text = expires;
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
}


/* AUTO-COMPLETE */

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    autocompleteTableView.hidden = NO;
    NSLog(@"Querying string: %@", [tagsField.text stringByReplacingCharactersInRange:range withString:string]);
    //NSString *tag = [[[tagsField.text stringByReplacingCharactersInRange:range withString:string] componentsSeparatedByString:@" "] objectAtIndex:[[tagsField.text stringByReplacingCharactersInRange:range withString:string] componentsSeparatedByString:@" "].count];
    NSArray *tagArray = [[tagsField.text stringByReplacingCharactersInRange:range withString:string] componentsSeparatedByString:@" "];
    NSString *tag = [tagArray objectAtIndex:tagArray.count-1];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://thenicestthing.co.uk/coomko/index.php/uploads/autoComplete/%@", tag]]];
    //NSData *response = [NSURLConnection sendAsynchronousRequest:request returningResponse:nil error:nil ];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSData *responseData = data;
        NSError *jsonParsingError = nil;
        NSArray *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
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
    const int movementDistance = 190; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
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
    [self store:tagsField.text];
    tags = tagsField.text;
    cancel = NO;
    NSLog(@"Delegate: %@", _delegate);
    NSLog(@"description:%@ tags:%@ expires:%@ lat:%@ lon:%@", description, tags, [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]], lat, lon);
    [_delegate save:description tags:tags expires:expires];
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
    [plist addObject:nameDictionary];
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        if(cancel)
            [_delegate cancel];
    }
    [super viewWillDisappear:animated];
}

@end