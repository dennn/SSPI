//
//  PhotoUploadViewController1.h
//  SSPI
//
//  Created by Ryan Connolly on 01/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "NewUploadViewController.h"

@interface PhotoUploadViewController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, NewUploadViewControllerDelegate> {
    NSString *type;
    NSString *name;
    NSString *lat;
    NSString *lon;
    UIViewController *parent;
    NSDictionary *info;
}

//@property(nonatomic, assign) id<UINavigationControllerDelegate> delegate;

- (id)initWithMedia:(NSString *)type parent:(UIViewController *)controller;
- (void)loadPhoto;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
