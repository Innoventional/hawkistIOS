//
//  HWBankAccountAddress.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWBankAccountAddress : JSONModel

@property (nonatomic, strong) NSString <Optional>* address_line1;
@property (nonatomic, strong) NSString <Optional>* address_line2;
@property (nonatomic, strong) NSString <Optional>* city;
@property (nonatomic, strong) NSString <Optional>* post_code;

@end



