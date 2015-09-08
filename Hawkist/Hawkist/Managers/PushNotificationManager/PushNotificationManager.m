//
//  PushNotificationManager.m
//  Hawkist
//
//  Created by Anton on 03.09.15.
//  Copyright (c) 2015 TecSynt Solutions. All rights reserved.
//

#import "PushNotificationManager.h"
#import "HWCommentViewController.h"
#import "ViewItemViewController.h"
#import "HWMyOrdersViewController.h"
#import "HWFeedBackViewController.h"
#import "HWMyBalanceViewController.h"
#import "HWLeaveFeedbackViewController.h"
#import "HWProfileViewController.h"
#import "BuyThisItemViewController.h"
#import "HWTapBarViewController.h"

@implementation PushNotificationManager

+ (instancetype) shared
{
    static PushNotificationManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[PushNotificationManager alloc] init];
    });
    return sharedManager;
}

- (void) handleNotification:(NSDictionary *)userInfo andNavigationController:(UINavigationController*)navigationController
{
    switch ([userInfo[@"type"] integerValue]) {
        case 11: case 10: case 0:
        {
            [[NetworkManager shared] getItemById:userInfo[@"listing_id"]
                                    successBlock:^(HWItem *item) {
                                        HWCommentViewController* vc = [[HWCommentViewController alloc]initWithItem:item];
                                        
                                        [navigationController pushViewController:vc animated:YES];
                                        
                                    } failureBlock:^(NSError *error) {
                                        
                                    }];
            break;
        }
        case 7: case 9:
        {
            [[NetworkManager shared] getItemById:userInfo[@"listing_id"]
                                    successBlock:^(HWItem *item) {
                                        ViewItemViewController *vc = [[ViewItemViewController alloc]initWithItem:item];
                                        
                                        [navigationController pushViewController:vc animated:YES];
                                        
                                    } failureBlock:^(NSError *error) {
                                        
                                    }];
            break;
        }
        case 1:
        {
            
            if ([HWTapBarViewController class] == [navigationController.visibleViewController class])
            {
                [((HWTapBarViewController*)navigationController.visibleViewController) setTab:1];
                
            }
            else
            {
            HWTapBarViewController *vc = [[HWTapBarViewController alloc]init];

            [navigationController pushViewController:vc animated:YES];
            
            [vc setTab:1];
            }
            break;
        
        }
        case 2:
        {
            HWMyOrdersViewController *vc = [[HWMyOrdersViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 3:
        {
            HWFeedBackViewController *vc = [[HWFeedBackViewController alloc]initWithUserID:[AppEngine shared].user.id withStatus:[userInfo[@"feedback_type"] integerValue]];
                                            
            [navigationController pushViewController:vc animated:YES];
            break;
        }
            
        case 4:
        {
            HWMyBalanceViewController  *vc = [[HWMyBalanceViewController alloc]init];
            [navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:
        {
            
            if ([userInfo[@"order_available_feedback"] boolValue])
            {
                HWLeaveFeedbackViewController *vc = [[HWLeaveFeedbackViewController alloc]initWithUserID: userInfo[@"order_available_feedback"] withOrderId:userInfo[@"order_id"]];
                
                [navigationController pushViewController:vc animated:YES];
            }
            
            else
            {
            
            }
            break;
        }
        case 6: case 8:
        {
            HWProfileViewController *vc = [[HWProfileViewController alloc]initWithUserID:userInfo[@"user_id"]];
            
            
            [navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 12:case 13:
        {
            [[NetworkManager shared] getItemById:userInfo[@"listing_id"]
                                    successBlock:^(HWItem *item) {
                                        BuyThisItemViewController *vc = [[BuyThisItemViewController alloc]initWithItem:item];
                                        
                                        [navigationController pushViewController:vc animated:YES];
                                        
                                    } failureBlock:^(NSError *error) {
                                        
                                    }];
            break;
            
        }
        default:
            break;
    }

    
    
}
@end
