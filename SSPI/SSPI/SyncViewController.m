//
//  SyncController.m
//  SSPI
//
//  Created by Ryan Connolly on 28/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "SyncViewController.h"

@implementation SyncViewController

-(id)initWithStyle:(UITableViewStyle)style{
    if(self = [super initWithStyle:style]){
        NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* plistPath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
            NSLog(@"Nothing yet synced");
            
        }
        NSArray* a = [NSArray arrayWithContentsOfFile:plistPath];
        stuff = [a mutableCopy];
        for (NSDictionary *d in a){
            NSLog(@"Type: %@, filename: %@, lat: %@, lon: %@, tags: %@", [d objectForKey:@"Type"],[d objectForKey:@"Name"],[d objectForKey:@"Latitude"],[d objectForKey:@"Longitude"],[d objectForKey:@"Tags"]);
        }
    }
    return self;

}

-(void)viewDidLoad{

    [super viewDidLoad];
    self.title = @"Sync queue";

    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStylePlain target:self action:@selector(sync)];
    self.navigationItem.rightBarButtonItem = syncButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(stuff == nil){
        return 0;
    }else{
        return stuff.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Setting up cells");
    static NSString *CellIdentifier = @"LibraryListingCell";
    
    CustomMediaCell *cell = (CustomMediaCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSLog(@"Cell is nil");
        [[NSBundle mainBundle] loadNibNamed:@"CustomMediaCell" owner:self options:nil];
        cell = _cell;
        _cell = nil;
    }
    if([[[stuff objectAtIndex:indexPath.row]  objectForKey:@"Expires"] isEqualToString:@"never"] || [[[stuff objectAtIndex:indexPath.row]  objectForKey:@"Expires"] isEqualToString:@"0"]){
        cell.dateLabel.text = @"Never expires";

    }else{
        NSLog(@"%@", [[stuff objectAtIndex:indexPath.row]  objectForKey:@"Expires"] );
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:
                        [[[stuff objectAtIndex:indexPath.row]  objectForKey:@"Expires"] doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        NSString *string = [dateFormatter stringFromDate:date];
        cell.dateLabel.text = [NSString stringWithFormat:@"Expires on %@",string];
    }
    NSString * type = [[stuff objectAtIndex:indexPath.row] objectForKey:@"Type"];
    type = [type stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[type substringToIndex:1] uppercaseString]];
    if(![[[stuff objectAtIndex:indexPath.row] objectForKey:@"Location"] isEqualToString:@""]){
    cell.typeLabel.text = [NSString stringWithFormat:@"%@ at %@",type,[[stuff objectAtIndex:indexPath.row] objectForKey:@"Location"]];
    }else{
            cell.typeLabel.text = [NSString stringWithFormat:@"%@ %@",type,[[stuff objectAtIndex:indexPath.row] objectForKey:@"Location"]];
    }
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [stuff removeObjectAtIndex:indexPath.row];
        //add code here for when you hit delete
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        NSString *DocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString* plistFilePath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
        
        NSMutableArray * plistContents = [NSMutableArray arrayWithContentsOfFile:plistFilePath];
        [plistContents removeObjectAtIndex:indexPath.row];
        [plistContents writeToFile:plistFilePath atomically:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[[stuff objectAtIndex:indexPath.row] objectForKey:@"Location"];
    
    NSLog(@"Clicked - index: %d", indexPath.row);
    NewUploadViewController *getInfo = [[NewUploadViewController alloc] initWithStyle:UITableViewStyleGrouped type:[[stuff objectAtIndex:indexPath.row] objectForKey:@"Type"] name:[[stuff objectAtIndex:indexPath.row] objectForKey:@"Name"] overwrite:YES array:[stuff objectAtIndex:indexPath.row] ident:indexPath.row];
    getInfo.delegate = self;
    [self.navigationController pushViewController:getInfo animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

-(void)cancel{
    
    
}
-(void)back{
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"Nothing yet synced");
        
    }
    NSArray* a = [NSArray arrayWithContentsOfFile:plistPath];
    stuff = [a mutableCopy];
    [(UITableView*)self.view reloadData];

}

-(void)save:(NSString *)description tags:(NSString *)tags expires:(NSString *)expires{
    
}

- (void)sync
{
    BOOL cancel = NO;
    for (NSDictionary *d in stuff){
        NSLog(@"Looping location: %@", [d  objectForKey:@"Location"]);
        if([[d  objectForKey:@"Location"] isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] init];
            [alert setTitle:@"You have not picked a location for a piece of data"];
            [alert setMessage:@"Continue?"];
            [alert setDelegate:self];
            [alert addButtonWithTitle:@"Yes"];
            [alert addButtonWithTitle:@"No"];
            [alert show];
            cancel = YES;
            break;
        }
    }
    if(!cancel){
        UploadEngine * ue = [[UploadEngine alloc] init];
        [ue syncPressed:self];
        //[self.navigationController popViewControllerAnimated: YES];
        stuff = nil;
        //add code here for when you hit delete
        [(UITableView*)self.view reloadData];
        [_delegate syncd];
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        UploadEngine * ue = [[UploadEngine alloc] init];
        [ue syncPressed:self];
        //[self.navigationController popViewControllerAnimated: YES];
        stuff = nil;
        //add code here for when you hit delete
        [(UITableView*)self.view reloadData];
        [_delegate syncd];
    }

}

@end
