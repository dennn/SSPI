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
    MKNetworkEngine * engine;
}

-(void) getFeedsFromServer;

@end
