//
//  HWBraintreeManager.m
//  Hawkist
//
//  Created by User on 25.09.15.
//  Copyright © 2015 TecSynt Solutions. All rights reserved.
//

#import "HWBraintreeManager.h"
#import <Braintree/Braintree.h>
#import "const.h"

@implementation HWBraintreeManager



#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static HWBraintreeManager* sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once( &onceToken, ^{
        sharedInstance = [HWBraintreeManager new];
    });
    return sharedInstance;
}


- (void) createTokenFromCardNumber: (NSString*) number
                          expMonth: (NSUInteger) expMonth
                           expYear: (NSUInteger) expYear
                               cvv: (NSString*) cvv
                      addressLine1: (NSString*) addressLine1
                      addressLine2: (NSString*) addressLine2
                              name: (NSString*) name
                          postCode: (NSString*) postCode
                              city: (NSString*) city
                        completion: (void (^) (NSString* tokenId, NSError* error)) completion
{
    
    NSString *clientToken = @"eyJ2ZXJzaW9uIjoyLCJhdXRob3JpemF0aW9uRmluZ2VycHJpbnQiOiJkZDdlMmI1YjllY2JkNTNjZjE2N2E4MGRjMmIwOWViMTUwNTZmY2MxZWExNTYwNTAzYTBkMDRjNWQzNzc2MDYxfGNyZWF0ZWRfYXQ9MjAxNS0wOS0yNVQxMzoxMToyNS45ODQ1ODIyMjYrMDAwMFx1MDAyNm1lcmNoYW50X2lkPTM0OHBrOWNnZjNiZ3l3MmJcdTAwMjZwdWJsaWNfa2V5PTJuMjQ3ZHY4OWJxOXZtcHIiLCJjb25maWdVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi9jbGllbnRfYXBpL3YxL2NvbmZpZ3VyYXRpb24iLCJjaGFsbGVuZ2VzIjpbXSwiZW52aXJvbm1lbnQiOiJzYW5kYm94IiwiY2xpZW50QXBpVXJsIjoiaHR0cHM6Ly9hcGkuc2FuZGJveC5icmFpbnRyZWVnYXRld2F5LmNvbTo0NDMvbWVyY2hhbnRzLzM0OHBrOWNnZjNiZ3l3MmIvY2xpZW50X2FwaSIsImFzc2V0c1VybCI6Imh0dHBzOi8vYXNzZXRzLmJyYWludHJlZWdhdGV3YXkuY29tIiwiYXV0aFVybCI6Imh0dHBzOi8vYXV0aC52ZW5tby5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIiwiYW5hbHl0aWNzIjp7InVybCI6Imh0dHBzOi8vY2xpZW50LWFuYWx5dGljcy5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tIn0sInRocmVlRFNlY3VyZUVuYWJsZWQiOnRydWUsInRocmVlRFNlY3VyZSI6eyJsb29rdXBVcmwiOiJodHRwczovL2FwaS5zYW5kYm94LmJyYWludHJlZWdhdGV3YXkuY29tOjQ0My9tZXJjaGFudHMvMzQ4cGs5Y2dmM2JneXcyYi90aHJlZV9kX3NlY3VyZS9sb29rdXAifSwicGF5cGFsRW5hYmxlZCI6dHJ1ZSwicGF5cGFsIjp7ImRpc3BsYXlOYW1lIjoiQWNtZSBXaWRnZXRzLCBMdGQuIChTYW5kYm94KSIsImNsaWVudElkIjpudWxsLCJwcml2YWN5VXJsIjoiaHR0cDovL2V4YW1wbGUuY29tL3BwIiwidXNlckFncmVlbWVudFVybCI6Imh0dHA6Ly9leGFtcGxlLmNvbS90b3MiLCJiYXNlVXJsIjoiaHR0cHM6Ly9hc3NldHMuYnJhaW50cmVlZ2F0ZXdheS5jb20iLCJhc3NldHNVcmwiOiJodHRwczovL2NoZWNrb3V0LnBheXBhbC5jb20iLCJkaXJlY3RCYXNlVXJsIjpudWxsLCJhbGxvd0h0dHAiOnRydWUsImVudmlyb25tZW50Tm9OZXR3b3JrIjp0cnVlLCJlbnZpcm9ubWVudCI6Im9mZmxpbmUiLCJ1bnZldHRlZE1lcmNoYW50IjpmYWxzZSwiYnJhaW50cmVlQ2xpZW50SWQiOiJtYXN0ZXJjbGllbnQzIiwiYmlsbGluZ0FncmVlbWVudHNFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRBY2NvdW50SWQiOiJhY21ld2lkZ2V0c2x0ZHNhbmRib3giLCJjdXJyZW5jeUlzb0NvZGUiOiJVU0QifSwiY29pbmJhc2VFbmFibGVkIjpmYWxzZSwibWVyY2hhbnRJZCI6IjM0OHBrOWNnZjNiZ3l3MmIiLCJ2ZW5tbyI6Im9mZiJ9";
    
    Braintree *braintree = [Braintree braintreeWithClientToken:clientToken];
    
    BTClientCardTokenizationRequest *cardTokenizationRequest = [[BTClientCardTokenizationRequest alloc]init];
    cardTokenizationRequest.number = number;
    cardTokenizationRequest.expirationMonth = [NSString stringWithFormat:@"%lu",(unsigned long)expMonth];
    cardTokenizationRequest.expirationYear = [NSString stringWithFormat:@"%lu",(unsigned long)expYear];
    cardTokenizationRequest.expirationDate = [NSString stringWithFormat:@"%lu/%lu",(unsigned long)expMonth, (unsigned long)expYear];

    cardTokenizationRequest.postalCode = postCode;
    cardTokenizationRequest.cvv = cvv;
    
    [braintree tokenizeCard: cardTokenizationRequest completion:^(NSString * _Nullable nonce, NSError * _Nullable error) {
        
        NSLog(@"%@", nonce);
        
        completion(nonce, error);
        
    }];
    
    
}
                          
@end
