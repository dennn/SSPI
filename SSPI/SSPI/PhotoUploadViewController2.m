//
//  PhotoUploadViewController.m
//  SSPI
//
//  Created by Den on 24/03/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "PhotoUploadViewController2.h"
#import "DescriptionCell.h"
#import "FoursquareLocationPickerViewController.h"
#import "TDDatePickerController.h"

@interface PhotoUploadViewController2 ()

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) TDDatePickerController *datePicker;
@property (nonatomic, strong) NSString *expiryDate;

@end

@implementation PhotoUploadViewController2

@synthesize pickedImage, datePicker, expiryDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"New photo";
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:NO completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    pickedImage = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
        
    [picker dismissViewControllerAnimated:TRUE completion:nil];
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
                if (expiryDate)
                {
                    cell.detailTextLabel.text = expiryDate;
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
    expiryDate = @"Never";
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)datePickerSetDate:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
    expiryDate = [NSDateFormatter localizedStringFromDate:viewController.datePicker.date
                                                                       dateStyle:kCFDateFormatterMediumStyle
                                                                       timeStyle:NSDateFormatterNoStyle];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)datePickerCancel:(TDDatePickerController *)viewController
{
    [self dismissSemiModalViewController:datePicker];
}

@end
