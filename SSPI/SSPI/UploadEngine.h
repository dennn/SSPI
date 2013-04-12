//
//  UploadEngine.h
//  SSPI
//
//  Created by Ryan Connolly on 30/01/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface UploadEngine : MKNetworkEngine{
    UIActivityIndicatorView* activityIndicator;
}

@property (strong, nonatomic) MKNetworkOperation *operation;

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;
-(void)syncPressed:(UIViewController*)controller;

@end