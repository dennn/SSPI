//
//  feedSourceManager.h
//  SSPI
//
//  Created by Cheng Ma on 22/04/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"

@interface feedSourceManager : NSObject
{
    MKNetworkEngine *engine;
}

@property (readonly) NSString *dataLocation;
@property (readonly) NSString * type;
@property (readonly) NSInteger *userid;
@property (readonly) NSInteger *feedid;
@property (readonly) NSString *tags;
@property (readonly) UIImage *image;
@property (readonly) NSString *text;

-(id) initWithAttributes: (NSDictionary*) attributes;
- (void)printAttributes;
+ (void)globalTimelinePostsWithBlock:(void (^)(MKNetworkOperation *completedOperation, NSArray *posts, NSError *error))block;

@end
