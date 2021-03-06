//
//  TextUploadViewController.h
//  SSPI
//
//  Created by Ryan Connolly on 05/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NewUploadViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface TextUploadViewController : UIViewController <NewUploadViewControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIViewController *parent;
    NSString *name;
    NSString *lat;
    NSString *lon;
}

@property(nonatomic, retain) IBOutlet UITextView *comments;

-(id)initWithParent:(UIViewController*)controllerParent;


@end
