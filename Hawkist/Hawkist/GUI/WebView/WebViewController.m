//
//  WebViewController.m
//  
//
//  Created by Anton on 30.08.15.
//
//

#import "WebViewController.h"
#import "NavigationVIew.h"

@interface WebViewController () <NavigationViewDelegate,UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet NavigationVIew *navigation;
@property (strong, nonatomic) IBOutlet UIWebView *content;
@property (strong, nonatomic) NSString* url;
@property (strong, nonatomic) NSString* viewTitle;
@property (nonatomic, assign) BOOL allowLoad;
@end

@implementation WebViewController


- (instancetype) init{
    
    self = [super initWithNibName: @"WebView" bundle: nil];
    return self;
}

- (instancetype)initWithUrl:(NSString*)url andTitle:(NSString*)title
{
    if (self = [self init])
    {
        self.viewTitle = title;
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.allowLoad = YES;
    self.navigation.title.text = self.viewTitle;
    self.navigation.delegate = self;
    
    NSString *urlAddress = self.url;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.content loadRequest:requestObj];
    
    self.content.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    [self showHud];
    return self.allowLoad;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self hideHud];
    self.allowLoad = NO;
}



- (void) leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
