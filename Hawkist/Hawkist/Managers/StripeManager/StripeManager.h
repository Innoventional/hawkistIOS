//
//  StripeManager.h
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 8/3/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StripeManager : NSObject

+ (instancetype) shared;

- (void) createTokenFromCardNumber: (NSString*) number
                          expMonth: (NSUInteger) expMonth
                           expYear: (NSUInteger) expYear
                               cvc: (NSString*) cvc
                      addressLine1: (NSString*) addressLine1
                      addressLine2: (NSString*) addressLine2
                              name: (NSString*) name
                          postCode: (NSString*) postCode
                              city: (NSString*) city
                        completion: (void (^) (NSString* tokenId, NSError* error)) completion;

@end
