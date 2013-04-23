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
    engine = [[MKNetworkEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];

    return self;
}

/*
-(void) getFeedsFromServer{
    NSLog(@"get feeds");
    MKNetworkOperation *op = [engine operationWithPath:@"/coomko/index.php/uploads/getLatest"
                                              params:nil
                                          httpMethod:@"GET"
                                                   ssl:NO];
<<<<<<< HEAD
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"request string: %@",[completedOperation responseString]);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
    }];

=======
        [op onCompletion:^(MKNetworkOperation *operation){
        //NSDictionary *dic = [NSDictionary alloc];
        //NSArray *pins = [NSArray alloc];
        NSDictionary *dic = [op responseJSON];
        NSArray *pins = [dic objectForKey:@"pins"];
            
        NSDictionary *pin = [NSDictionary alloc];
        NSString* location = [NSString alloc];
        pin = [pins objectAtIndex:3];
        location = [pin objectForKey:@"dataLocation"];
        photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",@"thenicestthing.co.uk/coomko/uploads/",location ]];
        NSURLRequest *request = [NSURLRequest requestWithURL:photoURL];
        NSLog(@"request string: %@",[photoURL absoluteString]);
        AFImageRequestOperation *iop2 = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
            if(image == nil)
            {
                NSLog(@"nil image");
            }else
                NSLog(@"get image");
            return image;
            } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                test = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"%@",[error localizedDescription]);
            }];
            [iop2 start];
        }
        onError:^(NSError *error){
            NSLog(@"%@", [error localizedDescription]);
        }];
>>>>>>> newfeedstable
    [engine enqueueOperation:op];
 
}*/

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
