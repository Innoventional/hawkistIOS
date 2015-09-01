//
//  HWOffer.h
//  Hawkist
//
//  Created by User on 23.07.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "JSONModel.h"

@interface HWOffer : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, strong) NSString<Optional>* offer_creater_id;
@property (nonatomic, strong) NSString<Optional>* offer_receiver_id;
@property (nonatomic, strong) NSString<Optional>* visibility;


@end
