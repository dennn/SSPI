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
        inactiveServerTable = [[NSMutableArray alloc] init];
        authInformation = [[NSMutableArray alloc] init];
        [self load];
        if (activeServer ==nil)
        {
            NSLog(@"create");
            activeServer = [[AFHTTPClient alloc] initWithBaseURL:[[NSURL alloc] initWithString:@"thenicestthing.co.uk"]];
        }
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

-(int) tablesize
{
    return [inactiveServerTable count];
}

-(NSString*) getNameAtIndex:(int)index
{
    NSURL *URLpath = [[inactiveServerTable objectAtIndex:index] baseURL];
    return [URLpath absoluteString];
}

-(NSString *)getActiveServerName
{
    NSURL *URLpath = [activeServer baseURL];
    return [URLpath absoluteString];
}

-(void) addServerByPathAndAuth:(NSString *)Path User:(NSString *)username Pass:(NSString *)password
{
    NSURL* URLString =[[NSURL alloc] initWithString:Path];
    AFHTTPClient *server = [[AFHTTPClient alloc] initWithBaseURL:URLString];
    [server setAuthorizationHeaderWithUsername:username password:password];
    [inactiveServerTable addObject:server];
    [self save];
}

-(void) addServerByHTTPClient:(AFHTTPClient *)Client
{
    [inactiveServerTable addObject:Client];
    [self save];
}

-(void) deleteServerByIndex:(int)index
{
    [inactiveServerTable removeObjectAtIndex:index];
    [self save];
}

-(AFHTTPClient*) searchServerByIndex:(int *)index 
{
    return [inactiveServerTable objectAtIndex:index];
}

-(AFHTTPClient*) searchServerByServername:(NSString *)servername name:(NSString *)tablename
{
    for (AFHTTPClient*server in inactiveServerTable) {
        NSString* searchname = [[server baseURL] absoluteString];
        if ([searchname isEqualToString:servername]) {
            return server;
        }
    }
    return nil;
}

-(AFHTTPClient *)getActiveServer
{
    return activeServer;
}

-(void)updateActiveServer:(AFHTTPClient *)newActives
{
    activeServer = newActives;
    [self save];
}

-(void) save
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *inactivestrings = [[NSMutableArray alloc] init];
    if ([inactiveServerTable count] == 0) {
        [userdefaults removeObjectForKey:@"inactive"];
        [userdefaults synchronize];
    }
    else
    {
        for (int i =0; i<[inactiveServerTable count]; i++) {
            AFHTTPClient* temp = [self searchServerByIndex:i];
            NSString* stringURL = [[temp baseURL] absoluteString];
            [inactivestrings addObject:stringURL];
        }
    }
    [userdefaults setObject:inactivestrings forKey:@"inactive"];
    NSString* active = [[activeServer baseURL] absoluteString];
    [userdefaults setObject:active forKey:@"active"];
    NSLog(@"saved:%@",[userdefaults objectForKey:@"active"]);
    [userdefaults synchronize];
}

-(void)load
{
    NSLog(@"Load");
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *inactivestrings = [userdefaults objectForKey:@"inactive"];
    if ([userdefaults objectForKey:@"active"] != nil) {
        NSURL* URLString =[[NSURL alloc] initWithString:[userdefaults objectForKey:@"active"]];
        AFHTTPClient *server = [[AFHTTPClient alloc] initWithBaseURL:URLString];
        activeServer = server;
    }
    for(int i=0; i< [inactivestrings count]; i++)
    {
        [self addServerByPathAndAuth:[inactivestrings objectAtIndex:i] User:@"test" Pass:@"test"];
    }

}

@end
