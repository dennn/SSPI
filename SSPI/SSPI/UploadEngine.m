//
//  UploadEngine.m
//  SSPI
//
//  Created by Ryan Connolly on 30/01/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import "UploadEngine.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation UploadEngine

-(id)init{
    return self = [super initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
}

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path {
    
    MKNetworkOperation *op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:NO];
    return op;
}

/* Sends image to server, should be extended (MKNetworkKit used) */
- (void)sendImage:(NSString *)filename lat:(NSString *)latitude lon:(NSString *)longitude tags:(NSString *)tags type:(NSString *)type{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dataPath = [documentsPath stringByAppendingPathComponent:filename];
    NSData *data = nil;
    NSString *mimetype = @"";
    NSString *extension = @"";
    if([type isEqualToString:@"photo"]){
        UIImage *image = [UIImage imageWithContentsOfFile:dataPath];
        data = UIImageJPEGRepresentation(image, 0.1);
        mimetype = @"image/jpeg";
        extension = @"jpeg";
    }else{
        data = [NSData dataWithContentsOfFile:dataPath];
        mimetype = @"video/mp4";
        extension = @"mp4";
    }
    NSLog(@"Image path:  %@", dataPath);
    
    //self = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       latitude, @"lat",longitude, @"long",@"634", @"userID",tags,@"tags",
                                       nil];
    self.operation = [self postDataToServer:postParams path:@"coomko/index.php/uploads/run"];
    [self.operation addData:data forKey:@"userfl" mimeType:mimetype fileName:[NSString stringWithFormat:@"upload.%@", extension]];
    
    [self.operation addCompletionHandler:^(MKNetworkOperation* networkOperation) {
        NSLog(@"%@", [networkOperation responseString]);
        NSLog(@"Sent");
    }
                            errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }];
    
    [self enqueueOperation:self.operation ];
}

/*- (void)sendText:(NSString *)filename type:(NSString *)type lat:(NSString *)latitude lon:(NSString *)longitude tags:(NSString *)tags {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* dataPath = [documentsPath stringByAppendingPathComponent:filename];
    NSString* string = [[NSString alloc] initWithData:[[NSFileManager defaultManager] contentsAtPath:dataPath] encoding:NSUTF8StringEncoding];
    
    //self.uploadEngine = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       type, @"type",latitude, @"lat",longitude, @"long",@"634", @"userID",tags,@"tags",
                                       nil];
    [postParams setValue:string forKey:@"text"];
    self.operation = [self.uploadEngine postDataToServer:postParams path:@"coomko/index.php/uploads/run"];
    NSLog(@"GOT THIS FAR - %@", string);
    [self.operation addCompletionHandler:^(MKNetworkOperation* networkOperation) {
        NSLog(@"%@", [networkOperation responseString]);
    }
                            errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }];
    
    [self.uploadEngine enqueueOperation:self.operation ];
}
*/
-(void)sendAudio:(NSString *)filename lat:(NSString *)latitude lon:(NSString *)longitude tags:(NSString *)tags {
    NSURL *url = [NSURL fileURLWithPath: [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, filename ]];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    NSLog(@"Sending Audio data: %@", [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, filename ]);
    
    //self = [[UploadEngine alloc] initWithHostName:@"thenicestthing.co.uk" customHeaderFields:nil];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       latitude, @"lat",longitude, @"long",@"634", @"userID",tags,@"tags",
                                       nil];
    self.operation = [self postDataToServer:postParams path:@"coomko/index.php/uploads/run"];
    [self.operation addData:audioData forKey:@"userfl" mimeType:@"audio/x-caf" fileName:@"upload.caf"];
    
    [self.operation addCompletionHandler:^(MKNetworkOperation* networkOperation) {
        NSLog(@"%@", [networkOperation responseString]);
        NSLog(@"Sent");
    }
                            errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
                                NSLog(@"%@", error);
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"Dismiss"
                                                                      otherButtonTitles:nil];
                                [alert show];
                            }];
    
    [self enqueueOperation:self.operation ];
}

- (void)syncPressed:(UIViewController *)controller {
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = controller.view.center;
	[controller.view addSubview: activityIndicator];
    NSString *DocPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* plistPath=[DocPath stringByAppendingPathComponent:@"sync.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]){
        NSLog(@"Nothing yet synced");
        return;
    }
    
    NSArray* a = [NSArray arrayWithContentsOfFile:plistPath];
    for (NSDictionary *d in a){
        NSLog(@"Type: %@, filename: %@, lat: %@, lon: %@, tags: %@", [d objectForKey:@"Type"],[d objectForKey:@"Name"],[d objectForKey:@"Latitude"],[d objectForKey:@"Longitude"],[d objectForKey:@"Tags"]);
        NSLog(@"%@", [d objectForKey:@"Type"]);
        if([[d objectForKey:@"Type"] isEqualToString:@"photo"])
            [self sendImage:[d objectForKey:@"Name"] lat:[d objectForKey:@"Latitude"] lon:[d objectForKey:@"Longitude"] tags:[d objectForKey:@"Tags"] type:[d objectForKey:@"Type"]];
        //else if([[d objectForKey:@"Type"] isEqualToString:@"text"])
            //[self sendText:[d objectForKey:@"Name"] type:[d objectForKey:@"Type"] lat:[d objectForKey:@"Latitude"] lon:[d objectForKey:@"Longitude"] tags:[d objectForKey:@"Tags"]];
        //else if([[d objectForKey:@"Type"] isEqualToString:@"video"])
            //[self sendImage:[d objectForKey:@"Name"] lat:[d objectForKey:@"Latitude"] lon:[d objectForKey:@"Longitude"] tags:[d objectForKey:@"Tags"] type:[d objectForKey:@"Type"]];
        //else if([[d objectForKey:@"Type"] isEqualToString:@"audio"])
            //[self sendAudio:[d objectForKey:@"Name"] lat:[d objectForKey:@"Latitude"] lon:[d objectForKey:@"Longitude"] tags:[d objectForKey:@"Tags"]];
    }
    
    // Open the plist from the filesystem.
    NSMutableArray *plist = nil;
    if (plist == nil) plist = [NSMutableArray array];
    [plist writeToFile:plistPath atomically:YES];
    NSLog(@"sync'd");
}


@end
