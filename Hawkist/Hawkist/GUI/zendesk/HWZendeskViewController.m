//
//  HWZendeskViewController.m
//  Hawkist
//
//  Created by User on 02.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "HWZendeskViewController.h"
#import <ZendeskSDK/ZendeskSDK.h>

@interface HWZendeskViewController ()

@end

@implementation HWZendeskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCreatingTicket];
    
    [[ZDKConfig instance] initializeWithAppId:@"475beb8068c9472bda4f61c986e4ed6de28c120465e512aa"
                                   zendeskUrl:@"https://hawkist.zendesk.com"
                                     ClientId:@"mobile_sdk_client_017b0642674c40d7b0e0"
                                    onSuccess:^() {
                                        
                                        [self jwtIdentify];
                                        //[ZDKRequests showRequestCreationWithNavController:self.navigationController];
                                        NSArray *labels = @[@"ios", @"ios8"];
                                        [ZDKHelpCenter showHelpCenterWithNavController:self.navigationController filterByArticleLabels:labels];
                                        
                                        NSLog(@"Yes");
                                    } onError:^(NSError *error) {
    
                                        NSLog(@"%@", error.description);
    
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) jwtIdentify {
    
    ZDKJwtIdentity * jwtUserIdentity = [[ZDKJwtIdentity alloc] initWithJwtUserIdentifier:[AppEngine shared].user.id];
    
    [ZDKConfig instance].userIdentity = jwtUserIdentity;
}



- (void) setupCreatingTicket {
    
    [[ZDKCreateRequestView appearance] setPlaceholderTextColor:[UIColor lightGrayColor]];
    [[ZDKCreateRequestView appearance] setTextEntryColor:[UIColor whiteColor]];
    [[ZDKCreateRequestView appearance] setTextEntryBackgroundColor:[UIColor blackColor]];
    [[ZDKCreateRequestView appearance] setViewBackgroundColor:[UIColor blackColor]];
    [[ZDKCreateRequestView appearance] setTextEntryFont:[UIFont systemFontOfSize:12.0f]];
    
    [[ZDKCreateRequestView appearance] setAttachmentButtonImage:[ZDKBundleUtils imageNamed:@"icoAttach" ofType:@"png"]];
    [[ZDKCreateRequestView appearance] setAttachmentButtonBackground:[UIColor blackColor]];
    [[ZDKCreateRequestView appearance] setAttachmentButtonBorderColor:[UIColor darkGrayColor]];
    [[ZDKCreateRequestView appearance] setAttachmentButtonBorderWidth:@2];
    [[ZDKCreateRequestView appearance] setAttachmentButtonCornerRadius:@10];
    
    [[ZDKCreateRequestView appearance] setAutomaticallyHideNavBarOnLandscape:@1];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [[ZDKCreateRequestView appearance] setSpinner:(id<ZDKSpinnerDelegate>)spinner];
}


- (void) setupFeedbackView {
    
    [[ZDKRMAFeedbackView appearance] setHeaderFont:[UIFont systemFontOfSize:16.0f]];
    [[ZDKRMAFeedbackView appearance] setSubheaderFont:[UIFont systemFontOfSize:12.0f]];
    [[ZDKRMAFeedbackView appearance] setSeparatorLineColor:[UIColor colorWithWhite:0.2627f alpha:1.0f]];
    [[ZDKRMAFeedbackView appearance] setButtonBackgroundColor:[UIColor blackColor]];
    [[ZDKRMAFeedbackView appearance] setButtonColor:[UIColor whiteColor]];
    [[ZDKRMAFeedbackView appearance] setButtonSelectedColor:[UIColor grayColor]];
    [[ZDKRMAFeedbackView appearance] setButtonFont:[UIFont systemFontOfSize:14.0f]];
    [[ZDKRMAFeedbackView appearance] setTextEntryFont:[UIFont systemFontOfSize:12.0f]];
    [[ZDKRMAFeedbackView appearance] setHeaderColor:[UIColor whiteColor]];
    [[ZDKRMAFeedbackView appearance] setSubHeaderColor:[UIColor whiteColor]];
    [[ZDKRMAFeedbackView appearance] setTextEntryColor:[UIColor whiteColor]];
    [[ZDKRMAFeedbackView appearance] setTextEntryBackgroundColor:[UIColor blackColor]];
    [[ZDKRMAFeedbackView appearance] setViewBackgroundColor:[UIColor blackColor]];
    [[ZDKRMAFeedbackView appearance] setPlaceHolderColor:[UIColor grayColor]];
}

-(void) setupRequestList {
    
    // request list
    [[ZDKRequestListTable appearance] setTableBackgroundColor:[UIColor blackColor]];
    [[ZDKRequestListTable appearance] setBackgroundColor:[UIColor blackColor]];
    [[ZDKRequestListTable appearance] setCellSeparatorColor:[UIColor darkGrayColor]];
    [[UIScrollView appearanceWhenContainedIn:[ZDKRequestListViewController class], nil] setBackgroundColor:[UIColor blackColor]];
    
    // loading cell
    UIActivityIndicatorView * requestListSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    requestListSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [[ZDRequestListLoadingTableCell appearance] setSpinner:(id<ZDKSpinnerDelegate>)requestListSpinner];
    
    // request list cells
    [[ZDKRequestListTableCell appearance] setDescriptionFont:[UIFont systemFontOfSize:15]];
    [[ZDKRequestListTableCell appearance] setCreatedAtFont:[UIFont systemFontOfSize:13]];
    [[ZDKRequestListTableCell appearance] setUnreadColor:[UIColor colorWithRed:0.47059 green:0.6392 blue:0 alpha:1.0]];
    [[ZDKRequestListTableCell appearance] setDescriptionColor:[UIColor colorWithWhite:0.88f alpha:1.0f]];
    [[ZDKRequestListTableCell appearance] setCreatedAtColor:[UIColor lightGrayColor]];
    [[ZDKRequestListTableCell appearance] setVerticalMargin:@20.0f];
    [[ZDKRequestListTableCell appearance] setDescriptionTimestampMargin:@5.0f];
    [[ZDKRequestListTableCell appearance] setLeftInset:@25.0f];
    [[ZDKRequestListTableCell appearance] setCellBackgroundColor:[UIColor blackColor]];
    
    // no requests cell
    [[ZDRequestListEmptyTableCell appearance] setMessageFont:[UIFont systemFontOfSize:11.0f]];
    [[ZDRequestListEmptyTableCell appearance] setMessageColor:[UIColor lightGrayColor]];

}


- (void) setupAgentPoint {
    
    [[ZDKAgentCommentTableCell appearance] setAvatarSize:@40.0f];
    [[ZDKAgentCommentTableCell appearance] setAgentNameFont:[UIFont systemFontOfSize:14.0f]];
    [[ZDKAgentCommentTableCell appearance] setAgentNameColor:[UIColor lightGrayColor]];
    [[ZDKAgentCommentTableCell appearance] setTimestampFont:[UIFont systemFontOfSize:11.0f]];
    [[ZDKAgentCommentTableCell appearance] setTimestampColor:[UIColor blackColor]];
    [[ZDKAgentCommentTableCell appearance] setBodyFont:[UIFont systemFontOfSize:15.0f]];
    [[ZDKAgentCommentTableCell appearance] setBodyColor:[UIColor colorWithWhite:0.88f alpha:1.0f]];
    [[ZDKAgentCommentTableCell appearance] setCellBackground:[UIColor darkGrayColor]];
    
    // comments list end user comment cells
    [[ZDKEndUserCommentTableCell appearance] setTimestampFont:[UIFont systemFontOfSize:11.0f]];
    [[ZDKEndUserCommentTableCell appearance] setTimestampColor:[UIColor darkGrayColor]];
    [[ZDKEndUserCommentTableCell appearance] setBodyFont:[UIFont systemFontOfSize:15.0f]];
    [[ZDKEndUserCommentTableCell appearance] setBodyColor:[UIColor colorWithWhite:0.88f alpha:1.0f]];
    [[ZDKEndUserCommentTableCell appearance] setCellBackground:[UIColor colorWithWhite:0.10f alpha:1.0f]];
    
    // comments list loading cell
    UIActivityIndicatorView *commentSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    commentSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    commentSpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
   // [[ZDKCommentsListLoadingTableCell appearance] setSpinner:(id<ZDKSpinnerDelegate>)spinner];
    [[ZDKCommentsListLoadingTableCell appearance] setCellBackground:[UIColor blackColor]];
    [[ZDKCommentsListLoadingTableCell appearance] setLeftInset:@25.0f];
    
    // comment input area
    [[ZDKCommentInputView appearance] setTopBorderColor:[UIColor colorWithWhite:0.11f alpha:1.0f]];
    [[ZDKCommentInputView appearance] setTextEntryFont:[UIFont systemFontOfSize:15]];
    [[ZDKCommentInputView appearance] setTextEntryColor:[UIColor colorWithWhite:0.88f alpha:1.0f]];
    [[ZDKCommentInputView appearance] setTextEntryBackgroundColor:[UIColor darkGrayColor]];
    [[ZDKCommentInputView appearance] setTextEntryBorderColor:[UIColor lightGrayColor]];
    [[ZDKCommentInputView appearance] setSendButtonFont:[UIFont systemFontOfSize:12]];
    [[ZDKCommentInputView appearance] setSendButtonColor:[UIColor whiteColor]];
    [[ZDKCommentInputView appearance] setAreaBackgroundColor:[UIColor blackColor]];
    [[ZDKCommentInputView appearance] setBackgroundColor:[UIColor blackColor]];
    [[UITableView appearance] setSeparatorColor:[UIColor lightGrayColor]];
    [[UITableView appearance] setBackgroundColor:[UIColor blackColor]];
    
    //Comments list attachments
    [[ZDKRequestCommentAttachmentLoadingTableCell appearance] setBackgroundColor:[UIColor darkGrayColor]];
    [[ZDKCommentsListLoadingTableCell appearance] setBackgroundColor:[UIColor darkGrayColor]];
    [[ZDKRequestCommentAttachmentTableCell appearance] setBackgroundColor:[UIColor blackColor]];
    [[ZDKUILoadingView appearance] setBackgroundColor:[UIColor darkGrayColor]];
    
    
    //Image viewer
    [[ZDKAttachmentView appearance] setBackgroundColor:[UIColor blackColor]];
    [[ZDKAttachmentView appearance] setCloseButtonBackgroundColor:[UIColor blackColor]];
    [[ZDKUIImageScrollView appearance] setBackgroundColor:[UIColor blackColor]];

}

- (void) setupSupportView {
    
    UIActivityIndicatorView *hcSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
   // spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    [[ZDKSupportView appearance] setSpinner:(id<ZDKSpinnerDelegate>)hcSpinner];
    
    [[ZDKSupportView appearance] setViewBackgroundColor:[UIColor blackColor]];
    [[ZDKSupportView appearance] setTableBackgroundColor:[UIColor blackColor]];
    [[ZDKSupportView appearance] setSearchBarStyle:@(UIBarStyleBlack)];
    [[ZDKSupportView appearance] setSeparatorColor:[UIColor darkGrayColor]];
    [[ZDKSupportView appearance] setNoResultsFoundLabelFont:[UIFont systemFontOfSize:14.0f]];
    [[ZDKSupportView appearance] setNoResultsFoundLabelColor:[UIColor lightGrayColor]];
    [[ZDKSupportView appearance] setNoResultsFoundLabelBackground:[UIColor blackColor]];
    [[ZDKSupportView appearance] setNoResultsContactButtonBackground:[UIColor blackColor]];
    [[ZDKSupportView appearance] setNoResultsContactButtonBorderColor:[UIColor colorWithWhite:0.2627f alpha:1.0f]];
    [[ZDKSupportView appearance] setNoResultsContactButtonBorderWidth:@1.0f];
    [[ZDKSupportView appearance] setNoResultsContactButtonCornerRadius:@4.0f];
    [[ZDKSupportView appearance] setNoResultsFoundLabelFont:[UIFont systemFontOfSize:14.0f]];
    [[ZDKSupportView appearance] setNoResultsContactButtonEdgeInsets:[NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(12, 22, 12, 22)]];
    [[ZDKSupportView appearance] setNoResultsContactButtonTitleColorNormal:[UIColor whiteColor]];
    [[ZDKSupportView appearance] setNoResultsContactButtonTitleColorHighlighted:[UIColor whiteColor]];
    [[ZDKSupportView appearance] setNoResultsContactButtonTitleColorDisabled:[UIColor whiteColor]];
    
    //HC search cell
    [[ZDKSupportTableViewCell appearance] setViewBackgroundColor:[UIColor blackColor]];
    [[ZDKSupportTableViewCell appearance] setTitleLabelBackground:[UIColor blackColor]];
    [[ZDKSupportTableViewCell appearance] setTitleLabelColor:[UIColor colorWithWhite:0.88f alpha:1.0f]];
    [[ZDKSupportTableViewCell appearance] setTitleLabelFont:[UIFont systemFontOfSize:18.0f]];
    
    [[ZDKSupportArticleTableViewCell appearance] setViewBackgroundColor:[UIColor blackColor]];
    [[ZDKSupportArticleTableViewCell appearance] setArticleParentsLabelFont:[UIFont systemFontOfSize:12.0f]];
    [[ZDKSupportArticleTableViewCell appearance] setArticleParentsLabelColor:[UIColor darkGrayColor]];
    [[ZDKSupportArticleTableViewCell appearance] setArticleParnetsLabelBackground:[UIColor blackColor]];
    [[ZDKSupportArticleTableViewCell appearance] setTitleLabelFont:[UIFont systemFontOfSize:18.0f]];
    [[ZDKSupportArticleTableViewCell appearance] setTitleLabelColor:[UIColor colorWithWhite:0.2627f alpha:1.0f]];
    [[ZDKSupportArticleTableViewCell appearance] setTitleLabelBackground:[UIColor blackColor]];
    
    [[ZDKSupportAttachmentCell appearance] setBackgroundColor:[UIColor darkGrayColor]];
    [[ZDKSupportAttachmentCell appearance] setTitleLabelBackground:[UIColor darkGrayColor]];
    [[ZDKSupportAttachmentCell appearance] setTitleLabelColor:[UIColor lightGrayColor]];
    [[ZDKSupportAttachmentCell appearance] setTitleLabelFont:[UIFont systemFontOfSize:12.0f]];
    [[ZDKSupportAttachmentCell appearance] setFileSizeLabelBackground:[UIColor darkGrayColor]];
    [[ZDKSupportAttachmentCell appearance] setFileSizeLabelColor:[UIColor lightGrayColor]];
    [[ZDKSupportAttachmentCell appearance] setFileSizeLabelFont:[UIFont systemFontOfSize:12.0f]];

}


@end
