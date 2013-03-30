//
//  TDDatePickerController.h
//
//  Created by Nathan  Reed on 30/09/10.
//  Copyright 2010 Nathan Reed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"TDSemiModal.h"


@interface TDDatePickerController : TDSemiModalViewController {
	id delegate;
}

@property (nonatomic, strong) IBOutlet id delegate;
@property (nonatomic, strong) IBOutlet UIDatePicker* datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

-(IBAction)saveDate:(id)sender;
-(IBAction)saveDateNever:(id)sender;

@end

@interface NSObject (TDDatePickerControllerDelegate)
-(void)datePickerSetDate:(TDDatePickerController*)viewController;
-(void)datePickerSetDateNever:(TDDatePickerController*)viewController;
-(void)datePickerCancel:(TDDatePickerController*)viewController;
@end

