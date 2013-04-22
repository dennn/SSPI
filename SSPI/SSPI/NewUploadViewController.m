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

@synthesize pickedImage, datePicker;


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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *DescriptionCellIdentifier = @"DescriptionCell";
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:DescriptionCellIdentifier];
        if (cell == nil) {
            cell = [[DescriptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DescriptionCellIdentifier];
        }
        cell.selectedImage = pickedImage;
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
                break;
            }
                
            case 2:
            {
                cell.textLabel.text = @"Tags";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
                break;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 110.0;
    } else {
        return 44.0;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            FoursquareLocationPickerViewController *locationPicker = [[FoursquareLocationPickerViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:locationPicker animated:YES];
            break;
        }
            
        case 3:
        {
            datePicker = [[TDDatePickerController alloc] initWithNibName:@"TDDatePickerController" bundle:nil];
            datePicker.delegate = self;
            [self presentSemiModalViewController:datePicker];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}


- (void)datePickerSetDateNever:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
    expires = @"Never";
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
    expires = [NSDateFormatter localizedStringFromDate:viewController.datePicker.date
                                                dateStyle:kCFDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
}


-(void)finish{
    [self store:tags];
    cancel = NO;
    NSLog(@"Delegate: %@", _delegate);
    NSLog(@"description:%@ tags:%@ expires:%@ lat:%@ lon:%@", description, tags, expires, lat, lon);
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

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        if(cancel)
            [_delegate cancel];
    }
    [super viewWillDisappear:animated];
}

@end
