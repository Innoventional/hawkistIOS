//
//  HWWebViewZendeskViewController.m
//  Hawkist
//
//  Created by User on 11.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWWebViewZendeskViewController.h"
#import "NavigationVIew.h"

@interface HWWebViewZendeskViewController () <NavigationViewDelegate>

@property (nonatomic, weak) IBOutlet NavigationVIew *navBar;
@property (nonatomic, strong) NSString *currentUrl;
@property (nonatomic, strong) NSString *titleStr;

@end

@implementation HWWebViewZendeskViewController

#define MANAGING_MY_ACCOUNT @"https://hawkist.zendesk.com/hc/en-us/sections/201277702-Managing-My-Account"
#define BUYING_SELLING @"https://hawkist.zendesk.com/hc/en-us/categories/200603732-Frequently-Asked-Questions"
#define  REFUND_POLICY @"https://hawkist.zendesk.com/hc/en-us/articles/204470212"
#define PRIVACY_POLICY @"https://hawkist.zendesk.com/hc/en-us/articles/204465182-Privacy-Policy"
#define TERMS_OF_USE @"https://hawkist.zendesk.com/hc/en-us/sections/201400962-Terms-of-Use"



-(instancetype)initWithNumberLink:(HWZendeskLink)zendeskLink {
    
    self = [self init];
    if(self) {
        
        switch (zendeskLink) {
                
                
            case HWZendeskLinkManaginfMyAccount:
                
                self.title = @"Managing my account";
                self.currentUrl = MANAGING_MY_ACCOUNT;
                break;
            
            case HWZendeskLinkBuyingSelling:
                
                self.title = @"Buying selling";
                self.currentUrl = BUYING_SELLING;
                break;
                
            case HWZendeskLinkRefundPolicy:
                
                self.title = @"Refund policy";
                self.currentUrl = REFUND_POLICY;
                break;
                
            case HWZendeskLinkPrivacyPolicy:
                
                self.title = @"Privacy policy";
                self.currentUrl = PRIVACY_POLICY;
                break;
                
            case HWZendeskLinkTermsOfUse:
                
                self.title = @"Terms of use";
                self.currentUrl = TERMS_OF_USE;
                break;
            
                
                
            default:
                break;
        }
    }
    
    return self;
}

- (instancetype)init
{
    self = [super initWithNibName: @"zendeskWebView" bundle: nil];
    if(self)
    {
        
    }
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navBar.delegate = self;
    self.navBar.title.text = self.titleStr;
    
    
    NSURLRequest *re = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.currentUrl]];
    
    [self.webView loadRequest:re];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationViewDelegate


-(void) leftButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void) rightButtonClick {
    
    
}

@end
