//
//  UploadViewController.h
//  SSPI
//
//  Created by Den on 01/12/2012.
//  Copyright (c) 2012 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    
}

- (IBAction)cameraButtonPressed:(id)sender;
- (IBAction)videoButtonPressed:(id)sender;
- (IBAction)micButtonPressed:(id)sender;
- (IBAction)noteButtonPressed:(id)sender;

@end
