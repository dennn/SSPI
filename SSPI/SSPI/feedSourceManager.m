//
//  feedSourceManager.m
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "feedSourceManager.h"
#import "AFImageRequestOperation.h"

@implementation feedSourceManager
{
    NSURL* photoURL;
}

@synthesize userid,feedid,dataLocation,type;

-(id)initWithAttributes:(NSDictionary *)attributes{
    
    dataLocation = [NSString alloc];
    dataLocation = [attributes objectForKey:@"dataLocation"];
    type = [attributes objectForKey:@"type"];
    userid = [[attributes valueForKeyPath:@"userid"] integerValue];
    feedid = [[attributes valueForKeyPath:@"id"] integerValue];
    //engine = [[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];

    return self;
}


+ (void)globalTimelinePostsWithBlock:(void (^)(MKNetworkOperation *completedOperation, NSArray *posts, NSError *error))block
{
    MKNetworkOperation *op = [[[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil]
                                        operationWithPath:@"/coomko/index.php/uploads/getLatest"
                                                 params:nil
                                             httpMethod:@"GET"
                                                    ssl:NO];
            __block MKNetworkOperation*b_op = op;
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSLog(@"completed");
            NSDictionary *dic = [b_op responseJSON];
            NSMutableArray *pins = [dic objectForKey:@"pins"];
            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[pins count]];
            for (NSDictionary *attributes in pins) {
                feedSourceManager *feed = [[feedSourceManager alloc] initWithAttributes:attributes];
                //[feed printAttributes];
                [mutablePosts addObject:feed];
            }
                
            if (block) {
                block(completedOperation,[NSArray arrayWithArray:mutablePosts], nil);
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",[error localizedDescription]);
            if (block) {
                block(completedOperation,[NSArray array], error);
            }
        }];
        [[[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil] enqueueOperation:op];
    
}


- (void)printAttributes
{
    NSLog(@"feed:%i,user:%i,datalocation:%@, datatype:%@", (int)feedid,(int)userid,dataLocation,type);
}
@end
