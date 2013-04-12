//
//  ServerManager.h
//  SSPI
//
//  Created by Cheng Ma on 15/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject


- (void)addServer;
- (NSMutableArray *)getAllServers;
- (NSString *)getServer: (NSString *) servername;
- (void)removeServer: (NSString *) servername;


@end
