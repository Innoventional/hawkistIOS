//
//  HWBankUserInfo.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWBankUserInfo : JSONModel

@property (nonatomic, strong) NSString <Optional>* first_name;
@property (nonatomic, strong) NSString <Optional>* last_name;
@property (nonatomic, strong) NSString <Optional>* birth_date;
@property (nonatomic, strong) NSString <Optional>* birth_month;
@property (nonatomic, strong) NSString <Optional>* birth_year;


@end
