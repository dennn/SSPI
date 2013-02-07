//
//  UploadEngine.m
//  SSPI
//
//  Created by Ryan Connolly on 30/01/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "UploadEngine.h"

@implementation UploadEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    return op;
}

-(MKNetworkOperation*) authTest:(NSMutableDictionary *)params
{
    MKNetworkOperation *op = [self operationWithPath:@"coomko/index.php/users/login"
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    
    return op;
}

@end
