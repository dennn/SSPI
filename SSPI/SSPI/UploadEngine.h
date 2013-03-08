//
//  UploadEngine.h
//  SSPI
//
//  Created by Ryan Connolly on 30/01/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface UploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

@end