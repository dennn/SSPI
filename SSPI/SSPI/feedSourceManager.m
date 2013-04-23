//
//  feedSourceManager.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "feedSourceManager.h"

@implementation feedSourceManager

-(id)init{
    engine = [[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    return self;
}


-(void) getFeedsFromServer{
    NSLog(@"get feeds");
    MKNetworkOperation *op = [engine operationWithPath:@"/coomko/index.php/uploads/getLatest"
                                              params:nil
                                          httpMethod:@"GET"
                                                   ssl:NO];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"request string: %@",[completedOperation responseString]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    }];

    [engine enqueueOperation:op];
}

@end