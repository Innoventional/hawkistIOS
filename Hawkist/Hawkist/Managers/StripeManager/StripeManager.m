//
//  StripeManager.m
//  Hawkist
//
//  Created by Svyatoslav Shaforenko on 8/3/15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "StripeManager.h"
#import "Stripe.h"
#import "const.h"

@implementation StripeManager

#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static StripeManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedInstance = [[StripeManager alloc] init];
    });
    return sharedInstance;
}

- (void) createTokenFromCardNumber: (NSString*) number
                          expMonth: (NSUInteger) expMonth
                           expYear: (NSUInteger) expYear
                               cvc: (NSString*) cvc
                      addressLine1: (NSString*) addressLine1
                      addressLine2: (NSString*) addressLine2
                              name: (NSString*) name
                          postCode: (NSString*) postCode
                              city: (NSString*) city
                        completion: (void (^) (NSString* tokenId, NSError* error)) completion
{
    STPCard *card = [[STPCard alloc] init];
    card.number = number;
    card.expMonth = expMonth;
    card.expYear = expYear;
    card.cvc = cvc;
    card.addressLine1 = addressLine1;
    card.addressLine2 = addressLine2;
    card.name = name;
    card.addressCity = city;
    card.addressZip = postCode;
    STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey: STRIPE_KEY];
    [client createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            completion(token.tokenId, nil);
        }
    }];
}

@end
