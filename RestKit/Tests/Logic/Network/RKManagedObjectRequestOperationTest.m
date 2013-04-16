//
//  RKManagedObjectRequestOperationTest.m
//  RestKit
//
//  Created by Blake Watters on 10/17/12.
//  Copyright (c) 2012 RestKit. All rights reserved.
//

#import "RKTestEnvironment.h"
#import "RKManagedObjectRequestOperation.h"
#import "RKEntityMapping.h"
#import "RKHuman.h"
#import "RKMappingErrors.h"

@interface RKManagedObjectRequestOperation ()
- (NSSet *)localObjectsFromFetchRequestsMatchingRequestURL:(NSError **)error;
@end

@interface RKManagedObjectRequestOperationTest : RKTestCase

@end

@implementation RKManagedObjectRequestOperationTest

- (void)setUp
{
    [RKTestFactory setUp];
}

- (void)tearDown
{
    [RKTestFactory tearDown];
}

- (void)testThatInitializationWithRequestDefaultsToSavingToPersistentStore
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://restkit.org"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/whatever" relativeToURL:manager.baseURL]];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[]];
    expect(operation.savesToPersistentStore).to.equal(YES);
}

- (void)testThatInitializationWithRequestOperationDefaultsToSavingToPersistentStore
{
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://restkit.org"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/whatever" relativeToURL:manager.baseURL]];
    RKHTTPRequestOperation *requestOperation = [[RKHTTPRequestOperation alloc] initWithRequest:request];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithHTTPRequestOperation:requestOperation responseDescriptors:@[]];
    expect(operation.savesToPersistentStore).to.equal(YES);
}

- (void)testFetchRequestBlocksAreInvokedWithARelativeURL
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org/api/v1/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"categories/1234" relativeToURL:baseURL]];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"categories/:categoryID" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    responseDescriptor.baseURL = baseURL;
    id mockRequestOperation = [OCMockObject niceMockForClass:[RKHTTPRequestOperation class]];
    [[[mockRequestOperation stub] andReturn:request] request];
    [[[mockRequestOperation stub] andReturn:response] response];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithHTTPRequestOperation:mockRequestOperation responseDescriptors:@[ responseDescriptor ]];
    
    __block NSURL *blockURL = nil;
    RKFetchRequestBlock fetchRequesBlock = ^NSFetchRequest *(NSURL *URL) {
        blockURL = URL;
        return nil;
    };
    
    operation.fetchRequestBlocks = @[fetchRequesBlock];
    NSError *error;
    [operation localObjectsFromFetchRequestsMatchingRequestURL:&error];
    expect(blockURL).notTo.beNil();
    expect([blockURL.baseURL absoluteString]).to.equal(@"http://restkit.org/api/v1/");
    expect(blockURL.relativePath).to.equal(@"categories/1234");
}

- (void)testThatFetchRequestBlocksInvokedWithRelativeURLAreInAgreementWithPathPattern
{
    NSURL *baseURL = [NSURL URLWithString:@"http://restkit.org/api/v1/"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"library/" relativeToURL:baseURL]];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"1.1" headerFields:@{}];
    expect([request.URL absoluteString]).to.equal(@"http://restkit.org/api/v1/library/");
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping pathPattern:@"library/" keyPath:nil statusCodes:[NSIndexSet indexSetWithIndex:200]];
    responseDescriptor.baseURL = baseURL;
    id mockRequestOperation = [OCMockObject niceMockForClass:[RKHTTPRequestOperation class]];
    [[[mockRequestOperation stub] andReturn:request] request];
    [[[mockRequestOperation stub] andReturn:response] response];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithHTTPRequestOperation:mockRequestOperation responseDescriptors:@[ responseDescriptor ]];
    __block NSURL *blockURL = nil;
    RKFetchRequestBlock fetchRequesBlock = ^NSFetchRequest *(NSURL *URL) {
        blockURL = URL;
        return nil;
    };
    
    operation.fetchRequestBlocks = @[fetchRequesBlock];
    NSError *error;
    [operation localObjectsFromFetchRequestsMatchingRequestURL:&error];
    expect(blockURL).notTo.beNil();
    expect([blockURL absoluteString]).to.equal(@"http://restkit.org/api/v1/library/");
    expect([blockURL.baseURL absoluteString]).to.equal(@"http://restkit.org/api/v1/");
    expect(blockURL.relativePath).to.equal(@"library");
    expect(blockURL.relativeString).to.equal(@"library/");
}

- (void)testThatMappingResultContainsObjectsFetchedFromManagedObjectContextTheOperationWasInitializedWith
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/JSON/humans/all.json" relativeToURL:[RKTestFactory baseURL]]];
    RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
    RKEntityMapping *humanMapping = [RKEntityMapping mappingForEntityForName:@"Human" inManagedObjectStore:managedObjectStore];
    [humanMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"name" toKeyPath:@"name"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:humanMapping pathPattern:nil keyPath:@"human" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    managedObjectRequestOperation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    
    [managedObjectRequestOperation start];
    [managedObjectRequestOperation waitUntilFinished];
    expect(managedObjectRequestOperation.mappingResult).notTo.beNil();
    NSArray *managedObjectContexts = [[managedObjectRequestOperation.mappingResult array] valueForKeyPath:@"@distinctUnionOfObjects.managedObjectContext"];
    expect([managedObjectContexts count]).to.equal(1);
    expect(managedObjectContexts[0]).to.equal(managedObjectStore.mainQueueManagedObjectContext);
}

// 304 'Not Modified'
- (void)testThatManagedObjectsAreFetchedWhenHandlingANotModifiedResponse
{
    RKFetchRequestBlock fetchRequestBlock = ^(NSURL *URL){
        return [NSFetchRequest fetchRequestWithEntityName:@"Human"];
    };
    
    RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
    RKHuman *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectStore.mainQueueManagedObjectContext];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/204_with_not_modified_status" relativeToURL:[RKTestFactory baseURL]]];
    RKEntityMapping *humanMapping = [RKEntityMapping mappingForEntityForName:@"Human" inManagedObjectStore:managedObjectStore];
    [humanMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"name" toKeyPath:@"name"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:humanMapping pathPattern:nil keyPath:@"human" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    managedObjectRequestOperation.fetchRequestBlocks = @[fetchRequestBlock];
    managedObjectRequestOperation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    
    [managedObjectRequestOperation start];
    [managedObjectRequestOperation waitUntilFinished];
    expect(managedObjectRequestOperation.mappingResult).notTo.beNil();
    NSArray *mappedObjects = [managedObjectRequestOperation.mappingResult array];
    expect(mappedObjects).to.haveCountOf(1);
    expect(mappedObjects[0]).to.equal(human);
}

- (void)testThatInvalidObjectFailingManagedObjectContextSaveFailsOperation
{
    // NOTE: The model defines a maximum length of 15 for the 'name' attribute    
    RKManagedObjectStore *managedObjectStore = [RKTestFactory managedObjectStore];
    RKHuman *human = [NSEntityDescription insertNewObjectForEntityForName:@"Human" inManagedObjectContext:managedObjectStore.mainQueueManagedObjectContext];
    human.name = @"This Is An Invalid Name Because It Exceeds Fifteen Characters";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/JSON/humans/all.json" relativeToURL:[RKTestFactory baseURL]]];
    RKEntityMapping *humanMapping = [RKEntityMapping mappingForEntityForName:@"Human" inManagedObjectStore:managedObjectStore];
    [humanMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"name" toKeyPath:@"name"]];
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:humanMapping pathPattern:nil keyPath:@"human" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    RKManagedObjectRequestOperation *managedObjectRequestOperation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    managedObjectRequestOperation.managedObjectContext = managedObjectStore.mainQueueManagedObjectContext;
    
    [managedObjectRequestOperation start];
    [managedObjectRequestOperation waitUntilFinished];
    expect(managedObjectRequestOperation.error).notTo.beNil();
    expect(managedObjectRequestOperation.mappingResult).to.beNil();
    expect([managedObjectRequestOperation.error localizedDescription]).to.equal(@"The operation couldn’t be completed. (Cocoa error 1660.)");
}

@end
