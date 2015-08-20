//
//  AddressView.h
//  Hawkist
//
//  Created by Anton on 19.08.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressViewDelegate <NSObject>

- (void)editAction:(HWAddress*)address;
- (void)removeAction:(NSString*)addressId;

@end

@interface AddressView : UIView

@property (nonatomic,strong)id <AddressViewDelegate> delegate;

- (void) setAddress:(HWAddress*)address;


@end
