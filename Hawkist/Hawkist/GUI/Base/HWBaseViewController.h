//
//  HWBaseViewController.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 6/16/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWBaseViewController : UIViewController
@property (nonatomic,assign)BOOL isInternetConnectionAlertShowed;


- (void) showHud;
- (void) hideHud;
- (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message;
- (void) showAlertWithTitle:(NSString*)title Message:(NSString*) message withDelegate:(id)delegate;

@end
