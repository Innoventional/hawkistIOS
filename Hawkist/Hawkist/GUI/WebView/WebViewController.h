//
//  WebViewController.h
//  
//
//  Created by Anton on 30.08.15.
//
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"

@interface WebViewController : HWBaseViewController

- (instancetype)initWithUrl:(NSString*)url andTitle:(NSString*)title;

@end
