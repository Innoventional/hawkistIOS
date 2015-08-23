//
//  HWAddressOptionCell.m
//  Hawkist
//
//  Created by User on 02.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWAddressOptionCell.h"

@interface HWAddressOptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *address_line1;
@property (weak, nonatomic) IBOutlet UILabel *adress_line2;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCodeLable;


@end

@implementation HWAddressOptionCell


-(void) setCellWithAddress:(HWAddress *) address
{
    self.cityLabel.text = address.city;
    self.postCodeLable.text = address.postcode;
    self.address_line1.text = address.address_line1;
    if (address.address_line2) {
        
        self.adress_line2.text = address.address_line2;
    } else {
        
        self.adress_line2.text = @"";
    }
    
    
    
}

@end

/*

@property (strong, nonatomic)NSString<Optional>* id;
@property (strong, nonatomic)NSString* address_line1;
@property (strong, nonatomic)NSString<Optional>* address_line2;
@property (strong, nonatomic)NSString* city;
@property (strong, nonatomic)NSString* postcode;

*/