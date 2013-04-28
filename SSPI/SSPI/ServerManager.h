//
//  ServerManager.h
//  SSPI
//
//  Created by Cheng Ma on 15/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface ServerManager : NSObject{
    NSMutableArray * inactiveServerTable;
    NSMutableArray * authInformation;
    AFHTTPClient * activeServer;
}


//make a class instance
+ (ServerManager*) instance;
//return tablesize
- (int)tablesize;

//add AFHTTPClient object by given path, username and password, and table name
- (void)addServerByPathAndAuth: (NSString *)Path User:(NSString *)username Pass:(NSString *)password;
//add AFHTTPClient by existing object
- (void)addServerByHTTPClient: (AFHTTPClient *)Client;
//delete server from a table by given index and tablename
- (void)deleteServerByIndex: (int)index;

//search server methods
- (AFHTTPClient*) searchServerByIndex: (int *)index;
- (AFHTTPClient*) searchServerByServername: (NSString *)servername;

//get absolute URL string from a AFHttpclient object
- (NSString* )getNameAtIndex: (int)index;

- (NSString* )getActiveServerName;
//save and load for user default
- (AFHTTPClient* )getActiveServer;
- (void)updateActiveServer:(AFHTTPClient* )newActives;

- (BOOL)checkValid:(AFHTTPClient* )Server;

- (void)save;
- (void)load;
@end
