//
//  HWCard.h
//  Hawkist
//
//  Created by Anton on 31.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWCard : NSObject
@property (strong, nonatomic)NSString* cardName;
@property (strong, nonatomic)NSString* lastNumber;
@property (strong, nonatomic)NSString* month;
@property (strong, nonatomic)NSString* year;

@end
