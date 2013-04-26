//
//  PinViewController.h
//  SSPI
//
//  Created by Den on 17/02/2013.
//  Copyright (c) 2013 COOMKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pin.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPin:(Pin *)pin;

@end
