//
//  HWWebViewZendeskViewController.h
//  Hawkist
//
//  Created by User on 11.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWBaseViewController.h"


typedef NS_ENUM(NSInteger, HWZendeskLink) {
    
    HWZendeskLinkManaginfMyAccount = 0,
    HWZendeskLinkBuyingSelling,
    HWZendeskLinkRefundPolicy,
    HWZendeskLinkPrivacyPolicy,
    HWZendeskLinkTermsOfUse
    
    
};

@interface HWWebViewZendeskViewController : HWBaseViewController


-(instancetype)initWithNumberLink:(HWZendeskLink)zendeskLink;

@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
