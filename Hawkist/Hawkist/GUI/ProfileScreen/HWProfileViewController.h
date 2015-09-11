//
//  HWProfileViewController.h
//  Hawkist
//
//  Created by User on 14.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBaseViewController.h"

@interface HWProfileViewController : HWBaseViewController

- (instancetype) initWithUserID:(NSString*)userID;
-(instancetype) initWithUser:(HWUser*)user;



@end
