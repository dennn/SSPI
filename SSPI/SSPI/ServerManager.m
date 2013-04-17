//
//  ServerManager.m
//  SSPI
//
//  Created by Cheng Ma on 15/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager

-(id)init
{
    if(self =[super init])
    {
        activeServerTable = [[NSMutableArray alloc] init];
        inactiveServerTable = [[NSMutableArray alloc] init];
        authInformation = [[NSMutableArray alloc] init];
        [self load];
    }
    return self;
}

+ (ServerManager *)instance
{
    //  Static local predicate must be initialized to 0
    static ServerManager *Instance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        Instance = [[ServerManager alloc] init];
        // Do any other initialisation stuff here
    });
    return Instance;
}

-(int) tablesizeByName: (NSString*) name
{
    if ([name isEqualToString:@"active"]) 
        return [activeServerTable count];
    else
        return [inactiveServerTable count];
}

-(NSMutableArray*) selectTable:(NSString *)tablename
{
    if([tablename isEqualToString:@"active"])
        return activeServerTable;
    else
        return inactiveServerTable;
}

-(NSString*) getNameAtIndex:(int)index name:(NSString *)tablename
{
    NSURL *URLpath = [[[self selectTable:tablename] objectAtIndex:index] baseURL];
    return [URLpath absoluteString];
}

-(void) addServerByPathAndAuth:(NSString *)Path User:(NSString *)username Pass:(NSString *)password Table:(NSString *)table
{
    NSURL* URLString =[[NSURL alloc] initWithString:Path];
    AFHTTPClient *server = [[AFHTTPClient alloc] initWithBaseURL:URLString];
    [server setAuthorizationHeaderWithUsername:username password:password];
    [[self selectTable:table] addObject:server];
    [self save];
}

-(void) addServerByHTTPClient:(AFHTTPClient *)Client name:(NSString *)tablename
{
    [[self selectTable:tablename] addObject:Client];
    [self save];
}

-(void) deleteServerByIndex:(int)index name:(NSString *)tablename
{
    [[self selectTable:tablename] removeObjectAtIndex:index];
    [self save];
}

-(AFHTTPClient*) searchServerByIndex:(int *)index name:(NSString *)tablename
{
    return [[self selectTable:tablename] objectAtIndex:index];
}

-(AFHTTPClient*) searchServerByServername:(NSString *)servername name:(NSString *)tablename
{
    for (AFHTTPClient*server in [self selectTable:tablename]) {
        NSString* searchname = [[server baseURL] absoluteString];
        if ([searchname isEqualToString:servername]) {
            return server;
        }
    }
    return nil;
}

-(void) save
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *activestrings = [[NSMutableArray alloc] init];
    NSMutableArray *inactivestrings = [[NSMutableArray alloc] init];
    if ([activeServerTable count] == 0)
    {
        [userdefaults removeObjectForKey:@"active"];
        [userdefaults synchronize];
    }
    else
    {
        for (int i =0; i<[activeServerTable count]; i++) {
            AFHTTPClient* temp = [self searchServerByIndex:i name:@"active"];
            NSString* stringURL = [[temp baseURL] absoluteString];
            [activestrings addObject:stringURL];
        }
    }
    [userdefaults setObject:activestrings forKey:@"active"];
    [userdefaults synchronize];
    if ([inactiveServerTable count] == 0) {
        [userdefaults removeObjectForKey:@"inactive"];
        [userdefaults synchronize];
    }
    else
    {
        for (int i =0; i<[inactiveServerTable count]; i++) {
            AFHTTPClient* temp = [self searchServerByIndex:i name:@"inactive"];
            NSString* stringURL = [[temp baseURL] absoluteString];
            [inactivestrings addObject:stringURL];
        }
    }
    [userdefaults setObject:inactivestrings forKey:@"inactive"];
    [userdefaults synchronize];
}

-(void)load
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *activestrings = [userdefaults objectForKey:@"active"];
    NSMutableArray *inactivestrings = [userdefaults objectForKey:@"inactive"];
    for(int i=0; i< [activestrings count]; i++)
    {
        [self addServerByPathAndAuth:[activestrings objectAtIndex:i] User:@"test" Pass:@"test" Table:@"active"];
    }
    for(int i=0; i< [inactivestrings count]; i++)
    {
        [self addServerByPathAndAuth:[inactivestrings objectAtIndex:i] User:@"test" Pass:@"test" Table:@"inactive"];
    }
}

@end
