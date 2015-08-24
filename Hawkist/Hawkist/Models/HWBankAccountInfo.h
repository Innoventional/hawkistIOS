//
//  HWBankAccountInfo.h
//  Hawkist
//
//  Created by User on 24.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWBankAccountInfo : JSONModel

@property (strong, nonatomic)NSString<Optional>* holder_first_name;
@property (strong, nonatomic)NSString<Optional>* holder_last_name;
@property (strong, nonatomic)NSString<Optional>* number;
@property (strong, nonatomic)NSString<Optional>* sort_code;


@end
