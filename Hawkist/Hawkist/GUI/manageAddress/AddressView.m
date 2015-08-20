//
//  AddressView.m
//  Hawkist
//
//  Created by Anton on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "AddressView.h"

@interface AddressView()
@property (strong, nonatomic) IBOutlet UILabel *addressLine1;
@property (strong, nonatomic) IBOutlet UILabel *addressLine2;
@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UILabel *postCode;
@property (strong, nonatomic) HWAddress *currentAddress;
@end
@implementation AddressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"addressView" owner:self options:nil]firstObject];
        
        view.frame = self.bounds;
        
        view.clipsToBounds = NO;
        view.layer.cornerRadius = 5.0f;
        [self addSubview:view];
        
    }
    return self;
}



- (void) setAddress:(HWAddress *)address
{
    self.currentAddress = address;
    self.addressLine1.text = address.address_line1;
    self.addressLine2.text = address.address_line2;
    self.city.text = address.city;
    self.postCode.text = address.postcode;
 
}

- (IBAction)editAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(editAction:)])
        [self.delegate editAction:self.currentAddress];
}

- (IBAction)deleteAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector: @selector(removeAction:)])
        [self.delegate removeAction:self.currentAddress.id];
    
}
@end
