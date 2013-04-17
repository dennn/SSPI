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
    NSMutableArray * activeServerTable;
    NSMutableArray * inactiveServerTable;
    NSMutableArray * authInformation;
}


//make a class instance
+ (ServerManager*) instance;
//return tablesize
- (int)tablesizeByName: (NSString *) tablename;
//return table by name
- (NSMutableArray*) selectTable: (NSString *) tablename;

//add AFHTTPClient object by given path, username and password, and table name
- (void)addServerByPathAndAuth: (NSString *)Path User:(NSString *)username Pass:(NSString *)password Table:(NSString *)table;
//add AFHTTPClient by existing object
- (void)addServerByHTTPClient: (AFHTTPClient *)Client name:(NSString *)tablename;
//delete server from a table by given index and tablename
- (void)deleteServerByIndex: (int)index name:(NSString *)tablename;

//search server methods
- (AFHTTPClient*) searchServerByIndex: (int *)index name:(NSString* )tablename;
- (AFHTTPClient*) searchServerByServername: (NSString *)servername name:(NSString *)tablename;

//get absolute URL string from a AFHttpclient object
- (NSString* )getNameAtIndex: (int)index name:(NSString *)tablename;

//save and load for user default
- (void)save;
- (void)load;
@end
