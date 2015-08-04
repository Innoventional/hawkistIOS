//
//  HWAddDataModel.h
//  Hawkist
//
//  Created by User on 04.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWAddDataModel : NSObject

@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *descriptionStr;
@property (nonatomic, strong) NSString *titleForButtonStr;

- (instancetype) initWithTitle:(NSString*)title
                   description:(NSString*)description
                titleForButton:(NSString*)titleButton;

@end
